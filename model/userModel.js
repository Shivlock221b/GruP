let {mongoose} = require("./db");
let socket = require("socket.io");
const chatModel = require("./chatModel");
//const {broadcastSchema} = require("./broadcast")
//const eventSchema = require("./eventModel")
//const groupSchema = require("./groupModel")

let chatsSchema = mongoose.Schema({

    chatId: {
        type: String
    },

    name: {
        type: String
    },

    members: {
        type: Map,
        of : String,
        default: {}
    },

    count: {
        type: Number,
        default: 0
    },

    // createdAt: {
    //     type: Date,
    //     expires: 120,
    //     default: Date.now,
    //     unique: false
    // }
})

// chatsSchema.post('save', function(doc) {
//     if (doc.createdAt && doc.createdAt.expires) {
//         setTimeout(doc.remove(), doc.createdAt.expires * 1000)
//     }
// })

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
        type: Object,
        //require: true,
        //default: "Agra, India"
    },

    friends: {
        type: Array,
        of: Object
    },

    Country: {
        type: String,
        default: ""
    },

    Locality: {
        type: String,
        default: ""
    },

    profilepic: {
        type: String,
        default: "icon.png",
    },

    tags: {
        type: Array,
        default: []
        //require: true,
    },
    // chats: {
    //     type: Map,
    //     of: String,
    //     default: {}
    // },

    chats: [chatsSchema],

    socketId: {
        type: String,
        //default: null
        unique: true
    },

    count: {
        type: Number,
        default: 0
    },

    broadcasts : {
        type: Array,
        of: Object,
        default: []
    },

    events: {
        type: Array,
        of: Object,
        default: []
    },

    groups: {
        type: Array,
        of: Object ,
        default: []
    }
});

const chatsModel = mongoose.model("chats", chatsSchema)

// chatModel.createIndexes({'createdAt' : 1}, function(err, data) {
//     console.log(err);
//     console.log(data)
// })

const userModel = mongoose.model("user", userSchema);

module.exports.userModel = userModel;
module.exports.chatsModel = chatsModel;
