import Joi from 'joi';
import BaseDto from '../../../common/dto/base.dto.js';

class RegisterDto extends BaseDto{
    static schema = Joi.object({
        name: Joi.string().trim().min(2).max(50).required(),
        email: Joi.string().trim().email().lowercase().required(),
        password: Joi.string().min(8).message("Password should be of min. 8 chars").required(),
    });
}

export default RegisterDto;