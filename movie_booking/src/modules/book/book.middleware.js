import { eq } from "drizzle-orm";
import ApiError from "../../common/utils/api-error.js";
import * as tokens from "../../common/utils/jwt.utils.js"
import db from "../../db/index.js";
import { userTable } from "../../db/schema.js";

const authenticate = async (req, res, next) => {
    let token;

    // console.log(req.headers.authorization);

    if(req.headers.authorization?.startsWith('Bearer '))
        token = req.headers.authorization.split(" ")[1];

    if(!token)
        throw ApiError.unauthorized("Please Log-in to book the seat !");

    try{
        const decoded = tokens.verifyAccessToken(token);
        // console.log(decoded);
        const [user] = await db.select().from(userTable).where(eq(userTable.id, decoded.id));
        // console.log(user);

    if(!user)
        throw ApiError.unauthorized("User no longer exists !");

    req.user = {
        name: user.name
    }

    next();
    }
    catch(err){
        next(ApiError.unauthorized("Session Expired. Please login again !"));
    }
}

export default authenticate;