import 'dart:convert';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:grup/screens/chats.dart';
import 'package:grup/tags.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grup/navdrawer.dart';
import 'package:grup/networkHandler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String text = "";
  TextEditingController _controller = TextEditingController();
  bool isPressed = false;

  //List<String> tags = [];
  String baseUrl = '10.120.8.146:3000';
  NetworkHandler hello = NetworkHandler();
  String uri = Uri.http('10.120.8.146:3000', "").toString();
  // IO.Socket socket = IO.io(Uri.https('grup-backend.herokuapp.com', "").toString(),
  //         OptionBuilder()
  //         .setTransports(['websocket'],)// optional
  //         .build(),
  // );
  IO.Socket socket = IO.io(Uri.https('10.120.8.146:3000', "").toString(),
    OptionBuilder()
        .setTransports(['websocket'],)// optional
        .build(),
  );

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute
        .of(context)
        .settings
        .arguments;
    List<String> tags = [];
    print(data);
    print(data['queryUser']);
    if (data['queryUser'][0]['tags'].length > 0) {
      for (int i = 0; i < data['queryUser'][0]['tags'].length; i++) {
        tags.add(data['queryUser'][0]['tags'][i]);
      }
    }
    bool showFb = MediaQuery
        .of(context)
        .viewInsets
        .bottom != 0;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        drawer: NavDrawer(),
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(
                    Icons.message
                ),
                onPressed: () async {
                  // String uri = Uri.http(baseUrl, "").toString();
                  //if (!isPressed) {
                    setState(() {
                      isPressed = true;
                    });
                    if (socket.connected) {
                      print("connected12314234");
                    }

                    Map<String, dynamic> map = {
                      '_id': data['queryUser'][0]['_id'],
                    };
                    var response = await hello.getTextChains(
                        'api/getChats', map);
                    print(socket.id);

                    // socket.on('/chats', (data) {
                    //   print(data);
                    //   nextPage = data;
                    // });

                    print(json.decode(response.body));
                    await Navigator.push(context, MaterialPageRoute(
                        builder: (builder) =>
                            Chats(
                              socket: socket,
                              thisPage: (json.decode(response
                                  .body))['loggeduser'],
                            )
                    ));
                  //}
                  // setState(() {
                  //   isPressed = false;
                  // });
                }
            ),
          ],
          backgroundColor: Colors.blueAccent,
          title: Text(
            data['queryUser'][0]['userName'],
            style: TextStyle(
                color: Colors.white
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/The_minions_in_Minions.jpg',
                              ),
                              fit: BoxFit.cover
                          )
                      ),
                      child: new BackdropFilter(
                        filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: new Container(
                          decoration: new BoxDecoration(color: Colors.yellow
                              .withOpacity(0.0)),
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/${data['queryUser'][0]['profilepic']}',
                              ),
                              radius: 100.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: 50.0),
                ],
              ),
            ),
            Divider(height: 10.0),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: SizedBox(
                  //height: 350.0,
                  child: Column(
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Center(
                          child: Container(
                            child: Text(
                              "Broadcasts",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.blue[900]
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  IconButton(
                                      color: Colors.blue[900],
                                      icon: Icon(
                                          // Icons.personal_video_outlined,
                                        Icons.local_activity
                                      ),
                                      iconSize: 40,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/localBroadcasts');
                                      }),
                                  Text(
                                    "Local",
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  IconButton(
                                    color: Colors.blue[900],
                                    icon: Icon(
                                        Icons.event
                                    ),
                                    iconSize: 40,
                                    onPressed: () {
                                      print("find event");
                                    },
                                  ),
                                  Text(
                                    "Event",
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  IconButton(
                                    color: Colors.blue[900],
                                    icon: Icon(
                                        Icons.group_outlined
                                    ),
                                    iconSize: 40,
                                    onPressed: () {

                                    },
                                  ),
                                  Text(
                                    "Group",
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: <Widget>[
                                  IconButton(
                                    color: Colors.blue[900],
                                    icon: Icon(
                                        Icons.person
                                    ),
                                    iconSize: 40,
                                    onPressed: () {

                                    },
                                  ),
                                  Text(
                                    "Friend",
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  IconButton(
                                    color: Colors.blue[900],
                                    icon: Icon(
                                        Icons.public
                                    ),
                                    iconSize: 40,
                                    onPressed: () {
                                      //hello.get('/api/getInfo');
                                    },
                                  ),
                                  Text(
                                    "Trending",
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 0.5),
                        Card(
                          shadowColor: Colors.blue[900],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "TAGS",
                                  style: TextStyle(
                                    fontSize: 20,
                                    //fontFamily: 'Lobster',
                                    color: Colors.blue[900],
                                    //backgroundColor: Colors.grey[100]
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: tags.map((x) => Tag(text: x)).toList()
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.all(8.0),
                                        width: 50,
                                        child: TextFormField(
                                          controller: _controller,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0))
                                              ),
                                              contentPadding: EdgeInsets.fromLTRB(
                                                  20.0, 0, 20.0, 0),
                                              hintText: 'Enter a Tag name'
                                          ),
                                          onChanged: (text) {
                                            this.text = text;
                                          },
                                        ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          data['queryUser'][0]['tags'].add(
                                              this.text);
                                        });
                                        _controller.clear();
                                      },
                                      label: Text(
                                        "Add Tag",
                                      ),
                                    ),
                                    SizedBox(width: 80)
                                  ]
                              )
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: !showFb,
          child: FloatingActionButton(
            child: Icon(Icons.bolt),
            backgroundColor: Colors.yellow[600],
            onPressed: () {
              Navigator.pushNamed(context, '/createBroadcast');
            },
          ),
        ),
      ),
    );
  }
}
