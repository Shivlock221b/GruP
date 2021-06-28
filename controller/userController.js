const {userModel} = require("../model/userModel");
const jwt = require("jsonwebtoken");
const config = require("../config/secrets");
const { json } = require("body-parser");
//const io = require("../app");


async function createUser(request, response) {
    try{
        let userDetails = request.body.data;
        //console.log(request);
        console.log(userDetails);
        console.log(userDetails.email);
        //console.log(userDetails.chats);
        let queryUser = await userModel.find({email: userDetails.email,},);
        console.log("appear")
        if (queryUser.length > 0) {
            console.log("123")
            response.json({
                message: "User already exists",
                queryUser
            })
        } else {
            console.log("1244235")
            //let newChat = await chatsModel.create()
            let userCreated = await userModel.create(userDetails);
            response.json({
                message: "Successfully created user",
                userCreated
            })
        }
    } catch(error) {
        console.log("12345")
        response.json({
            message: "Failed to created user. Try again with different details",
            error
        })
    }
}

async function checkUser(request, response) {
    try {
        let userDetails = request.body.data;
        console.log(request.body);
        // let filteredUsers = await userModel.find({tags: {$in: ["National University of Singapore"], $all: ["BasketBall"]}});
        let queryUser = await userModel.find({userName: userDetails["userName"], password: userDetails['password']});
        console.log(queryUser);
        if (queryUser.length) {
            let loggedInUser = queryUser[0];
            let socketId = loggedInUser.socketId;
            console.log(socketId)
            //let namespace = null;
            // let ns = io.of('/')
            // print("hello")
            // let socket = ns.connected[socketId]
            const token = jwt.sign({id: loggedInUser["_id"]}, config.SECRET_KEY, {expiresIn: 86400 * 7 });
            response.json({
                message: "User found, logged in",
                queryUser,
                token,
            })
        } else {
            response.statusCode = 401;
            response.json({
                message: "inconrrect details, no such user",
                userDetails
            })
        }
    }catch(error) {
        response.statusCode = 401;
        response.json({
            message: "Failed to get user. Try again",
            error
        })
    }
}

async function updateUser(request, response) {
    try {
        console.log(request);
        let updateDetails = request.body;
        console.log(updateDetails['tags']);
        let user = await userModel.find({'userName' : "Vinita"});
        console.log(user[0]);
        //user['tags'] = updateDetails['tags'];
        //console.log(user['tags']);
        let updatedUser = await userModel.updateOne(user[0], {$set: {tags: updateDetails['tags']}});
        console.log(updatedUser);
        response.json({
            message: "User updated successfully",
            updatedUser
        })
    } catch(error) {
        console.log(error);
        response.statusCode = 401;
        response.json({
            message: "Failed to update User, try again",
            error
        })
    }
}

module.exports.createUser = createUser;
module.exports.checkUser = checkUser;
module.exports.updateUser = updateUser;
