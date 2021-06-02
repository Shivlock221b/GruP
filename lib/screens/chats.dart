import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/services/ChatCard.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Chats extends StatefulWidget {
  const Chats({Key key, this.socket, this.thisPage}) : super(key: key);
  final Socket socket;
  final Map<String, dynamic> thisPage;
  @override
  _ChatsState createState() => _ChatsState(this.thisPage);
}

class _ChatsState extends State<Chats> {
  List<String> chats = [];
  dynamic data;
  bool isPressed = false;

  Map<String,dynamic> thisPage;
  //_ChatsState(this.thisPage) ;

  NetworkHandler http = NetworkHandler();
  List<String> filteredChats = [];
  TextEditingController _searchText = TextEditingController();
  String input = "";

  @override
  void initState() {
    super.initState();

      print(widget.thisPage['_id']);
      widget.socket.emit('signin', widget.thisPage['_id']);
    }
    //     //print(data);
    //     this.data = data;
    //     this.chats = data['chats'].keys.toList();
    //     this.filteredChats = this.chats;
    //   }))
    // });
    //print(this.data);

  _ChatsState(this.thisPage) {
      // widget.socket.on('/chats', (data) {
      //   print(data);
      // });
    
    this.data = thisPage;
    this.chats = data['chats'].keys.toList().length == 0 ? [] : data['chats'].keys.toList();
    // chats = this.thisPage.keys.toList();
    // data = this.thisPage;
    //print(thisPage);
    _searchText.addListener(() {
      if (_searchText.text.isEmpty) {
        setState(() {
          input = "";
          filteredChats = chats;
        });
      } else {
        setState(() {
          input = _searchText.text;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // widget.socket.onConnect((data) => {
    //   widget.socket.on('/chats', (data) => setState(() {
    //     //print(data);
    //     this.data = data;
    //     this.chats = data['chats'].keys.toList();
    //     this.filteredChats = this.chats;
    //   }))
    // });
    //print(this.chats);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              dispose();
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.blueAccent,
          title: Text(
            "Chats",
          ),
          centerTitle: true,
          actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("New group"),
                  value: "New group",
                ),
                PopupMenuItem(
                  child: Text("New broadcast"),
                  value: "New broadcast",
                ),
                PopupMenuItem(
                  child: Text("Whatsapp Web"),
                  value: "Whatsapp Web",
                ),
                PopupMenuItem(
                  child: Text("Starred messages"),
                  value: "Starred messages",
                ),
                PopupMenuItem(
                  child: Text("Settings"),
                  value: "Settings",
                ),
              ];
            },
          )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                // IconButton(
                //   icon: Icon(Icons.arrow_back_ios),
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width - 20,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(20))),
                      color: Colors.white
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
                    ),
                  ),
                ),
                // PopupMenuButton<String>(
                //   onSelected: (value) {
                //     print(value);
                //   },
                //   itemBuilder: (BuildContext context) {
                //     return [
                //       PopupMenuItem(
                //         child: Text("New group"),
                //         value: "New group",
                //       ),
                //       PopupMenuItem(
                //         child: Text("New broadcast"),
                //         value: "New broadcast",
                //       ),
                //       PopupMenuItem(
                //         child: Text("Whatsapp Web"),
                //         value: "Whatsapp Web",
                //       ),
                //       PopupMenuItem(
                //         child: Text("Starred messages"),
                //         value: "Starred messages",
                //       ),
                //       PopupMenuItem(
                //         child: Text("Settings"),
                //         value: "Settings",
                //       ),
                //     ];
                //   },
                // )
              ],
            ),
            Divider(height: 10, thickness: 1,),
            _searchText.text.isEmpty ? Expanded(
              flex: 2,
              child: ListView.builder(

                itemCount: chats.length,
                shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        if (!isPressed) {
                          setState(() {
                            isPressed = true;
                          });
                          print(data['chats'][chats[index]]);
                          var response = await http.getChats(
                              'api/chats', data['chats'][chats[index]],
                              chats[index]);
                          List<dynamic> textChain = json.decode(
                              response.body)['textChain'];
                          String socketId = json.decode(
                              response.body)['socketId'];
                          print(socketId);
                          await Navigator.push(context, MaterialPageRoute(
                              builder: (builder) =>
                                  IndividualChat(
                                      socket: widget.socket,
                                      data: this.data,
                                      chat: textChain,
                                      socketId: socketId,
                                      chatId: data['chats'][chats[index]],
                                      chatName: chats[index]
                                  )));
                          //print(json.decode(response.body)['textChain']);
                          //print(chats[index]);
                        }
                        setState(() {
                          isPressed = false;
                        });
                      },
                        child: ChatCard(chatName: chats[index])
                    );
                  },
                  ),
            ) : searchListBuilder()
          ],
        ),
      ),
    );
  }

  Widget searchListBuilder() {
    if (input.isNotEmpty) {
      List<String> tempList = [];
      for (int i = 0; i < filteredChats.length; i++) {
        if (filteredChats[i].toLowerCase().contains(input.toLowerCase())) {
          tempList.add(filteredChats[i]);
        }
      }
      filteredChats = tempList;
    }
    return Expanded(
      flex: 2,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () async {
                print(data['chats'][filteredChats[index]]);
                var response = await http.getChats('api/chats', data['chats'][filteredChats[index]], filteredChats[index]);
                List<dynamic> textChain = json.decode(response.body)['textChain'];
                String socketId = json.decode(response.body)['socketId'];
                print(socketId);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => IndividualChat(
                    socket: widget.socket,
                    data: this.data,
                    chat: textChain,
                    socketId: socketId,
                    chatId: data['chats'][filteredChats[index]],
                    chatName : filteredChats[index]
                )));
                //print(json.decode(response.body)['textChain']);
                //print(filteredChats[index]);
              },
              child: ChatCard(chatName: filteredChats[index])
          );
        },
        itemCount: filteredChats.length,
        shrinkWrap: true,
      ),
    ) ;
  }


}

