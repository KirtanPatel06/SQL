import db from "../../db/index.js"
import { userTable } from "../../db/schema.js"
import ApiError from "../../common/utils/api-error.js";
import * as tokens from '../../common/utils/jwt.utils.js';
import {createHmac, randomBytes} from 'node:crypto';
import { eq } from 'drizzle-orm';


const register = async({name, email, password}) => {
    const existingUser = await db.select().from(userTable).where(eq(userTable.email, email));

    if(existingUser.length > 0) 
        throw new ApiError.conflict("User with this e-mail already exists !");

    const salt = randomBytes(32).toString('hex');
    const hash = createHmac('sha256', salt).update(password).digest('hex');

    // Using destructuring
    const [user] = await db.insert(userTable).values({
        name,
        email,
        password: hash,
        salt
    }).returning({id: userTable.id, name: userTable.name});

    return user;
}


const login = async({email, password}) => {
    const [user] = await db.select().from(userTable).where(eq(userTable.email, email));

    if(!user)
        throw ApiError.unauthorized("Invalid e-mail or password !");

    const salt = user.salt;
    const hash = createHmac('sha256', salt).update(password).digest('hex');

    if(user.password !== hash){
        throw ApiError.unauthorized("Invalid e-mail or password !");
    }

    // Token banao
    const token = tokens.createAccessToken({id: user.id});

    return{
        id: user.id,
        name: user.name,
        token
    }
}

export {register, login};