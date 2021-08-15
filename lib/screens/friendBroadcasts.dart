import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/screens/group_profile.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:grup/services/DialogBox.dart';
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
  List<dynamic> events = [];
  List<dynamic> groups = [];
  ScrollController _scrollController = ScrollController();
  bool isReady = false;
  double _value = 500.0;
  Map<String, dynamic> user;

  @override
  void initState() {
    getBroadcasts().then((data) {
      //print(broadcastList);
      setState(() {
        broadcasts = data['broadcasts'];
        events = data['events'];
        groups = data['groups'];
        isReady = true;
      });
    });
    this.user = widget.user;
    this.socket = widget.socket;
    super.initState();

  }

  Future<Map<String, dynamic>> getBroadcasts() async {
    var response = await http.get('api/getFriendBroadcasts');
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Friend Broadcasts"
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("Broadcasts",
                  textAlign: TextAlign.center,
                  style:TextStyle(color:Colors.white,
                      fontSize: 16
                  ),
                ),
              ),
              Tab(
                child: Text("Events",
                  textAlign: TextAlign.center,
                  style:TextStyle(color:Colors.white,
                      fontSize: 16
                  ),
                ),
              ),
              Tab(
                child: Text("Groups",
                  textAlign: TextAlign.center,
                  style:TextStyle(color:Colors.white,
                      fontSize: 16
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isReady ? ListView.builder(
              itemCount: broadcasts.length,
                itemBuilder: (context, index) {
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
                            //List<dynamic> tags = broadcasts[index]['tags'];
                              return DialogBox(
                                broadcast: broadcasts[index],
                                isLocalBroadcasts: true,
                                socket: widget.socket,
                              );
                          }
                      );
                    },
                    child: BroadCast(
                      text1: broadcasts[index]['sender']['userName'],
                      text2: broadcasts[index]['content'],),
                  );
                }
            ) : Center(child: CircularProgressIndicator()),
            isReady ? ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
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
                            //List<dynamic> tags = broadcasts[index]['tags'];
                            return DialogBox(
                                broadcast: events[index],
                                isLocalEvents: true,
                                socket: widget.socket,
                              );
                          }
                      );
                    },
                    child: BroadCast(
                      text1: events[index]['sender']['userName'],
                      text2: events[index]['content'],),
                  );
                }
            ) : Center(child: CircularProgressIndicator()),
            isReady ? ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
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
                            //List<dynamic> tags = broadcasts[index]['tags'];
                            return GroupProfile(
                                socket: widget.socket,
                                group: groups[index]
                            );
                          }
                      );
                    },
                    child: BroadCast(
                      text1: groups[index]['sender']['userName'],
                      text2: groups[index]['content'],),
                  );
                }
            ) : Center(child: CircularProgressIndicator())
          ],
        )
      ),
    );
  }
}
