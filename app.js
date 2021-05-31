const bodyParser = require("body-parser");
const express = require("express");
const userRouter = require("./router/userRouter");
const passport = require("passport");
const passport_JWT = require("passport-jwt")
const secret = require("./config/secrets");
var ExtractJwt = passport_JWT.ExtractJwt
var JwtStrategy = passport_JWT.Strategy;
const userModel = require("./model/userModel");
const jwt = require("jsonwebtoken");
var http = require("http");
const chatModel = require("./model/chatModel");



const jwtOptions = {
jwtFromRequest : ExtractJwt.fromAuthHeaderWithScheme('jwt'),
secretOrKey : secret.SECRET_KEY
}


passport.use(new JwtStrategy(jwtOptions, async function(jwt_payload, done) {
    console.log('payload received', jwt_payload);
    console.log(jwt_payload.id);
    // usually this would be a database call:
    try {
    let user = await userModel.findById(jwt_payload.id);
        //console.log(user);
        if (user) {
            console.log("plss2 print");
            return done(null, user);
        } else {
            console.log("pls3 print");
            return done(null, false);
            // or you could create a new account
        }
    } catch (error) {
        console.log(error);
        done(error, false);
    }
  }));
  const app = express();
  app.use(passport.initialize());
  app.use(express.json());
  app.use(express.urlencoded(
      {
          extended: true
      }
  ))
var server = http.createServer(app);
var io = require("socket.io")(server);
app.use("/api/user", userRouter);
app.get("/api/getInfo", passport.authenticate('jwt', {session: false}), async function(req, res) {
    console.log(req.user);
    let user = req.user;
    res.json({
        message: "success",
        user
    })
});

app.use("/api/updateUser", userRouter);

app.post("/api/chat", async function(req, res) {
    try {
    let chatDetails = req.body;
    console.log(chatDetails);
    // let chat = {
    //     "textChain" : chatDetails["textChain"]
    // }
    await chatModel.create(chatDetails);
    //var allchats = await chatModel.find();
    //console.log(allchats);
    res.json({
        message: "chat created successsfully",
        //allchats
    });
} catch(error) {
    res.json({
        message: "Error",
        error
    })
}
})

// chatModel.find().then(function(allchats) {
//     console.log(allchats);
// }) 

app.post("/api/addChats", async function(req, res) {
    let userDetails = req.body
    console.log(req.body);
    console.log(userDetails.chats);
    let updatedUser = await userModel.findByIdAndUpdate({_id: userDetails.id}, {$set: {chats: userDetails.chats}});
    console.log(updatedUser);
    res.json({
        message : "successful"
    })
})

// io.on("Connection", (socket) => {
//     console.log("connected");
//     console.log(socket);
//     console.log(socket.id, "has joined");
// })

let socket_id = "";
io.on("connection", (client) => {
    console.log("connected");
    socket_id = client.id;
    console.log(client.id);
    client.on("signin", async (data) => {
        console.log(data)
        console.log(client.id);
        await userModel.findByIdAndUpdate({_id: data}, {$set: {socketId: client.id}});
        // console.log(loggeduser);
        //client.emit("/chats", loggeduser)
    });
    client.on("/message", async (data) => {
        console.log(data);
        //console.log(socketId);
        client.broadcast.to(data.socketId).emit("receive", data.messageData);
        console.log("sent");
        let chats = await chatModel.findByIdAndUpdate({_id: data.chatId}, {$push: {textChain: data.messageData}});
        //console.log(chats);
    })
    // console.log(socket.id, "has joined");
    // socket.on("signin", (id) => {
    //   console.log(id);
    //   //clients[id] = socket;
    //   //console.log(clients);
    // });
    // socket.on("message", (msg) => {
    //   console.log(msg);
    //   //let targetId = msg.targetId;
    //   //if (clients[targetId]) clients[targetId].emit("message", msg);
    // });
  });
  //passport.authenticate('jwt', {session: false}), 
  app.post('/api/getChats' ,async function(req, res) {
      try {
          console.log(req.body);
          console.log("hello again");
          let data = req.body.data._id;
          console.log(data);
          console.log(socket_id);
          let loggeduser = await userModel.findById(data);
          console.log(loggeduser);
          res.json({
              message: "Successfully updated and received",
              loggeduser
          })
        // let loggeduser = await userModel.findByIdAndUpdate({_id: data}, {$set: {socketId: req.client.id}});
        // console.log(loggeduser);
      } catch (error) {
        console.log(error);
      }
  })

  app.post("/api/chats", async function(req, res) {
      try {
          console.log("helloooooo");
          console.log(req.user);
      console.log(req.body);
      console.log(req.body.userName);
      let details = req.body;
      //var chat = chatModel.findById({_id: req.body.chatId});
      let user = await userModel.find({userName: req.body.userName});
      console.log(user);
      let userChat = await chatModel.findById(details.chatId)
      let textChain = userChat['textChain'];
      let socketId = user[0].socketId;
      console.log(socketId);
      res.json({
          message: "completed",
          textChain,
          socketId
      })
    } catch(err) {
        console.log(err);
        res.json({
            message: "unsuccessful",
            err
        })
    }
  })


server.listen(process.env.PORT || 5000, function() {
    console.log("server started at port 3000");
});
// app.listen(3000, function() {
//     console.log("app started at port 3000!!");
// });