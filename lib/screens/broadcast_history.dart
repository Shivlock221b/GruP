import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/services/DialogBox.dart';
import 'package:grup/services/broadcast.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:grup/networkHandler.dart';
import 'package:intl/intl.dart';

class BroadcastHistory extends StatefulWidget {
  BroadcastHistory({Key key, this.data}) : super(key: key);
  Map<String, dynamic> data;

  @override
  _BroadcastHistoryState createState() => _BroadcastHistoryState();
}

class _BroadcastHistoryState extends State<BroadcastHistory> {

  NetworkHandler http = NetworkHandler();
  List<dynamic> liveBroadcasts = [];
  List<dynamic> liveEvents = [];
  List<dynamic> savedBroadcasts = [];
  List<dynamic> savedEvents = [];


  @override
  void initState() {
    liveBroadcasts = widget.data['liveBroadcasts'];
    liveEvents = widget.data['liveEvents'];
    savedBroadcasts = widget.data['savedBroadcasts'];
    savedEvents = widget.data['savedEvents'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Broadcasts"
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
          "Live",
          textAlign: TextAlign.center,
            style:TextStyle(color:Colors.white,
                fontSize: 16
                ),
              )
              ),
              Tab(
                child: Text("Saved",
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
            Container(
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.black,
                        tabs: [
                          Tab(
                            child: Text(
                              "Broadcasts",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                                "Events",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                              ),
                            ),
                          )
                        ]),
                    Container(
                      height: 566,
                      //width: MediaQuery.of(context).size.width,
                      child: TabBarView(
                        children: [
                          ListView.builder(
                              itemCount: this.liveBroadcasts.length,
                              itemBuilder: (context, index) {
                                var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss");
                                String formattedTime = this.liveBroadcasts[index]['expirationTime'].toString().substring(0, 10) + " " + this.liveBroadcasts[index]['expirationTime'].toString().substring(11, 19);
                                String time = dateTime.parse(formattedTime, true).toLocal().toString().substring(0, 16);
                                return InkWell(
                                  onTap: () async {
                                    Map<String, dynamic> data = await showGeneralDialog(
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
                                          List<dynamic> tags = this.liveBroadcasts[index]['tags'];
                                          return DialogBox(
                                            broadcast: this.liveBroadcasts[index],
                                            isUserBroadcast: true,
                                            savedBroadcasts: savedBroadcasts,
                                          );
                                        }
                                    );
                                    setState(() {
                                      savedBroadcasts = data['return'];
                                    });
                                  },
                                  child: BroadCast(
                                    text1: "Expiration Time : $time",
                                    text2: this.liveBroadcasts[index]['content']
                                  ),
                                );
                              }
                          ),
                          ListView.builder(
                              itemCount: this.liveEvents.length,
                              itemBuilder: (context, index) {
                                String eventTime = this.liveEvents[index]['time'];
                                return InkWell(
                                  onTap: () async {
                                    Map<String, dynamic> data = await showGeneralDialog(
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
                                          return DialogBox(
                                            broadcast: this.liveEvents[index],
                                            isUserEvent: true,
                                            savedEvents: savedEvents,
                                          );
                                        }
                                    );
                                    setState(() {
                                      savedEvents = data['return'];
                                    });
                                  },
                                  child: BroadCast(
                                      text1: "Event Time : $eventTime",
                                      text2: this.liveEvents[index]['content']
                                  ),
                                );
                              }
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.black,
                        tabs: [
                          Tab(
                            child: Text(
                                "Broadcasts",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                                "Events",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              ),
                            ),
                          )
                        ]),
                    Container(
                      height: 566,
                      child: TabBarView(
                        children: [
                          ListView.builder(
                              itemCount: this.savedBroadcasts.length,
                              itemBuilder: (context, index) {
                                var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss");
                                String formattedTime = this.savedBroadcasts[index]['time'].toString().substring(0, 10) + " " + this.savedBroadcasts[index]['time'].toString().substring(11, 19);
                                String time = dateTime.parse(formattedTime, true).toLocal().toString().substring(0, 16);
                                return InkWell(
                                  onTap: () async {
                                    Map<String, dynamic> data = await showGeneralDialog(
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
                                          List<dynamic> tags = this.savedBroadcasts[index]['tags'];
                                          return DialogBox(
                                            broadcast: this.savedBroadcasts[index],
                                            isSavedBroadcast: true,
                                            savedBroadcasts: savedBroadcasts,
                                          );
                                        }
                                    );
                                    setState(() {
                                      savedBroadcasts = data['return'];
                                    });
                                  },
                                  child: BroadCast(
                                      text1: "Expiry time: $time",
                                      text2: this.savedBroadcasts[index]['content'],
                                  ),
                                );
                              }
                          ),
                          ListView.builder(
                              itemCount: this.savedEvents.length,
                              itemBuilder: (context, index) {
                                String eventTime = this.savedEvents[index]['time'];
                                return InkWell(
                                  onTap: () async {
                                    Map<String, dynamic> data = await showGeneralDialog(
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
                                          return DialogBox(
                                            broadcast: this.savedEvents[index],
                                            isSavedEvent: true,
                                            savedEvents: savedEvents,
                                          );
                                        }
                                    );
                                    setState(() {
                                      savedEvents = data['return'];
                                    });
                                  },
                                  child: BroadCast(
                                      text1: "Event Time : $eventTime",
                                      text2: this.savedEvents[index]['content']
                                  ),
                                );
                              }
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
