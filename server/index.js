const express = require("express");
const app = express();
require("dotenv").config();
const userRouter = require("./api/users/user_router");
// const path = require("path");
// const bodyParser = require("body-parser");
// import { auth } from "./authMiddleware.js";

app.use(express.json());
app.use("/api/users", userRouter);
app.listen(8000, function () {
  console.log("listening on 8000");
});
