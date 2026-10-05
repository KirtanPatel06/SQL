import app from './src/app.js';

const port = process.env.PORT || 8080;

const start = async() => {
    app.listen(port, () => console.log("Server started on port: " + port));
}

start().catch((err) => {
    console.log("Failed to start server !", err);
    process.exit(1);
});