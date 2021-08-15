import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/Pages/individual_Chat.dart';
//import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/theirTags.dart';
import 'package:grup/screens/theirBroadcasts.dart';
import 'package:grup/screens/theirMutualGroups.dart';
import 'package:grup/screens/tabs.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key key, this.user, this.self, this.tags, this.socket, this.requests, this.isAnonymous = false, this.isChatPage = false}) : super(key: key);
  final Map<String, dynamic> user;
  final Map<String, dynamic> self;
  final List<dynamic> tags;
  final Socket socket;
  final List<dynamic> requests;
  //final List<dynamic> friends;
  final bool isAnonymous;
  final bool isChatPage;

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  NetworkHandler http = NetworkHandler();
  Map<String, dynamic> user;
  List<dynamic> mutualChats = [];
  Logger logger = Logger();
  bool requestSent = false;
  bool requestReceived = false;
  bool friend = false;
  List<dynamic> requests = [];
  List<dynamic> friends = [];
  Icon icon;
  bool blocked;
  bool loaded = true;
  bool userBLockedYou = false;
  bool youBlockedUser = false;

  @override
  void initState() {
    // checkBlocked().then((data) {
    //   setState(() {
    //     blocked = data;
    //     loaded = true;
    //   });
    // });
    if (widget.user['blocked'].contains(widget.self['userName'])) {
      blocked = true;
      userBLockedYou = true;
    } else if (widget.self['blocked'].contains(widget.user['userName'])) {
      blocked = true;
      youBlockedUser = true;
    } else {
      blocked = false;
    }
    getMutualGroups();
    widget.socket.on("requestSent", (data) {
      print(data);
      if (mounted) {
        setState(() {
          requestSent = true;
          icon = Icon(Icons.check, color: Colors.black);
          requests.add(data);
        });
      }
    });

    // widget.socket.on("friendAdded", (data) {
    //   print(data);
    //   if (mounted) {
    //     setState(() {
    //       friend = true;
    //       icon = Icon(Icons.person, color: Colors.black,);
    //     });
    //   }
    // });

    widget.socket.on("friendRequest", (data) {
      if (mounted) {
        setState(() {
          icon = Icon(Icons.add, color: Colors.black);
          requestReceived = true;
          requestSent = false;
          requests.add(data);
        });
      }
    });

    // widget.socket.on("requestDeleted", (data) {
    //   print(data);
    //   setState(() {
    //     requestSent = false;
    //     icon = Icon(Icons.person_add_alt_1_rounded, color: Colors.black);
    //   });
    // });
    this.requests = widget.requests;
    //this.friends = widget.friends;
    super.initState();
  }

  // Future<dynamic> checkBlocked() async {
  //   Map<String, dynamic> map = {
  //     "userName": widget.user['userName']
  //   };
  //   Response response = await http.post("api/checkBlocked", map);
  //   Map<String, dynamic> data = json.decode(response.body);
  //   return data['blocked'];
  // }

  void getMutualGroups() {
    //var applicationBloc = Provider.of<ApplicationBloc>(context);
    Map<String, dynamic> self = widget.self;
    print("*************************************");
    logger.i(self);
    print("*************************************");
    logger.i(widget.user);
    List<dynamic> selfChats = self['chats'];
    List<dynamic> userChats = widget.user['chats'];
    for (int i = 0; i < selfChats.length; i++) {
      if (selfChats[i]['isGroup']) {
        for (int j = 0; j < userChats.length; j++) {
          if (selfChats[i]['name'] == userChats[j]['name']) {
            logger.i(selfChats[i]);
            logger.i(userChats[j]);
            mutualChats.add(selfChats[i]);
          }
        }
      }
    }
    logger.i(mutualChats);
  }

  void isFriend() {
    if (!this.friends.contains(widget.user['userName'])) {
      friend = false;
      if (this.requests.length == 0) {
        icon = Icon(Icons.person_add_alt_1_rounded, color: Colors.black);
        requestSent = false;
        requestReceived = false;
      } else if (requests[0]['sender']['name'] == widget.user['userName']) {
        icon = Icon(Icons.add, color: Colors.black);
        requestReceived = true;
        requestSent = false;
      } else {
        icon = Icon(Icons.check, color: Colors.black);
        requestSent = true;
        requestReceived = false;
      }
    } else {
      icon = Icon(Icons.person, color: Colors.black,);
      friend = true;
      requestReceived = false;
      requestSent = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    //isFriend();
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    friends = applicationBloc.user['friends'];
    isFriend();
    print("request sent" + requestSent.toString());
    print("request received" + requestReceived.toString());
    print("Friend" + friend.toString());
    print(requests);
    print(friends);

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
      backgroundColor: Colors.yellow[300],
      centerTitle: false,
      title: Text( widget.user['userName'],
      style: TextStyle(
      color: Colors.black,
      ),//textStyle
      ),//Text
      actions:<Widget>[
        PopupMenuButton<int>(
          onSelected: (value) async {
            if (value == 0) {
              print("Block");
              Map<String, dynamic> map = {
                "userName": widget.user['userName'],
              };
              Response response = await http.post("api/blockUser", map);
              print(response.statusCode);
              this.blocked = true;
              youBlockedUser = true;
              applicationBloc.removeFriendAndBlock(widget.user['userName'], widget.socket);
              if (widget.isChatPage) {
                Navigator.popUntil(context, ModalRoute.withName("/profilePage"));
              }
              print(applicationBloc.user['friends']);
            } else if (value == 2) {
              Map<String, dynamic> map = {
                "userName": widget.user['userName']
              };
              Response response = await http.post('api/unblockUser', map);
              this.blocked = false;
              youBlockedUser = false;
              applicationBloc.removeBlocked(widget.user['userName']);
            }
          },
          itemBuilder: (BuildContext context) {
            return  youBlockedUser? [
             PopupMenuItem(
                child: Text("UnBlock User"),
                value: 2,
              ),
              PopupMenuItem(
                  child: Text("Report User"),
                value: 1,
              )
            ] : userBLockedYou?  [
              PopupMenuItem(
                child: Text("Report User"),
                value: 1
              )
            ] : [
              PopupMenuItem(
            child: Text("Block User"),
            value: 0
            ),
            PopupMenuItem(
            child: Text("Report User"),
            value: 1
            )
            ];
          },
        )
      ],
    ),


        body: SingleChildScrollView(
          child: Column(
            children:<Widget>
          [
            SizedBox(height:10),
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                // width:400,
                // height:250,
                child: CircleAvatar(backgroundImage : http.getImage(widget.user['profilepic']),
                radius:70
              ),
            ),
          ),
              Divider(height:5),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: widget.isAnonymous || blocked? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                children : <Widget>[
                  blocked? ElevatedButton(style:ElevatedButton.styleFrom(
                    primary : Colors.yellow[300],
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                    padding : EdgeInsets.symmetric(horizontal:25),
                  ),onPressed: () {}, child: Text(youBlockedUser? "You blocked this user": "This user has blocked you", style: TextStyle(
                    color: Colors.black
                  ),), ) : Container(),
              !blocked? ElevatedButton.icon(
                  style:ElevatedButton.styleFrom(
                  primary : Colors.yellow[300],
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                  padding : EdgeInsets.symmetric(horizontal:25),
                  ),
                 onPressed: () async {
                   Map<String, dynamic> creationData = {
                     "receiver" : widget.user['_id'],
                   };
                   Response response = await http.post("api/chat", creationData);
                   Map<String,dynamic> chatDetails = json.decode(response.body);
                   print("check creator");
                   print(chatDetails);
                   if (response.statusCode == 400) {
                     if (widget.isChatPage) {
                       Navigator.pop(context);
                     } else {
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
                     }
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
                 },
                 label : Text(
                "Message",
                  style : TextStyle(
                      fontSize : 16.0,
                      //letterSpacing: 2.0,
                      color:Colors.black
                  ),
                ),
                icon : Icon(Icons.message,
                color:Colors.black,
                ),
              ) : Container(),
                !blocked? !widget.isAnonymous ? ElevatedButton.icon(
                    style:ElevatedButton.styleFrom(
                      primary : Colors.yellow[300],
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                      padding : EdgeInsets.symmetric(horizontal:25),
                    ),
                    onPressed: () async {
                      Map<String, dynamic> data = {
                        "user": widget.user['userName'],
                        "self": widget.self['userName']
                      };
                      if (!friend) {
                        if (!requestSent && !requestReceived) {
                          widget.socket.emit("/addFriend", data);
                        } else if (requestReceived) {
                          widget.socket.emit("/acceptRequest", data);
                        } else {
                          final snackBar = SnackBar(
                            content: Text("Click 'OK' to cancel request"),
                            action: SnackBarAction(
                              label: "OK",
                              onPressed: () {
                                widget.socket.emit("/cancelRequest", data);
                                Navigator.pop(context);
                                //Navigator.pushReplacementNamed(context, '/login');
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }

                    },
                    label : Text(
                      friend ? "Friend" : requestSent ? "Request Sent": requestReceived ? "Accept request" : "Add Friend",
                      style : TextStyle(
                          fontSize : 16.0,
                          //letterSpacing: 2.0,
                          color:Colors.black
                      ),
                    ),
                    icon : icon,
                  ) : Container() : Container(),
              ],
              ),
              SizedBox(
              height:20),

              Container(
                height: 413,
                color: Colors.yellow[300],
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.orange,
                        indicatorColor:Colors.black,
                        tabs : <Widget>[
                          Tab(
                            child: Text("Tags",
                              textAlign: TextAlign.center,
                              style:TextStyle(color:Colors.black,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          // Tab(
                          //   child: Text("Broadcasts",
                          //     textAlign: TextAlign.center,
                          //     style:TextStyle(color:Colors.black,
                          //         fontSize: 16),
                          //   ),
                          // ),
                          Tab(
                            child: Text("Mutual Groups",
                              textAlign: TextAlign.center,
                              style:TextStyle(color:Colors.black,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 365,
                        child: TabBarView(
                            children: <Widget>[
                              TheirTags(tags: widget.tags,),
                              //TheirBroadcasts(broadcasts: widget.user['broadcasts'],),
                              TheirMutualGroups(mutual: mutualChats,)
                              // Text("First Screen"),
                              // Text("Second Screen"),
                              // Text("Third Screen")
                            ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
    ],
    ),
        )
    );
  }
}//class
