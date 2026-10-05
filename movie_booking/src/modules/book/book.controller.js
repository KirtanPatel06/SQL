import * as authService from "./book.service.js";
import ApiResponse from "../../common/utils/api-response.js";

const bookSeat = async(req, res, next) => {
    try{
        const result = await authService.bookSeat(req, res);
        ApiResponse.ok(res, "Seat Booked Successfully !", result);
    }
    catch(err){
        next(err);
    }
}

export {bookSeat};