const bodyParser = require("body-parser");
const express = require("express");
const userRouter = require("./router/userRouter");
const passport = require("passport");
const passport_JWT = require("passport-jwt")
const secret = require("./config/secrets");
var ExtractJwt = passport_JWT.ExtractJwt
var JwtStrategy = passport_JWT.Strategy;
const {userModel, chatsModel} = require("./model/userModel");
const jwt = require("jsonwebtoken");
var http = require("http");
const chatModel = require("./model/chatModel");
const broadcastModel = require("./model/broadcast");
const eventModel = require("./model/eventModel");
const groupModel = require("./model/groupModel");
const mongoose_ttl = require("mongoose-ttl");



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

app.post("/api/chat", passport.authenticate('jwt', {session: false}), async function(req, res) {
    try {
    let creator = req.user;
    console.log(creator);
    let receiverMember = creator.userName
    console.log(receiverMember)
    let other = new Map();
    other.set(receiverMember, creator.socketId)
    console.log(other)
    console.log(req.body)
    let chatDetails = req.body.data.receiver;
    console.log(chatDetails);
    // let chat = {
    //     "textChain" : chatDetails["textChain"]
    // }
    //let newChat = await chatModel.create({textChain: []});
    let receiver = await userModel.findById(chatDetails);
    //console.log(receiver);
    let creatorMember = receiver.userName
    //console.log(creatorMember)
    let another = new Map()
    //console.log(creatorMember)
    another.set(creatorMember, receiver.socketId)
    console.log(another)
    let found = 0;
    for (let element of creator.chats) {
        console.log("answer")
        if (element.name == receiver.userName) {
            found = 1;
            break;
        }
    }
    if (found == 1) {
        res.statusCode = 400;
        res.json({
            message: "Chat already exists"
        })
   } else {
        let newChat = await chatModel.create({textChain: []});
        let creatorChat = await chatsModel.create({
            chatId: newChat._id,
            name: receiver.userName,
            members: another,
            count: 0
        })
        console.log(creatorChat)
        let receiverChat = await chatsModel.create({
            chatId: newChat._id,
            name: creator.userName,
            members: other,
            count: 0,
        })
        console.log(receiverChat)
        // creator.chats.set(receiver.userName, newChat._id);
        // creator.save();
        // receiver.chats.set(creator.userName, newChat._id);
        // receiver.save();
        creator.chats.push(creatorChat)
        creator.save()
        receiver.chats.push(receiverChat)
        receiver.save()
        //console.log(creator.chats._id)
        res.json({
            message: "chat created successsfully",
            creator,
            receiver,
            newChat
            //allchats
        });
   }
    //console.log(newChat._id);
} catch(error) {
    res.json({
        message: "Error",
        error
    })
}
})


app.post("/api/createGroupChat", passport.authenticate("jwt", {session: false}), async function(req, res) {
    console.log("inside create group chats")
    console.log(req.body);
})

app.post("/api/joinChat", passport.authenticate("jwt", {session: false}), async function(req, res) {
    console.log("inside join group chat")
    console.log(req.body)
    let data = req.body.data;
    let user = req.user;
    let found = 0;
    for (let element of user.chats) {
        console.log("answer")
        if (element.chatId == data.chatId) {
            found = 1;
            break;
        }
    }

    if (found > 0) {
        res.statusCode = 400;
        res.json({
            message: "Chat already exists"
        })
    } else {
        let textChain = await chatModel.findById(data.chatId)
    let members = new Map();
    for (let elem of data.members) {
        let member = await userModel.find({userName: elem})
        console.log(member[0])
        members.set(elem, member[0].socketId)
        let chat = member[0].chats.find(x => x.chatId == data.chatId)
        chat.members.set(user.userName, user.socketId)
        member[0].save()
    }
    data.members.push(user.userName);
    await groupModel.findByIdAndUpdate({_id: data._id}, data)
    let newChat = await chatsModel.create({
        chatId: data['chatId'],
        name: data.name,
        members: members,
    })
    user.chats.unshift(newChat)
    //await user.save()
    res.json({
        message: "reached join chat",
        newChat,
        user,
        textChain
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
        console.log("Shivvvvvvvvvvvvvv")
        console.log(data)
        console.log(client.id);
        await userModel.findByIdAndUpdate({_id: data}, {$set: {socketId: client.id}});
        // console.log(loggeduser);
        //client.emit("/chats", loggeduser)
    });
    client.on("/message", async (data) => {
        console.log(data);
        //console.log(socketId);
        //client.broadcast.to(data.socketId).emit("receive", data.messageData);
        //data.socketIds.forEach(elem => client.broadcast.to(elem).emit("receive", data.messageData))
        let nullObjects = {}
        for (let [k, v] of Object.entries(data.socketIds)) {
            console.log("how many")
            if (v != null) {
                client.broadcast.to(v).emit("receive", data.messageData)
            } else {
                nullObjects[k] = v
            }
        }
        //console.log(nullObjects)
        await chatModel.findByIdAndUpdate({_id: data.chatId}, {$push: {textChain: data.messageData}}, {new: true});
        //console.log("see chat update ******************************");
        //console.log(chat)
        for (let [k, v] of Object.entries(nullObjects)) {
            let user = await userModel.find({userName: k}) 
            if (user[0].socketId != null) {
                let newSocketId = user[0].socketId;
                console.log("came in")
                client.emit("notNull", {k, v : newSocketId})
                console.log("did you see")
                client.broadcast.to(newSocketId).emit("receive", data.messageData)
            } else {
                console.log("inside else")
                user[0].chats.find((elem) => {
                    if (elem.chatId == data.chatId) {
                        elem.count = elem.count + 1
                        // user[0].chats.remove(elem);
                        // user[0].chats.unshift(elem)
                    }
                })
                user[0].count = user[0].count + 1;
                await user[0].save()
            }
        }
        console.log("sent");
        //let chats = await chatModel.findByIdAndUpdate({_id: data.chatId}, {$push: {textChain: data.messageData}});
        //console.log(chats);
    }),

    client.on("resume", async (data) => {
        console.log("Shivvvvvvvvvvvvvv")
        console.log(data)
        console.log(client.id);
        let user = await userModel.findByIdAndUpdate({_id: data}, {$set: {socketId: client.id}}, {new: true});
        client.emit("needCounter", user)
        // console.log(loggeduser);
        //client.emit("/chats", loggeduser)
    });

    client.on("/online", (data) => {
        console.log("onlineeeeeeeee")
        console.log(data)
        let sendData = {
            "data" : data,
            "socketId" : client.id
        }
        data.socketIds.forEach(elem => client.broadcast.to(elem).emit("online", sendData));
    })

    client.on("/replyOnline", (data) => {
        console.log("reply onlineeeeeeeee")
        console.log(data)
        let sendData = {
            "data" : data,
            "socketId" : client.id
        }
        data.socketIds.forEach(elem => client.broadcast.to(elem).emit("replyOnline", sendData));
    })

    client.on("/logOut", (data) => {
        console.log(data)
        let sendData = {
            "chatId" : data.chatInfo.chatId,
            "userName" : data.userName,
            "socketId" : client.id
        }
        client.broadcast.to(data.socketId).emit("logOut", sendData)
    })

    client.on("/socketId", (data) => {
        console.log(data);
        client.broadcast.to(data).emit("socketId", client.id);
    })

    client.on("detached" , async (data) => {
        console.log(data)
        console.log("detached")
        for (let elem of data.chats) {
            for (let [k, v] of Object.entries(elem.members)) {
                console.log(k)
                let sendData = {
                    "chatId" : elem.chatId,
                    'userName': data.userName,
                    "socketId" : client.id 
                }
                client.broadcast.to(v).emit("logOut", sendData)
            }
        }
        let user = await userModel.findById(data._id)
        user.set({socketId: null})
        await user.save();
    })

    client.on("/newChat", async (data) => {
        console.log(data);
        client.broadcast.to(data.socketId).emit("newChat", data);
        //await userModel.findByIdAndUpdate({_id: data._id}, data)
    })

    client.on("/newMember", (data) => {
        console.log(data)
        let sendData = {
            chatId: data.chatId,
            name: data.userName,
            socketId: client.id
        }
        data.socketId.forEach((elem) => client.broadcast.to(elem).emit("newMember", sendData))
    })
    
  });
  //passport.authenticate('jwt', {session: false}), 
  app.post('/api/getChats' ,passport.authenticate('jwt', {session: false}), async function(req, res) {
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

  app.post("/api/updateCounter", passport.authenticate("jwt", {session: false}), async function(req, res) {
      try {
          console.log("inside updateCounter")
      console.log(req.body);
      req.user.count = req.body.data.count;
      req.user.chats = req.body.data.chats;
      await req.user.save()
      res.json({
          message : "counter updated"
      })
    } catch (err) {
        res.json({
            message: "counter couldn't be updated",
            err
        })
    }
  })

  app.post("/api/chats", passport.authenticate('jwt', {session: false}), async function(req, res) {
      try {
          console.log("helloooooo");
          console.log(req.user);
      console.log(req.body);
      console.log(req.body.userName);
      let details = req.body;
      //var chat = chatModel.findById({_id: req.body.chatId});
      let users = await userModel.find({userName: {$in: req.body.userName}});
      console.log(users);
      let userChat = await chatModel.findById(details.chatId)
      let textChain = userChat['textChain'];
      let socketIds = {}
      for (let user of users) {
          console.log(user.userName)
          let userName = user.userName
        socketIds[userName] = user.socketId
      }
      console.log(socketIds)
    //   let socketId = user[0].socketId;
    //   console.log(socketId);
      res.json({
          message: "completed",
          textChain,
          socketIds
      })
    } catch(err) {
        console.log(err);
        res.json({
            message: "unsuccessful",
            err
        })
    }
  })

  app.patch("/api/updateLocation", passport.authenticate('jwt', {session: false}), async function(req, res) {
      console.log("inside update location")
      console.log(req.body);
      console.log(req.user);
      let locationdeets = req.body.data;
      let Latitude = locationdeets.Latitude;
      let Longitude = locationdeets.Longitude;
      let address = locationdeets['address']
      let userCountry = address['country']
      let userLocality = address.subLocality != "" 
                            ? address.subLocality 
                            : address.locality != ""
                                ? address.locality 
                                : address.subAdministrativeArea != ""
                                    ? address.subAdministrativeArea
                                    : address.administrativeArea != ""
                                        ? address.administrativeArea
                                        : address.street != ""
                                            ? address.street
                                            : ''
        console.log(userLocality);
      await userModel.findByIdAndUpdate({_id: req.user._id}, {$set: {Country: userCountry, Locality: userLocality, location: {Latitude, Longitude}}});
      res.json({
          message: "Success"
      })
  })


  app.post('/api/createBroadcast', passport.authenticate('jwt', {session: false}), async function(req, res) {
      console.log(req.body);
      console.log(req.user);
      //console.log(req.body.time);
      let broadcastdetails = req.body.data
      let userName = req.user.userName;
      let userId = req.user._id;
      let Latitude = broadcastdetails.Latitude;
      let Longitude = broadcastdetails.Longitude;
      let newBroadcast = await broadcastModel.create({
        sender: {
            userName,
            userId
        },
        content: broadcastdetails.content,
        Country: broadcastdetails.address.country,
        locality: broadcastdetails.address.locality,
        tags: broadcastdetails.tags,
        location: {Latitude, Longitude},
        expirationTime: new Date(Date.now() + (broadcastdetails.duration * 60 * 60 * 1000)),
        createdAt: new Date(), 
      })
      let userBroadcast = {
          "id": newBroadcast._id,
          "content" : broadcastdetails.content,
          "tags" : broadcastdetails.tags
      }
      let user = req.user;
      user.broadcasts.push(userBroadcast)
      user.save()
      console.log(newBroadcast);
      res.json({
          message: "Successful broadcast creation"
      })
  })


  app.get('/api/getBroadcasts', passport.authenticate('jwt', {session: false}), async function(req, res) {
    console.log(req.user);
    let user = req.user;
    let tags = user.tags;
    let userId = user._id;
    console.log(user._id);
    let broadcastList = await broadcastModel.find({tags: {$in: tags}});
    let broadcasts = broadcastList.filter( (broadcast) => {
        if (broadcast.sender.userName == user.userName) {
            return false;
        }
        return true;
    });
    console.log(broadcasts);
    res.json({
        message: "reached",
        broadcasts: broadcasts
    })
  })


  app.get("/api/getEvents", passport.authenticate('jwt', {session: false}), async function(req,res) {
    console.log(req.user);
    let user = req.user;
    let tags = user.tags;
    let userId = user._id;
    console.log(userId);
    let eventList = await eventModel.find({tags: {$in: tags}});
    let events = eventList.filter( (event) => {
        if (event.sender.userName == user.userName) {
            return false;
        }
        return true;
    });
    console.log(events);
    res.json({
        message: "reached",
        events: events
    })
  })

  app.get("/api/getGroups", passport.authenticate('jwt', {session: false}), async function(req,res) {
    console.log(req.user);
    let user = req.user;
    let tags = user.tags;
    let userId = user._id;
    console.log(userId);
    let groupList = await groupModel.find({tags: {$in: tags}});
    let groups = groupList.filter( (group) => {
        if (group.sender.userName == user.userName) {
            return false;
        }
        return true;
    });
    console.log(groups);
    res.json({
        message: "reached",
        groups: groups
    })
  })

  app.post("/api/logout", passport.authenticate('jwt', {session: false}), async function(req, res) {
      try {
          console.log("inside logout")
          console.log(req.body)
          let user = req.user;
          user.count = req.body.data.count;
          user.chats = req.body.data.chats;
          user.tags = req.body.data.tags;
      user.set({socketId: null});
      user.location = null;
      user.set({Locality: ""});
      user.set({Country: ""});
      await user.save();
      res.json({
          message: "saved"
      })
    } catch (error) {
        res.json({
            message: "problem",
        })
    }
  })

  app.get("/api/getUser", passport.authenticate("jwt", {session: false}), function(req, res) {
      let user = req.user;
      res.json({
          message: "user is logged in",
          user
      })
  })

  app.post('/api/createEvent', passport.authenticate('jwt', {session: false}), async function(req, res) {
    console.log(req.body);
    console.log(req.user);
    //console.log(req.body.time);
    let eventdetails = req.body.data
    let userName = req.user.userName;
    let userId = req.user._id;
    let Latitude = eventdetails.Latitude;
    let Longitude = eventdetails.Longitude;
    let month = eventdetails.month;
    let year = eventdetails.year;
    let day = eventdetails.day;
    let hour = eventdetails.hour;
    let minute = eventdetails.minute;
    let newevent = await eventModel.create({
      sender: {
          userName,
          userId
      },
      content: eventdetails.content,
      Country: eventdetails.address.country,
      locality: eventdetails.address.locality,
      tags: eventdetails.tags,
      location: {Latitude, Longitude},
      time: {day, month, year, hour, minute},
      //expirationTime: new Date(Date.now() + (120 * 1000)),
      createdAt: new Date(), 
    })
    let userEvent = {
        "id" : newevent._id,
        "content" : eventdetails.content,
        "tags" : eventdetails.tags
    }
    let user = req.user;
    user.broadcasts.push(userEvent)
    await user.save()
    console.log(newevent);
    res.json({
        message: "Successful event creation"
    })
})

app.post('/api/createGroup', passport.authenticate('jwt', {session: false}), async function(req, res) {
    console.log(req.body);
    let groupDetails = req.body.data;
    let userId = req.user._id;
    let userName = req.user.userName;
    let Latitude = groupDetails.Latitude;
    let Longitude = groupDetails.Longitude;
    let chat = await chatModel.create({textChain: []})
    let newGroup = await groupModel.create({
        sender:{
            userName,
            userId
        },
        members : [
            userName
        ],
        name: groupDetails.name,
        content: groupDetails.content,
        location: {
            Latitude,
            Longitude
        },
        locality: groupDetails.address.locality,
        Country: groupDetails.address.country,
        tags: groupDetails.tags,
        chatId: chat._id,
    })
    let user = req.user;
    user.chats.unshift({
        chatId: chat._id,
        name: groupDetails.name,
    })
    let userGroup = {
        "id": newGroup._id,
        "content" : groupDetails.content,
        "tags" : groupDetails.tags,
    }
    user.broadcasts.push(userGroup)
    await user.save()
    res.json({
        message: "reached"
    })
})


app.post("/api/setUser", passport.authenticate('jwt', {session: false}), async function(req, res) {
    console.log(req.body);
    let user = req.user;
    let updated = req.body.data;
    user.friends = updated.friends
    user.Country = updated.Country
    user.Locality = updated.Locality
    user.profilepic = updated.profilepic
    user.tags = updated.tags;
    user.count = updated.count;
    user.broadcast = updated.broadcast;
    user.events = updated.events;
    user.groups = updated.groups;
    user.name = updated.name;
    user.userName = updated.userName;
    user.email = updated.email;
    user.password = updated.password;
    user.chats = updated.chats;
    user.socketId = updated.socketId;
    user.location = updated.location;
    await user.save();
    res.json({
        message: "User saved"
    })
})

  //module.exports = io;

server.listen(process.env.PORT || 3000, function() {
    console.log("server started at port 3000");
});
// app.listen(3000, function() {
//     console.log("app started at port 3000!!");
// });