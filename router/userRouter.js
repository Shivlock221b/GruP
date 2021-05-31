const {createUser, checkUser,updateUser} = require("../controller/userController");
const express = require("express");
const { session } = require("passport");

const userRouter = express.Router();


userRouter.route("/signup").post(createUser);
userRouter.route("/login").post(checkUser);
userRouter.route("").patch(updateUser);

module.exports = userRouter;