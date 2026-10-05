import db from "../../db/index.js"
import { sql } from "drizzle-orm";
import ApiError from "../../common/utils/api-error.js";

const bookSeat = async(req, res) => {
    try{
        const seatId = Number(req.params.id);
        const name = req.user.name;

        const result = await db.transaction(async (tx) => {

            // Lock the row
            const seat = await tx.execute(
                sql`SELECT * FROM seats WHERE id = ${seatId} AND is_booked = 0 FOR UPDATE`);

            if (seat.rows.length === 0) {
                throw ApiError.conflict("Seat already booked!");
            }

            // Book the seat
            const updatedSeat = await tx.execute(
                sql`UPDATE seats SET is_booked = 1, name = ${name} WHERE id = ${seatId} RETURNING *;
                `);

            return updatedSeat.rows[0];
        });

        return result;
    }
    catch (err) {
        console.error(err);
        throw err;
    }
}

export {bookSeat};