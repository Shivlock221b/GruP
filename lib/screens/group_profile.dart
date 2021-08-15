import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/Pages/GroupChat.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/theirTags.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../tags.dart';

class GroupProfile extends StatefulWidget {
  GroupProfile({Key key, this.socket, this.group, this.isChatPage = false}) : super(key: key);
  Socket socket;
  Map<String, dynamic> group;
  bool isChatPage;

  @override
  _GroupProfileState createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {

  Map<String, dynamic> group;
  List<dynamic> tags = [];
  List<dynamic> members = [];
  NetworkHandler http = NetworkHandler();

  @override
  void initState() {
    getGroup().then((map) {
      print(map);
      setState(() {
        this.tags = map['tags'];
        this.members = map['members'];
      });
    });
    super.initState();
  }

  Future<Map<String,dynamic>> getGroup() async {
    Map<String, dynamic> map = {
      "members": widget.group['members'],
      "tags": widget.group['tags']
    };
    var response = await http.post('api/getGroupProfile', map);
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data;
  }

  @override
  Widget build(BuildContext context) {

    var applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow[300],
        centerTitle: false,
        title: Text( widget.group['name'],
          style: TextStyle(
            color: Colors.black,
          ),//textStyle
        ),//Text
        actions:<Widget>[
          PopupMenuButton<int>(
            onSelected: (value) async {
              if (value == 0) {
                Response response = await http.post("api/leaveGroup", widget.group);
                widget.group['members'].remove(applicationBloc.user['userName']);
                Map<String, dynamic> map = {
                  "userName": applicationBloc.user['userName'],
                  'chatId': widget.group['chatId']
                };
                applicationBloc.removeChat(widget.group['name']);
                widget.socket.emit("leaveGroup", map);
                if (widget.isChatPage) {
                  Navigator.popUntil(context, ModalRoute.withName("/profilePage"));
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return widget.group['members'].contains(applicationBloc.user['userName']) ? [
                PopupMenuItem(
                  child: Text("Leave Group"),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text("Report Group"),
              value: 1
                )
              ] : [
                PopupMenuItem(
                child: Text("Report Group"),
                value: 1
                )
              ];
            },
          )
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
              child: CircleAvatar(
                  backgroundImage : http.getImage(widget.group['profilepic']
                  ),
                  radius:70
              ),
            ),
          ),
          Divider(height:5),
          SizedBox(height:10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : <Widget>[
              ElevatedButton.icon(
                style:ElevatedButton.styleFrom(
                  primary : Colors.yellow[300],
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                  padding : EdgeInsets.symmetric(horizontal:25),
                ),
      onPressed: () async {
        Response response = await http.post("api/joinChat", widget.group);
        Map<String, dynamic> chatDetails = json.decode(response.body);
        print(response.body);
        if (response.statusCode == 400) {
          if (widget.isChatPage) {
            Navigator.pop(context);
          } else {
            // final snackBar = SnackBar(
            //   content: Text("Chat already exists"),
            // );
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            await Navigator.push(context, MaterialPageRoute(
                builder: (builder) => GroupChat(
                    socket: widget.socket,
                    data: applicationBloc.user,
                    chat: [],
                    chatId: chatDetails['chat']['chatId'],
                    chatName: chatDetails['chat']['name']
                )
            ));
          }
        } else {
          Map<String,
              dynamic> data = json
              .decode(
              response.body);
          applicationBloc.setUser(
              data['user']);
          print(applicationBloc
              .user);
          Map<String,
              dynamic> sendData = {
            "chatId": data['newChat']['chatId'],
            "userName": applicationBloc
                .user['userName']
          };
          widget.socket.emit(
              "/newMember",
              sendData);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (
                      builder) =>
                      GroupChat(
                        socket: widget.socket,
                        data: applicationBloc.user,
                        chat: data['textChain']['textChain'],
                        //socketId: chatDetails['receiver']['socketId'],
                        chatId: data['newChat']['chatId'],
                        chatName: data['newChat']['name'],
                      )
              ));
        }
      },
                label : Text(
                  "Join Chat",
                  style : TextStyle(
                      fontSize : 16.0,
                      //letterSpacing: 2.0,
                      color:Colors.black
                  ),
                ),
                icon : Icon(Icons.chat, color: Colors.black,),
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
                      Tab(
                        child: Text("Members",
                          textAlign: TextAlign.center,
                          style:TextStyle(color:Colors.black,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    height: 365,
                    child: TabBarView(
                      children: <Widget>[
                        TheirTags(tags: tags,),
                        ListView.builder(
                          itemCount: members.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  Map<String, dynamic> data = {
                                    'name': members[index]['name']
                                  };
                                  Response response = await http.post("api/getOwner", data);
                                  Map<String, dynamic> map = json.decode(response.body);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (builder) {
                                        return ViewProfile(user: map['user'][0], self: map['self'], tags: map['tagMap'], socket: widget.socket, requests: map['request']);
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
                                          backgroundImage: http.getImage(members[index]['profilepic']),
                                        ),
                                      ),
                                      Text(
                                        members[index]['userName'],
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
