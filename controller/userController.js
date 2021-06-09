const userModel = require("../model/userModel");
const jwt = require("jsonwebtoken");
const config = require("../config/secrets");
const { json } = require("body-parser");


async function createUser(request, response) {
    try{
        let userDetails = request.body;
        //console.log(request);
        console.log(request.body);
        let queryUser = await userModel.find({email: userDetails.email,},);
        if (queryUser.length > 0) {
            response.json({
                message: "User already exists",
                queryUser
            })
        } else {
            let userCreated = await userModel.create(userDetails.data);
            response.json({
                message: "Successfully created user",
                userCreated
            })
        }
    } catch(error) {
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
            const token = jwt.sign({id: loggedInUser["_id"]}, config.SECRET_KEY, {expiresIn: 86400 * 7 });
            response.json({
                message: "User found, logged in",
                queryUser,
                token
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
