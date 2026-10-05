import express from "express";
import { dirname } from "path";
import { fileURLToPath } from "url";
import cors from "cors";
import pool from "./common/config/db.js";
import authRoute from "./modules/auth/auth.routes.js";
import bookRoute from "./modules/book/book.routes.js";
import resetRoute from "./modules/reset/reset.routes.js"
import { login } from "./modules/auth/auth.service.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

const app = new express();

// ---> CORS Middleware Browser ko batata hai ki kaun-kaun si Origins hamare Server ko access kar sakti hain. "origin:http://127.0.0.1:3000" ka matlab ha ki sirf http://127.0.0.1:3000 ko Response access karne ki permission hai.

// ---> Agar aisa likh do: app.use(cors());
// ---> To iska Matlab ye hai ki Server sabhi Origins ko apna Respone access karne ki permission de raha hai. 
// ---> Ye development tak thik hai, lekin Production mein sirf trusted Origins ko hi allow karna chahiye.

app.use(cors({origin: 'http://127.0.0.1:3000'})); 
app.use(express.json());

// TODO
app.use('/api/auth', authRoute);
app.use('/book', bookRoute);
app.use('/reset', resetRoute);

// home-page
app.get("/", (req, res) => {
  res.sendFile(__dirname + "/index.html");
});

// login-page
app.get("/login", (req, res) => {
  res.sendFile(__dirname + "/login.html");
});

// register-page
app.get("/register", (req, res) => {
    res.sendFile(__dirname + "/register.html");
})

// password-reset-page
app.get("/password-reset", (req, res) => {
    res.sendFile(__dirname + "/resetPwd.html");
});

//get all seats
app.get("/seats", async (req, res) => {
  const result = await pool.query("select * from seats"); // equivalent to Seats.find() in mongoose
  res.send(result.rows);
});

// ✅ Global Error Middleware (Always keep it at the end)
app.use((err, req, res, next) => {
    console.error(err);

    res.status(err.statusCode || 500).json({
        message: err.message || "Internal Server Error"
    });
});

export default app;



// FOR EXTRA INFORMATION:-
// app.put('/reset', async(req, res)=>{
//     const conn = await pool.connect();

//     try{
//         const sql = "UPDATE seats SET is_booked=0, name=NULL WHERE is_booked=1";
//         const result = await conn.query(sql);
//         res.json({message: "Database reset successfully."});
//     }
//     catch(err){
//         res.status(500).json({ message: "Something went wrong." });
//     }
//     finally{
//         conn.release();
//     }
// });