import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:grup/services/broadcast.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../networkHandler.dart';
import '../tags.dart';

class FriendBroadcasts extends StatefulWidget {
  const FriendBroadcasts({Key key, this.user, this.socket}) : super(key: key);
  final Map<String, dynamic> user;
  final Socket socket;

  @override
  _FriendBroadcastsState createState() => _FriendBroadcastsState();
}

class _FriendBroadcastsState extends State<FriendBroadcasts> {

  Socket socket;
  NetworkHandler http = NetworkHandler();
  List<dynamic> broadcasts = [];
  ScrollController _scrollController = ScrollController();
  double _value = 500.0;
  Map<String, dynamic> user;

  @override
  void initState() {
    getBroadcasts().then((broadcastList) {
      print(broadcastList);
      setState(() {
        broadcasts = broadcastList;
      });
    });
    this.user = widget.user;
    this.socket = widget.socket;
    super.initState();

  }

  Future<List<dynamic>> getBroadcasts() async {
    var response = await http.get('api/getFriendBroadcasts');
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data['broadcasts'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Friend Broadcasts"
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: broadcasts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(broadcasts[index]['content']);
              return InkWell(
                onTap: () {
                  showGeneralDialog(
                      barrierLabel: "Label",
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: Duration(milliseconds: 200),
                      context: context,
                      transitionBuilder: (context, anim1, anim2, child) {
                        return SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation1, animation2) {
                        List<dynamic> tags = broadcasts[index]['tags'];
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
                                          Map<String, dynamic> data = {
                                            'name': broadcasts[index]['sender']['userName']
                                          };
                                          Response response = await http.post('api/getOwner', data);
                                          print(response.statusCode);
                                          print(response.body);
                                          Map<String, dynamic> map;
                                          map = json.decode(response.body);
                                          print(map);
                                          print("print tagMap");
                                          print(map['tagMap']);
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (builder) {
                                                return ViewProfile(user: map['user'][0], self: map['self'], tags: map['tagMap'], socket: socket, requests: map['request'], friends: map['friends'],);
                                              }
                                          ));
                                        },
                                        child: Text(
                                          broadcasts[index]['sender']['userName'],
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
                                          broadcasts[index]['content'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.blue
                                          ),
                                        ),
                                      ),
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
                                                // Map<String, dynamic> creationData = {
                                                //   "receiver" : broadcasts[index]['sender']['userId'],
                                                // };
                                                // Response response = await http.post("api/chat", creationData);
                                                // Map<String,dynamic> chatDetails = json.decode(response.body);
                                                // print("check creator");
                                                // print(chatDetails);
                                                // if (response.statusCode == 400) {
                                                //   final snackBar = SnackBar(
                                                //     content: Text("Chat already exists"),
                                                //   );
                                                //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                // } else {
                                                //   applicationBloc.setUser(chatDetails['creator']);
                                                //   socket.emit("/newChat", chatDetails['receiver']);
                                                //   print(applicationBloc.user);
                                                //   await Navigator.push(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //           builder: (
                                                //               builder) =>
                                                //               IndividualChat(
                                                //                 socket: socket,
                                                //                 data: chatDetails['creator'],
                                                //                 chat: chatDetails['newChat']['textChain'],
                                                //                 //socketId: chatDetails['receiver']['socketId'],
                                                //                 chatId: chatDetails['newChat']['_id'],
                                                //                 chatName: chatDetails['receiver']['userName'],
                                                //               )
                                                //       ));
                                                // }
                                              },
                                              child: Text(
                                                  "Start Chat"
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
                  );
                },
                child: BroadCast(
                  text1: broadcasts[index]['sender']['userName'],
                  text2: broadcasts[index]['content'],),
              );
            }
        ),
      ),
    );
  }
}
