import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/Pages/individual_Chat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/message.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../tags.dart';

class DialogBox extends StatefulWidget {
  DialogBox({Key key, this.broadcast, this.isUserBroadcast = false, this.isLocalBroadcasts = false, this.isLocalEvents = false, this.isSavedBroadcast = false, this.isSavedEvent = false, this.isUserEvent = false, this.socket, this.savedBroadcasts, this.savedEvents, this.isRSVPDEvents = false, this.rSVPDEvents}) : super(key: key);
  Map<String, dynamic> broadcast;
  bool isUserBroadcast;
  bool isUserEvent;
  bool isSavedBroadcast;
  bool isSavedEvent;
  bool isLocalBroadcasts;
  bool isLocalEvents;
  bool isRSVPDEvents;
  Socket socket;
  List<dynamic> savedBroadcasts = [];
  List<dynamic> savedEvents = [];
  List<dynamic> rSVPDEvents = [];

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {

  NetworkHandler http = NetworkHandler();
  List<dynamic> tags = [];
  bool isComment = false;
  TextEditingController _message = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<dynamic> comments = [];
  Logger logger = Logger();

  @override
  void initState() {
    comments = widget.broadcast['comments'];
    tags = widget.broadcast['tags'];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var applicationBloc = Provider.of<ApplicationBloc>(context);

    return Material(
      type: MaterialType.transparency,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 400,
            margin: EdgeInsets.only(bottom: 150, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (widget.isLocalBroadcasts || widget.isLocalEvents || widget.isRSVPDEvents) {
                        Map<String, dynamic> data = {
                          'name': widget.broadcast['sender']['userName'],
                          'id': widget.broadcast['sender']['userId'],
                          'isAnonymous': widget.broadcast['isAnonymous']
                        };
                        Response response = await http.post(
                            'api/getOwner', data);
                        print(response.statusCode);
                        print(response.body);
                        Map<String, dynamic> map;
                        map = json.decode(response.body);
                        print(map);
                        print("print tagMap");
                        print(map['tagMap']);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (builder) {
                              return ViewProfile(user: map['user'][0],
                                self: map['self'],
                                tags: map['tagMap'],
                                socket: widget.socket,
                                requests: map['request'],
                                isAnonymous: widget.broadcast['isAnonymous']
                              );
                            }
                        ));
                      }
                    },
                    child: Text(
                      widget.broadcast['sender']['userName'],
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blueAccent
                      ),
                    ),
                  ),
                  //SizedBox(height: 5,),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      widget.broadcast['content'],
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue
                      ),
                    ),
                  ),
                  widget.isUserEvent || widget.isSavedEvent || widget.isLocalEvents || widget.isRSVPDEvents? Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        widget.broadcast['time']
                    ),
                  ) : Container(),
                  Divider(),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: tags.map((x) => Tag(text: x)).toList()
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          print(applicationBloc.user);
                          if (!(widget.broadcast['endorse']['endorser'].contains(applicationBloc.user['userName']))) {
                            Map<String, dynamic> data = {
                              "id": widget.broadcast['_id']
                            };
                            Response response = await http.post(
                                "api/eventEndorse", data);
                            setState(() {
                              widget.broadcast['endorse']['count'] =
                                  widget.broadcast['endorse']['count'] + 1;
                              widget.broadcast['endorse']['endorser'].insert(0, applicationBloc.user['userName']);
                            });
                          }
                        },
                        child: Text(
                            "${widget.broadcast['endorse']['count']} Endorse"
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            Response response;
                            Map<String, dynamic> data;

                            if (widget.isUserBroadcast) {
                              response = await http.post("api/saveBroadcast", widget.broadcast);
                              data = json.decode(response.body);
                              widget.savedBroadcasts.insert(0, data['savedBroadcast']);
                              Map<String, dynamic> map = {
                                "return": widget.savedBroadcasts
                              };
                              Navigator.pop(context, map);
                              print(data);
                            }

                            if (widget.isUserEvent) {
                              response = await http.post("api/saveEvent", widget.broadcast);
                              data = json.decode(response.body);
                              widget.savedEvents.insert(0, data['savedBroadcast']);
                              Map<String, dynamic> map = {
                                "return": widget.savedEvents
                              };
                              Navigator.pop(context, map);
                              print(data);
                            }

                            if (widget.isSavedBroadcast) {
                              Map<String, dynamic> data = {
                                "_id": widget.broadcast["_id"]
                              };
                              widget.savedBroadcasts.remove(widget.broadcast);
                              response = await http.post("api/deleteBroadcast", data);
                              data = json.decode(response.body);
                              Map<String, dynamic> map = {
                                "return": widget.savedBroadcasts
                              };
                              Navigator.pop(context, map);
                            }

                            if (widget.isSavedEvent) {
                              Map<String, dynamic> data = {
                                "_id": widget.broadcast["_id"]
                              };
                              widget.savedEvents.remove(widget.broadcast);
                              response = await http.post("api/deleteEvent", data);
                              data = json.decode(response.body);
                              print(data);
                              Map<String, dynamic> map = {
                                "return": widget.savedEvents
                              };
                              Navigator.pop(context, map);
                            }

                            if (widget.isLocalBroadcasts) {
                              Map<String, dynamic> creationData = {
                                "receiver" : widget.broadcast['sender']['userId'],
                              };
                              Response response = await http.post("api/chat", creationData);
                              Map<String,dynamic> chatDetails = json.decode(response.body);
                              print("check creator");
                              print(chatDetails);
                              logger.i(chatDetails['newChat']);
                              logger.i(chatDetails['receiver']);
                              if (response.statusCode == 400) {
                                // final snackBar = SnackBar(
                                //   content: Text("Chat already exists"),
                                // );
                                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                await Navigator.push(context, MaterialPageRoute(
                                  builder: (builder) => IndividualChat(
                                    socket: widget.socket,
                                    data: applicationBloc.user,
                                    chat: [],
                                    chatId: chatDetails['chat']['chatId'],
                                    chatName: chatDetails['chat']['name']
                                  )
                                ));
                              } else {
                                applicationBloc.setUser(chatDetails['creator']);
                                widget.socket.emit("/newChat", chatDetails);
                                print(applicationBloc.user);
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            builder) =>
                                            IndividualChat(
                                              socket: widget.socket,
                                              data: chatDetails['creator'],
                                              chat: chatDetails['newChat']['textChain'],
                                              //socketId: chatDetails['receiver']['socketId'],
                                              chatId: chatDetails['newChat']['_id'],
                                              chatName: chatDetails['receiver']['userName'],
                                            )
                                    ));
                              }
                            }

                            if (widget.isLocalEvents) {
                              Map<String, dynamic> map = {
                                "eventId" : widget.broadcast['_id']
                              };
                              Response response = await http.post("api/rsvp", map);
                              data = json.decode(response.body);
                              Navigator.pop(context);
                            }

                            if (widget.isRSVPDEvents) {
                              Map<String, dynamic> map = {
                                "_id": widget.broadcast["_id"]
                              };
                              widget.rSVPDEvents.remove(widget.broadcast);
                              Response response = await http.post("api/cancelRSVP", map);
                              print(json.decode(response.body));
                              Navigator.pop(context, widget.rSVPDEvents);
                            }

                            if (widget.isUserBroadcast || widget.isUserEvent || widget.isLocalEvents) {
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(data
                                    ['message']),
                              action: SnackBarAction(
                                label: "OK",
                                onPressed: () {
                                  //Navigator.pushReplacementNamed(context, '/login');
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Text(
                            widget.isUserBroadcast ?
                                "Save Broadcast" : widget.isUserEvent? "Save Event" : widget.isSavedBroadcast? "Delete Broadcast": widget.isSavedEvent?"Delete Event" : widget.isLocalBroadcasts ?
                              "Start Chat" : widget.isRSVPDEvents? "Cancel RSVP" : "RSVP"
                          )
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isComment = !isComment;
                          });
                        },
                        child: Text(
                            "Comment"
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: widget.broadcast['comments'].length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.yellow[300],
                                elevation: 1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    widget.broadcast['comments'][index]['message'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ) ,
                      isComment ? Row(
                        children: [
                          Neumorphic(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(20))),
                                color: Colors.white
                            ),
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width - 90,
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
                                      hintText: "Comment"
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
                                    onPressed: () async {
                                      if (_message.text.length > 0) {
                                        //print(this.socketIds);
                                        Map<String, dynamic> data =
                                        //"socketId" : this.socketId,
                                        {
                                          "time": DateTime.now().toString(),
                                          "sender": applicationBloc.user['userName'],
                                          "message": _message.text,
                                          "broadcastId" : widget.broadcast['_id']
                                        };
                                        Response response = await http.post("api/eventComment", data);
                                        print(DateTime.now().toString());
                                        _message.clear();
                                        print(data);
                                        //widget.socket.emit('/message', messageData);
                                        _scrollController.animateTo(
                                            _scrollController.position.maxScrollExtent,
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.easeOut
                                        );
                                        setState(() {
                                          widget.broadcast['comments'].add(data);
                                          isComment = false;
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
                      ) : Container(),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
