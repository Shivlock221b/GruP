import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:http/http.dart';
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

  @override
  void initState() {
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
                          'name': widget.broadcast['sender']['userName']
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
                                socket
                                : widget.socket,
                                requests: map['request'],
                                friends: map['friends'],);
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
                        onPressed: () {
                          setState(() {

                          });
                        },
                        child: Text(
                            "Endorse"
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
                              if (response.statusCode == 400) {
                                final snackBar = SnackBar(
                                  content: Text("Chat already exists"),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                applicationBloc.setUser(chatDetails['creator']);
                                widget.socket.emit("/newChat", chatDetails['receiver']);
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
                        onPressed: () {},
                        child: Text(
                            "Comment"
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 300,
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Container();
                        }
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
