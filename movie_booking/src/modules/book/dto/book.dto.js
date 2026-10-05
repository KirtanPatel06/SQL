import Joi from 'joi';
import BaseDto from '../../../common/dto/base.dto.js';

export class BookDto extends BaseDto{
    static schema = Joi.object({
        id: Joi.string().uuid().required() 
    });
}