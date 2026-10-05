import ApiError from "../utils/api-error.js";

const validate = (DtoClass) => {
    return (req, res, next) => {
        const { errors, value } = DtoClass.validate(req.body);

        if (errors)
            throw ApiError.badRequest(errors.join("; "));

        // Replace the original 'req.body' set by the 'user' from 'frontend' by the sanitized data returned by Joi in the 'value'.
        // Example: { name: "  Rahul  ", email: "RAHUL@GMAIL.COM" }
        // After using trim(), lowercase(), etc. in DTO the data becomes.
        // becomes:  { name: "Rahul", email: "rahul@gmail.com" }

        req.body = value;
        
        next();
    }
}

export default validate;

