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

    expirationTime: {
        type: Date,
        expires: 0
    },

    createdAt: {
        type: Date,
        expires: 86400,
        default: Date.now,
        unique: false
    },

    isBroadcasting: {
        type: Boolean,
        default: true
    },

    endorse: {
        default: 0,
        type: Number
    },

    comments: {
        type: Array,
        of: Object
    }
})

//broadcastSchema.expires = 120;


//broadcastSchema.index({"lastModifiedDate" : 1}, {expireAfterSeconds: 120});


const broadcastModel = mongoose.model('broadcast', broadcastSchema);

broadcastModel.createIndexes({'createdAt' : 1}, function(err, data) {
    console.log(err)
    console.log(data)
})

// broadcastModel.createIndexes({'expirationTime' : 1}, function(err, data) {
//     console.log(err)
//     console.log(data)
// })


module.exports = broadcastModel;
//module.exports.broadcastSchema = broadcastSchema;