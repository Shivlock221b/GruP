import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../tags.dart';
import 'broadcast.dart';

class SearchByTags extends StatefulWidget {
  const SearchByTags({Key key, this.socket}) : super(key: key);
  final Socket socket;

  @override
  _SearchByTagsState createState() => _SearchByTagsState();
}

class _SearchByTagsState extends State<SearchByTags> {

  List<String> tags = [];
  List<dynamic> broadcasts = [];
  TextEditingController _tagsController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  NetworkHandler http = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      title: Text(
                        "Tags",
                        style: TextStyle(
                            fontFamily: 'ArchitectsDaughter-Regular.ttf',
                            fontSize: 28
                        ),
                      )
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: tags.map((x) => InkWell(
                        onTap: () {
                          setState(() {
                            tags.remove(x);
                          });
                        },
                        child: Tag(text: x))).toList(),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: double.infinity,
                    child: TextFormField(
                      controller: _tagsController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          hintText: 'Enter a Tag name'
                      ),
                      // onChanged: (text) {
                      //   this.text = text;
                      // },
                    ),
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(
                        color: Colors.white,
                        shadowDarkColor: Colors.blue
                    ),
                    child: Center(
                      child: TextButton.icon(
                        label: Text(
                            "Add Tag"
                        ),
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          tags.add(_tagsController.text);
                          Map<String, dynamic> data = {
                            "tags" : tags
                          };
                          Response response = await http.post("api/getSelectedBroadcasts", data);
                          print(response.body);
                          setState(() {
                            broadcasts = json.decode(response.body)['broadcasts'];
                          });
                          _tagsController.clear();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
              itemCount: broadcasts.length,
                controller: _scrollController,
                shrinkWrap: true,
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
                                                    return ViewProfile(user: map['user'][0], self: map['self'], tags: map['tagMap'], socket: widget.socket, requests: map['request'], friends: map['friends'],);
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
            )
          ],
        ),
      ),
    );
  }
}
