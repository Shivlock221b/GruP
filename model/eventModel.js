let {mongoose} = require("./db");


let eventSchema = mongoose.Schema({


    sender: {
        type: Object
    },

    content: {
        type: Object
    },

    time: {
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

const eventModel = mongoose.model('event', eventSchema);

eventModel.createIndexes({'createdAt' : 1}, function(err, data) {
    console.log(err)
    console.log(data)
})

//module.exports = eventSchema;
module.exports = eventModel;