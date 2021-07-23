import 'dart:convert';

import 'package:flutter/material.dart';
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
  const ViewProfile({Key key, this.user, this.self, this.tags, this.socket, this.requests, this.friends}) : super(key: key);
  final Map<String, dynamic> user;
  final Map<String, dynamic> self;
  final Map<String, dynamic> tags;
  final Socket socket;
  final List<dynamic> requests;
  final List<dynamic> friends;

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

  @override
  void initState() {
    getMutualGroups();
    // widget.socket.on("requestSent", (_) {
    //   setState(() {
    //     requestSent = true;
    //   });
    // });
    //
    // widget.socket.on("friendAdded", (_) {
    //   setState(() {
    //     friend = true;
    //   });
    // });
    //
    // widget.socket.on("requestDeleted", (_) {
    //   requestSent = false;
    // });
    this.requests = widget.requests;
    this.friends = widget.friends;
    super.initState();
  }

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
    if (this.friends.length == 0) {
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
        IconButton(
          icon : Icon(Icons.more_horiz_rounded),
          color:Colors.black,
          onPressed:() {},
        ),
      ],
    ),


        body:Column(
          children:<Widget>
        [
          SizedBox(height:10),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              // width:400,
              // height:250,
              child: CircleAvatar(backgroundImage : AssetImage('assets/${widget.user['profilepic']}'),
              radius:70
            ),
          ),
        ),
            Divider(height:5),
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children : <Widget>[
            ElevatedButton.icon(
                style:ElevatedButton.styleFrom(
                primary : Colors.yellow[300],
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                padding : EdgeInsets.symmetric(horizontal:25),
                ),
               onPressed: (){},
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
            ),
              ElevatedButton.icon(
                  style:ElevatedButton.styleFrom(
                    primary : Colors.yellow[300],
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                    padding : EdgeInsets.symmetric(horizontal:25),
                  ),
                  onPressed: () async {
                    Map<String, dynamic> data = {
                      "user": widget.user['_id'],
                      "self": widget.self['_id']
                    };
                    if (!friend) {
                      if (!requestSent && !requestReceived) {
                        widget.socket.emit("/addFriend", data);
                        setState(() {
                          requestSent = true;
                          icon = Icon(Icons.check, color: Colors.black);
                        });
                      } else if (requestReceived) {
                        widget.socket.emit("/acceptRequest", data);
                        setState(() {
                          friend = true;
                          icon = Icon(Icons.person, color: Colors.black,);
                        });
                      } else {
                        final snackBar = SnackBar(
                          content: Text("Click 'OK' to cancel request"),
                          action: SnackBarAction(
                            label: "OK",
                            onPressed: () {
                              widget.socket.emit("/cancelRequest", data);
                              setState(() {
                                requestSent = false;
                                icon = Icon(Icons.person_add_alt_1_rounded, color: Colors.black);
                              });
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
                ),
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
    );
  }
}//class
