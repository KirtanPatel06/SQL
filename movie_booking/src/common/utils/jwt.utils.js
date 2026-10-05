import crypto from 'crypto';
import JWT from 'jsonwebtoken';
import "dotenv/config";

const createAccessToken = (payload) => {
    const token = JWT.sign(payload, process.env.JWT_ACCESS_SECRET, {
        expiresIn: process.env.JWT_ACCESS_EXPIRES_IN || '15m'
    });
    return token;
}

const verifyAccessToken = (token) => {
    const payload = JWT.verify(token, process.env.JWT_ACCESS_SECRET);
    return payload;
}

export {createAccessToken, verifyAccessToken};