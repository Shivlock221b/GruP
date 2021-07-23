import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Friends extends StatefulWidget {
  const Friends({Key key, this.friends, this.userName, this.socket}) : super(key: key);
  final List<dynamic> friends;
  final String userName;
  final Socket socket;
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  NetworkHandler http = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Friend List"
        ),
      ),
      body: ListView.builder(
        itemCount: widget.friends.length,
          itemBuilder: (context, index) {
            List<dynamic> friends = widget.friends[index]['friends'];
            Map<String, dynamic> friend = friends[0];
            if (friend['name'] == widget.userName) {
              friend = friends[1];
            }
            return InkWell(
              onTap: () async {
                Map<String, dynamic> data = {
                  'name': friend['name']
                };
                Response response = await http.post("api/getOwner", data);
                Map<String, dynamic> map = json.decode(response.body);
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
                      friend['name'],
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
    );
  }
}
