import express from 'express';
import {Router} from 'express';
import RegisterDto from './dto/register.dto.js';
import * as controller from './auth.controller.js';
import validate from '../../common/middleware/validate.middleware.js';
import LoginDto from './dto/login.dto.js';

const router = Router();

router.post('/register', validate(RegisterDto), controller.register);

router.post('/login', validate(LoginDto), controller.login);

export default router;