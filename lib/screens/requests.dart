import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:grup/services/ChatCard.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Requests extends StatefulWidget {
  const Requests({Key key, this.requests, this.sent, this.socket}) : super(key: key);
  final List<dynamic> requests;
  final List<dynamic> sent;
  final Socket socket;

  @override
  _RequestsState createState() => _RequestsState(requests: requests, sent: sent);
}

class _RequestsState extends State<Requests> {

  List<dynamic> requests = [];
  List<dynamic> sent = [];
  _RequestsState({this.requests, this.sent});
  NetworkHandler http = NetworkHandler();
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {

    print(this.requests);
    print(this.sent);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Requests"
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text("Received",
                  textAlign: TextAlign.center,
                  style:TextStyle(color:Colors.white,
                      fontSize: 16
                  ),
                ),
              ),
              Tab(
                child: Text("Sent",
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
            ListView.builder(
              itemCount: this.requests.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      Map<String, dynamic> data = {
                        "name": requests[index]["sender"]['name']
                      };
                      Response response = await http.post("api/getOwner", data);
                      Map<String, dynamic> map;
                      map = json.decode(response.body);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (builder) {
                            return ViewProfile(user: map['user'][0], self: map['self'], tags: map['tagMap'], socket: widget.socket, requests: map['request'], friends: map['friends'],);
                          }
                      ));
                    },
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(0),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            requests[index]['sender']['name'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
            ListView.builder(
                itemCount: this.sent.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      Map<String, dynamic> data = {
                        "name": sent[index]["receiver"]['name']
                      };
                      Response response = await http.post("api/getOwner", data);
                      Map<String, dynamic> map;
                      map = json.decode(response.body);
                      print(map['request']);
                      logger.i(map['friends']);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (builder) {
                            return ViewProfile(user: map['user'][0], self: map['self'], tags: map['tagMap'], socket: widget.socket, requests: map['request'], friends: map['friends'],);
                          }
                      ));
                    },
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(0),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            sent[index]['receiver']['name'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
