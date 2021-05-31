let {mongoose} = require("./db");
let socket = require("socket.io");

let userSchema = mongoose.Schema({

    name: {
        type: String,
        require: true,
    },

    userName: {
        type: String,
        require: true,
        unique: true,
    },

    email: {
        type: String,
        require: true,
        unique: true,
    },

    password: {
        type: String,
        require: true,
        minlength: [8, "Password must be greater than 8 characters"]
    },

    location: {
        type: String,
        require: true,
        default: "Agra, India"
    },

    profilepic: {
        type: String,
        default: "icon.png",
    },

    tags: {
        type: Array
        //require: true,
    },
    chats: {
        type: Map,
        of: String,
        default: {}
    },

    socketId: {
        type: String,
        default: null
    }
});

const userModel = mongoose.model("user", userSchema);

module.exports = userModel;
