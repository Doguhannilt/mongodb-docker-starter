const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");

const port = process.env.CONTAINER_PORT
const app = express()
app.use(bodyParser.json());
app.get("/health", (req,res) => {
    res.status(200).send("OK Health"); 
})
console.log("Connecting to DB")
mongoose.connect(`mongodb://${process.env.MONGODB_HOST}/${process.env.KEY_VALUE_DB}`, {
    auth: {
        username: process.env.KEY_VALUE_USER,
        password: process.env.KEY_VALUE_PASSWORD
    },
    connectTimeoutMS: 500
}).then(() => {
    app.listen(port || 3000);
    console.log("Connected to MongoDB");
}).catch((err) => {
    console.log("Something went wrong")
    console.log(err);
})


