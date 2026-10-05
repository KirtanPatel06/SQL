import express from 'express';
import {Router} from 'express';
import validate from '../../common/middleware/validate.middleware.js';
import resetPasswordDto from './dto/resetPwd.dto.js';
import * as controller from './reset.controller.js';

const router = new Router();

router.patch('/password-reset', validate(resetPasswordDto), controller.resetPassword);

router.put('/db-reset', controller.resetDB);

export default router;