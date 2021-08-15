import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/Pages/GroupChat.dart';
//import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/Pages/individual_Chat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/db/datasource.dart';
import 'package:grup/models/local_message.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/services/ChatCard.dart';
import 'package:grup/services/encryption_service.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Chats extends StatefulWidget {
  const Chats({Key key, this.socket, this.thisPage}) : super(key: key);
  final Socket socket;
  final Map<String, dynamic> thisPage;
  @override
  _ChatsState createState() => _ChatsState(this.thisPage, this.socket);
}

class _ChatsState extends State<Chats> {
  List<dynamic> chats = [];
  dynamic data;
  bool isPressed = false;
  Socket socket;
  Map<String,dynamic> thisPage;
  //_ChatsState(this.thisPage) ;
  int count = 0;
  DataSource _dataSource;

  NetworkHandler http = NetworkHandler();
  List<dynamic> filteredChats = [];
  TextEditingController _searchText = TextEditingController();
  String input = "";

  @override
  void initState() {


    print(widget.thisPage['_id']);

    _dataSource = http.dataSource;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _ChatsState(this.thisPage, this.socket);


  @override
  Widget build(BuildContext context) {

    var applicationBloc = Provider.of<ApplicationBloc>(context);
    print(applicationBloc.user['chats']);
    this.data = applicationBloc.user;
    print("inside chats");
    print(this.data);
    //this.data = thisPage;
    //this.chats = data['chats'].keys.toList().length == 0 ? [] : data['chats'].keys.toList();
    this.chats = data['chats'].length == 0 ? [] : data['chats'];
    this.filteredChats = this.chats;

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
    child: InkWell(
    child: Text("New group"),
    onTap: () {
    print(applicationBloc.user);
    },
    ),
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
    width: 370,
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
    onChanged: (text) {
    filteredChats = this.chats;
    if (text.isNotEmpty) {
    List<dynamic> tempList = [];
    for (int i = 0; i < filteredChats.length; i++) {
    if (filteredChats[i]['name'].toLowerCase().contains(text.toLowerCase())) {
    tempList.add(filteredChats[i]);
    }
    }
    setState(() {
    filteredChats = tempList;
    });
    }
    if (text.isEmpty) {
    setState(() {
    filteredChats = this.chats;
    });
    }
    }
    ),
    ),
    ),
    ],
    ),
    Divider(height: 10, thickness: 1,),
    //input.isEmpty ?
    Expanded(
    flex: 2,
    child: ListView.builder(

    //itemCount: chats.length,
    itemCount: filteredChats.length,
    shrinkWrap: true,
    itemBuilder: (context, index) {
    return InkWell(
    onTap: () async {
    if (!isPressed) {
    setState(() {
    isPressed = true;
    });
    // applicationBloc.setCounterNull(filteredChats[index]['chatId']);
    // applicationBloc.setUserCounter(filteredChats[index]['count']);
    print(filteredChats[index]['chatId']);
    String chatId = filteredChats[index]['chatId'];
    print("check chat problem");
    print(filteredChats[index]);
    String chatName = filteredChats[index]['name'];
    var response = await http.getChats(
    'api/chats', filteredChats[index]['chatId'], filteredChats[index]['isGroup']);
    List<dynamic> textChain = json.decode(
    response.body)['textChain'];

    Map<String, dynamic> group = json.decode(response.body)["group"];
    filteredChats[index]['unread'].forEach((element) async {
      element['message'] = EncryptionService.decryptAES(element['message']);
    LocalMessage message = LocalMessage(filteredChats[index]['chatId'], element['sender'], element['message'], element['time'], data['userName']);
    await _dataSource.addMessage(message);
    });
    filteredChats[index]['unread'].clear();
    applicationBloc.clearUnread(filteredChats[index]);
    // Map<String, dynamic> onlineData = {
    // "chatId": filteredChats[index]['chatId'],
    // "userName": data['userName']
    // };
    // socket.emit("/online", onlineData);
    // Map<String, dynamic> socketIds = json.decode(
    // response.body)['socketIds'];
    // print(socketIds);
    //if (filteredChats[index]['isGroup']) {
    //widget.socket.emit('join', filteredChats[index]['chatId']);
    if (!filteredChats[index]['isGroup']) {
    // textChain.forEach((element) async {
    // LocalMessage message = LocalMessage(filteredChats[index]['chatId'], element['sender'], element['message'], element['time'], data['userName']);
    // await _dataSource.addMessage(message);
    // });

    // List<dynamic> ids = socketIds.values.toList();
    // print(socketIds.values);
    // Map<String, dynamic> onlineData = {
    // "socketIds" : ids,
    // "chatName" : chatName,
    // "sender" : data['userName']
    // };
    //
    // Map<String, dynamic> updateSocket = {
    // "chatName" : chatName,
    // "socketIds" : socketIds
    // };
    // //applicationBloc.setUser(data);
    // applicationBloc.setIds(updateSocket);
    await Navigator.push(context, MaterialPageRoute(
    builder: (builder) =>
    IndividualChat(
    socket: widget.socket,
    data: this.data,
    chat: textChain,
    chatId: chatId,
    chatName: chatName,
    isGroup: filteredChats[index]['isGroup'],
    members: chatName,
    )));
    } else {
      await Navigator.push(context, MaterialPageRoute(
        builder: (builder) => GroupChat(
          socket: widget.socket,
          data: this.data,
          chat: textChain,
          chatId: chatId,
          chatName: chatName,
          isGroup: filteredChats[index]['isGroup'],
          members: group['members'],
        )
      ));
    }
    //print(json.decode(response.body)['textChain']);
    //print(chats[index]);
    }
    setState(() {
    isPressed = false;
    });
    },
    //child: ChatCard(chatName: chats[index])
    child: ChatCard(chatName: filteredChats[index]['name'], count: filteredChats[index]['count'],),
    );
    },
    ),
    ) //: searchListBuilder()
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
                var response = await http.getChats('api/chats', filteredChats[index]['chatId'], filteredChats[index]['isGroup']);
                List<dynamic> textChain = json.decode(response.body)['textChain'];
                List<String> socketId = json.decode(response.body)['socketId'];
                print(socketId);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => IndividualChat(
                    socket: widget.socket,
                    data: this.data,
                    chat: textChain,
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

