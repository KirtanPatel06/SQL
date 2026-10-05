import ApiError from "../../common/utils/api-error.js";
import db from "../../db/index.js";
import { sql } from "drizzle-orm";
import { userTable } from "../../db/schema.js";
import { eq } from "drizzle-orm";
import { createHmac, randomBytes } from "node:crypto";

const resetPassword = async ({ email, newPassword }) => {
    const [user] = await db.select().from(userTable).where(eq(userTable.email, email));

    console.log(user);

    if (!user)
        throw ApiError.notFound("User not found !");

    const newSalt = randomBytes(32).toString('hex');
    const newHashedPwd = createHmac('sha256', newSalt).update(newPassword).digest('hex');

    await db.update(userTable).set({
        password: newHashedPwd,
        salt: newSalt
    }).where(eq(userTable.email, email));

    return;
}

const resetDB = async () => {
    await db.execute(sql`UPDATE seats SET is_booked=0, name=NULL WHERE is_booked=1`);
    
    return;
}

export { resetPassword, resetDB };