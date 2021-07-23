import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SearchByName extends StatefulWidget {
  const SearchByName({Key key, this.user, this.socket}) : super(key: key);
  final Map<String, dynamic> user;
  final Socket socket;
  @override
  _SearchByNameState createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {

  TextEditingController _searchText = TextEditingController();
  Timer timeHandle;
  NetworkHandler http = NetworkHandler();
  List<dynamic> users = [];
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    if (timeHandle != null) {
      timeHandle.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(20)))
              ),
              child: TextFormField(
                  controller: _searchText,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blueAccent
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: "Search for a textChain"
                  ),
                  onChanged: (text) {
                    if (text == "") {
                      setState(() {
                        users = [];
                      });
                      return;
                    }
                    if (timeHandle != null) {
                      timeHandle.cancel();
                    }
                    timeHandle = Timer(Duration(milliseconds: 500), () async {
                      Map<String, dynamic> data = {
                        "searchText" : text,
                        "user" : widget.user['userName']
                      };
                      Response response = await http.post("api/getFilteredUsers", data);
                      print(response.body);
                      setState(() {
                        users = json.decode(response.body)['users'];
                      });
                    });
                  }
              ),
            ),
            ListView.builder(
              controller: _scrollController,
              itemCount: users.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      Map<String, dynamic> data = {
                        'name': users[index]['userName']
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
                            users[index]['userName'],
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
