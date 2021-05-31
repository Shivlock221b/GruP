const { Schema } = require("mongoose");
let {mongoose} = require("./db");

let chatSchema = mongoose.Schema({


    textChain: {
       default: undefined,
       type :  [{
        time: String,
        sender: String,
        message: String
        }]
    }
});

const chatModel = mongoose.model("chatmodel", chatSchema);
module.exports = chatModel;