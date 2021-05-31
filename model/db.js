const mongoose = require("mongoose");
const {DB_CONFIG} = require("../config/secrets");

mongoose.connect(DB_CONFIG, {useNewUrlParser : true, useUnifiedTopology : true, useCreateIndex: true, useFindAndModify: false, autoIndex: false}).then(function(obj) {
    console.log("db connected");
}).catch(error => {
    console.log(error);
})

module.exports.mongoose = mongoose;