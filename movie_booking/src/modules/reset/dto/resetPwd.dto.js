import Joi from "joi";
import BaseDto from "../../../common/dto/base.dto.js";

class resetPasswordDto extends BaseDto{
    static schema = Joi.object({
        email: Joi.string().email().trim().lowercase().required(),
        newPassword: Joi.string().trim().min(8).message("Password should be of min. 8 chars").required()
    });
}

export default resetPasswordDto;