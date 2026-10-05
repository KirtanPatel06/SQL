import ApiResponse from "../../common/utils/api-response.js";
import * as authService from './reset.service.js';

const resetPassword = async(req, res) => {
    await authService.resetPassword(req.body);
    ApiResponse.ok(res, "Password reset Successfully !");
}

const resetDB = async(req, res, next) => {
    try{
        await authService.resetDB();
        ApiResponse.ok(res, "All seats are now EMPTY !");
    }
    catch(err){
        next(err);
    }
}

export {resetPassword, resetDB};