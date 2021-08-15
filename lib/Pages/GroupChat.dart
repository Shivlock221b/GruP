import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/db/datasource.dart';
import 'package:grup/message.dart';
import 'package:grup/models/local_message.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/group_profile.dart';
import 'package:grup/services/encryption_service.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';


class GroupChat extends StatefulWidget {
  const GroupChat({Key key, this.socket, this.data, this.chat, this.chatId, this.chatName, this.isGroup, this.members}) : super(key: key);
  final Socket socket;
  final dynamic data;
  final List<dynamic> chat;
  final String chatId;
  final String chatName;
  final bool isGroup;
  final List<dynamic> members;
  @override
  _GroupChatState createState() => _GroupChatState(this.socket, this.data, this.chatId);
}

class _GroupChatState extends State<GroupChat> {
  dynamic data;
  Socket socket;
  List<dynamic> chat = [];
  Map<String, dynamic> socketIds;
  String chatId;
  ScrollController _scrollController = ScrollController();
  NetworkHandler http = NetworkHandler();
  TextEditingController _message = TextEditingController();
  //_IndividualChatState(this.socket, this.data, this.chat, this.socketId, this.chatId);
  String name;
  DataSource _dataSource;
  Logger logger = Logger();
  List<String> count = [];

  @override
  void initState() {
    _dataSource = http.dataSource;
    _dataSource.findMessages(chatId).then((value) {
      setState(() {
        chat = value;
      });
    });
    Map<String, dynamic> map = {
      "chatId": widget.chatId,
      "userName": widget.data['userName']
    };
    widget.socket.emit("/online", map);
    socket.on("online", (data) {
      setState(() {
        count.add(data['userName']);
      });
    });
    socket.on("newMember", (data) {
      setState(() {
        widget.members.add(data['name']);
      });
    });
    socket.on("left", (data) {
      setState(() {
        count.remove(data);
        widget.members.remove(data);
      });
    });
    socket.on('replyOnline', (data) {
      setState(() {
        count.add(data['userName']);
      });
    });
    socket.on("receive", (msg) {
      print("Hellololololololol");
      print(msg);
      logger.i(msg);
      if (mounted) {
        setState(() {
          msg['message'] = EncryptionService.decryptAES(msg['message']);
          LocalMessage message = LocalMessage(
              chatId, msg['sender'], msg['message'], msg['receivedAt'],
              data['userName']);
          chat.add(message);
        });
      }
    });
    super.initState();
  }

  // void get(String type, String message) {
  //
  // }

  _GroupChatState(this.socket, this.data, this.chatId);

  @override
  Widget build(BuildContext context) {

    var applicationBloc = Provider.of<ApplicationBloc>(context);
    this.data = applicationBloc.user;
    //this.socketIds = this.data['chats'].firstWhere((elem) => elem['name'] == widget.chatName, orElse: () => null)['members'];
    print(this.socketIds);
    print("inside buildddddddddd");
    // dynamic userChat = this.data['chats'].firstWhere((elem) => elem['name'] == widget.chatName, orElse: () => null);
    // userChat['members'].forEach((k, v) => v != null ? count.add(v): count);
    // Map<String, dynamic> senderData = {
    //   'socketIds' : count,
    //   'chatName': widget.chatName,
    //   'sender' : data['userName']
    // };
    // socket.on("online", (data) {
    //   print("online inside individual");
    //   socket.emit("/replyOnline", senderData);
    // });
    //
    // socket.on("notNull", (data) {
    //   print("did you see");
    //   print(data);
    //   socketIds[data['k']] = data['v'];
    // });

    // socket.on("logOut", (data) {
    //   setState(() {
    //     count.remove();
    //   });
    // })
    //print(userChat);
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
              applicationBloc.decreaseCounters(this.chatId);
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          // title: Text(
          //   widget.chatName,
          //   style: TextStyle(
          //     color: Colors.black
          //   ),
          // ),
          title: InkWell(
            onTap: () async {
              Map<String, dynamic> map = {
                "chatId": this.chatId
              };
              Response response = await http.post("api/getGroup", map);
              Map<String, dynamic> group = json.decode(response.body)['group'];
              Navigator.push(context, MaterialPageRoute(
                  builder: (builder) => GroupProfile(
                    socket: this.socket,
                    group: group,
                    isChatPage: true
                  )
              ));
            },
            child: Column(
              children: [
                Text(
                    widget.chatName,
                    style: TextStyle(
                        color: Colors.black
                    )
                ),
                Text(
                    count.length > 0 ? "online" : ""
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  print(applicationBloc.user);
                },
                child: Text(
                    "Test"
                )
            )
          ],
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  Map<String, dynamic> onlineData = {
                    "socketIds": socketIds.values.toList(),
                    "chatName": widget.chatName,
                    "sender": data['userName']
                  };
                  socket.emit("/online", onlineData);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: chat.length,
                  itemBuilder: (context, index) {
                    //return Message(isSender: false);
                    //print(chat[index]["sender"] +""+ data['userName']);
                    //if (chat[index]["sender"] == data['userName']) {
                    if (chat[index].sender == data['userName']) {
                      //return Message(isSender: true, message: chat[index]['message'],);
                      return Message(
                        isSender: true, message: chat[index].message,);
                    }
                    //return Message(isSender: false, message: chat[index]['message'],);
                    return Message(
                      isSender: false, message: chat[index].message,);
                  },
                ),
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
                              print(this.socketIds);
                              // Map<String, dynamic> data =
                              // //"socketId" : this.socketId,
                              // {
                              //   "time": DateTime.now().toString(),
                              //   "sender": this.data['userName'],
                              //   "message": _message.text,
                              //   "chatId" : this.chatId
                              // };
                              String encryptedText = EncryptionService.encryptAES(_message.text);
                              Map<String, dynamic> data =
                              //"socketId" : this.socketId,
                              {
                                "time": DateTime.now().toString(),
                                "sender": this.data['userName'],
                                "message": encryptedText,
                                "chatId" : this.chatId,
                                "isGroup": widget.isGroup
                              };
                              LocalMessage message = LocalMessage(this.chatId, this.data['userName'], _message.text, DateTime.now().toString(), widget.chatName);
                              //print(DateTime.now().toString());
                              _message.clear();
                              Map<String, dynamic> messageData = {
                                "messageData": data,
                                "socketIds": widget.chatId,
                                "chatId": this.chatId,
                                "isGroup": widget.isGroup,
                                "members": widget.members
                              };
                              print(data);
                              this.socket.emit('/message', messageData);
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut
                              );
                              setState(() {
                                chat.add(message);
                              });
                              _dataSource.addMessage(message);
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
