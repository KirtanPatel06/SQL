import * as authService from './auth.service.js';
import ApiResponse from '../../common/utils/api-response.js';

const register = async(req, res) => {
    const user = await authService.register(req.body);
    ApiResponse.created(res, "User Registered Successfully !", user);
}

const login = async(req, res) => {
    const user = await authService.login(req.body);
    ApiResponse.ok(res, "Logged-in Successfully !", user);
}

export {register, login};