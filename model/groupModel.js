let {mongoose} = require('./db');

let groupSchema = mongoose.Schema({

    sender: {
        type: Object
    },

    name: {
        type: Object
    },

    members: {
        type: Array
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

    chatId: {
        type: String
    },

    isBroadcasting: {
        type: Boolean,
        default: true
    },

    endorse: {
        type: Number,
        default: 0
    },

    comments: {
        type: Array,
        of: Object
    }
})

groupSchema.pre('remove', function(next) {

})

groupSchema.post('save', function(doc) {
    
})

const groupModel = mongoose.model('group', groupSchema);


//module.exports = groupSchema;
module.exports = groupModel;