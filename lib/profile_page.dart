import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:grup/tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grup/navdrawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String text = "";
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    bool showFb = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Shivam Tiwari",
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
                        decoration: new BoxDecoration(color: Colors.yellow.withOpacity(0.0)),
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/photo.jpg',
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
                  children : <Widget>[
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
                                    Icons.personal_video_outlined
                                  ),
                                  iconSize: 40,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/localBroadcasts');
                                  }),
                              Text(
                                "Broadcasts",
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
                                "Events",
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
                                  print("find your groups");
                                },
                              ),
                              Text(
                                "Groups",
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
                                  print("find your friends");
                                },
                              ),
                              Text(
                                "Friends",
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
                                    Icons.settings
                                ),
                                iconSize: 40,
                                onPressed: () {
                                  print("set your profile");
                                },
                              ),
                              Text(
                                "Settings",
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
                              fontFamily: 'Lobster',
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
                                  child: TextField(
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 0 , 20.0 ,0),
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
                                    tags.add(this.text);
                                  });
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
        ),
      ),
    );
  }
}
