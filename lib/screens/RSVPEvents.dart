import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/services/DialogBox.dart';
import 'package:grup/services/broadcast.dart';
import 'package:socket_io_client/socket_io_client.dart';

class RSVPEvents extends StatefulWidget {
  RSVPEvents({Key key, this.socket}) : super(key: key);
  Socket socket;


  @override
  _RSVPEventsState createState() => _RSVPEventsState();
}

class _RSVPEventsState extends State<RSVPEvents> {

  NetworkHandler http = NetworkHandler();
  List<dynamic> events;
  bool ready = false;

  @override
  void initState() {
    getEvents().then((list) {
      setState(() {
        events = list;
        ready = true;
      });
    });
    super.initState();
  }

  Future<List<dynamic>> getEvents() async {
    var response = await http.get('api/getRSVPDEvents');
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data['events'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RSVP'd Events"
        ),
      ),
      body: ready? ListView.builder(
        itemCount: events.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                dynamic data = await showGeneralDialog(
                    context: context,
                    barrierLabel: "Label",
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 200),
                    transitionBuilder: (context, anim1, anim2, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation1, animation2) {
                      return DialogBox(
                        broadcast: events[index],
                        isRSVPDEvents: true,
                        socket: widget.socket,
                        rSVPDEvents: this.events,
                      );
                    }
                );
                if (data != null) {
                  setState(() {
                    events = data;
                  });
                }
              },
              child: BroadCast(
                text1: events[index]['sender']['userName'],
                text2: events[index]['content'],)
            );
          }
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
