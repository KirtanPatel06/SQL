import express from 'express';
import {Router} from 'express';
import authenticate from './book.middleware.js';
import { BookDto } from './dto/book.dto.js';
import * as controller from './book.controller.js';
import validate from '../../common/middleware/validate.middleware.js';

const router = new Router();

router.put('/:id', authenticate, validate(BookDto), controller.bookSeat);

export default router;