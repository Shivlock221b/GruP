let {mongoose} = require("./db");
const mongoose_ttl = require("mongoose-ttl");

let broadcastSchema = mongoose.Schema({

    sender: {
        type: Object
    }, 

    content: {
        type: Object
    },

    location: {
        type: Object
    },

    Country: {
        type: String
    },

    locality: {
        type: String
    },

    tags: {
        type: Array
    },

    createdAt: {
        type: Date,
        expires: 86400,
        default: Date.now,
        unique: false
    },
})

//broadcastSchema.expires = 120;


//broadcastSchema.index({"lastModifiedDate" : 1}, {expireAfterSeconds: 120});


const broadcastModel = mongoose.model('broadcast', broadcastSchema);

broadcastModel.createIndexes({'createdAt' : 1}, function(err, data) {
    console.log(err)
    console.log(data)
})


module.exports = broadcastModel;