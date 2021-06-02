import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/message.dart';
import 'package:grup/networkHandler.dart';
import 'package:socket_io_client/socket_io_client.dart';


class IndividualChat extends StatefulWidget {
  const IndividualChat({Key key, this.socket, this.data, this.chat, this.socketId, this.chatId, this.chatName}) : super(key: key);
  final Socket socket;
  final dynamic data;
  final List<dynamic> chat;
  final String socketId;
  final String chatId;
  final String chatName;
  @override
  _IndividualChatState createState() => _IndividualChatState(this.socket, this.data, this.chat, this.socketId, this.chatId);
}

class _IndividualChatState extends State<IndividualChat> {
  dynamic data;
  Socket socket;
  List<dynamic> chat;
  String socketId;
  String chatId;
  ScrollController _scrollController = ScrollController();
  NetworkHandler http = NetworkHandler();
  TextEditingController _message = TextEditingController();
  //_IndividualChatState(this.socket, this.data, this.chat, this.socketId, this.chatId);
  String name;

  @override
  void initState() {
    super.initState();
    print(data);
    //List<dynamic> list = data['chats'].keys.toList();
    //list.add("user5");
    //print(list);
    print(chat);
    // http.getChats('api/chats').then((value) => {
    //   //print(json.decode(value.body))
    // });

    print("heloooooo");
    //receive();
    connect();
  }

  void connect() {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    // socket = IO.io("http://192.168.0.106:5000", <String, dynamic>{
    //   "transports": ["websocket"],
    //   "autoConnect": false,
    // });
    //socket.connect();
    //socket.emit("signin", widget.sourchat.id);
      print("Connected");
      // socket.on("receive", (msg) {
      //   print(msg);
      //   //setMessage("destination", msg);
      //   setState(() {
      //     chat.add(msg);
      //   });
      //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //       duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      // });
    print(socket.connected);
  }

  void setMessage(String type, String message) {
    // MessageModel messageModel = MessageModel(
    //     type: type,
    //     message: message,
    //     time: DateTime.now().toString().substring(10, 16));
    // print(messages);

    setState(() {
      chat.add(message);
    });
  }

  // void receive() {
  //   this.socket.on("receive", (message) => setState(() {
  //
  //     print(message);
  //     chat.add(message);
  //   }));
  // }

  _IndividualChatState(this.socket, this.data, this.chat, this.socketId, this.chatId) {
    socket.on("receive", (msg) {
      print(msg);
      //setMessage("destination", msg);
      if (mounted) {
        setState(() {
          chat.add(msg);
        });
      }

      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(data);
    Timer(
      Duration(milliseconds: 10),
          () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.yellow[300],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          title: Text(
            widget.chatName,
            style: TextStyle(
              color: Colors.black
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  //return Message(isSender: false);
                  //print(chat[index]["sender"] +""+ data['userName']);
                  if (chat[index]["sender"] == data['userName']) {
                    return Message(isSender: true, message: chat[index]['message'],);
                  }
                  return Message(isSender: false, message: chat[index]['message'],);
                },
              ),
            ),
            Row(
              children: [
                Neumorphic(
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(20))),
                    color: Colors.white
                  ),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width - 70,
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.white),
                      child: TextFormField(
                        controller: _message,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          hintText: "Your Message"
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(20))),
                        color: Colors.white
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        onPressed: () {
                          if (_message.text.length > 0) {
                            print(this.socketId);
                            Map<String, dynamic> data =
                            //"socketId" : this.socketId,
                            {
                              "time": DateTime.now().toString(),
                              "sender": this.data['userName'],
                              "message": _message.text
                            };
                            print(DateTime.now().toString());
                            _message.clear();
                            Map<String, dynamic> messageData = {
                              "messageData": data,
                              "socketId": this.socketId,
                              "chatId": this.chatId
                            };
                            print(data);
                            this.socket.emit('/message', messageData);
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut
                            );
                            setState(() {
                              chat.add(data);
                            });
                          }

                        },
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        icon: Icon(Icons.send_rounded, color: Colors.white,),
                      )
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
