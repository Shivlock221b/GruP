import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:grup/services/broadcast.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../tags.dart';

class GroupBroadCasts extends StatefulWidget {

  //List<Location> list = [];

  @override
  _GroupBroadCastsState createState() => _GroupBroadCastsState();
}

class _GroupBroadCastsState extends State<GroupBroadCasts> {
  Socket socket;
  NetworkHandler http = NetworkHandler();
  List<dynamic> groups = [];
  ScrollController _scrollController = ScrollController();
  bool ready = false;
  bool clicked = false;
  double _value = 500.0;
  //LocationData _locationData;
  Map<String, dynamic> _locationData;
  @override
  void initState() {
    getGroups().then((groupList) {
      print(groupList);
      setState(() {
        groups = groupList;
        ready = true;
      });
    });
    //getBroadcasts();
    super.initState();

  }

  Future<List<dynamic>> getGroups() async {
    var response = await http.get('api/getGroups');
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data['groups'];
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    _locationData = applicationBloc.selectedLocation;
    socket = data['socket'];


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.blue[600],
          ),
          backgroundColor: Colors.yellow[300],
          centerTitle: true,
          title: Text(
            "Groups",
            style: TextStyle(
              color: Colors.blue[600],
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                    Icons.location_searching
                ),
                onPressed: () {
                  setState(() {
                    clicked = true;
                  });
                }
            )
          ],
        ),
        backgroundColor: Colors.blue[50],
        body: ready ? Stack(
          children: [
            // Container(
            //     // child: Image.asset(
            //     //     'assets/singapore.jpg',
            //     //   fit: BoxFit.cover,
            //     // ),
            //   ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: groups.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print(groups[index]['content']);
                    return Geolocator.distanceBetween(
                        groups[index]['location']['Latitude'], groups[index]['location']['Longitude'],
                        _locationData['latitude'], _locationData['longitude']) <= _value ?
                    InkWell(
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
                              List<dynamic> tags = groups[index]['tags'];
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
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (builder) {
                                                      return ViewProfile();
                                                    }
                                                ));
                                              },
                                              child: Text(
                                                groups[index]['name'],
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
                                                groups[index]['content'],
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
                                                // TextButton(
                                                //   onPressed: () {},
                                                //   child: Text(
                                                //       "Endorse"
                                                //   ),
                                                // ),
                                                TextButton(
                                                    onPressed: () async {
                                                      Response response = await http.post("api/joinChat", groups[index]);
                                                      print(response.body);
                                                      if (response.statusCode == 400) {
                                                        final snackBar = SnackBar(
                                                          content: Text("Chat already exists"),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                                          'socketId': data['newChat']['members']
                                                              .values.toList(),
                                                          "userName": applicationBloc
                                                              .user['userName']
                                                        };
                                                        socket.emit(
                                                            "/newMember",
                                                            sendData);
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    builder) =>
                                                                    IndividualChat(
                                                                      socket: socket,
                                                                      data: applicationBloc.user,
                                                                      chat: data['textChain']['textChain'],
                                                                      //socketId: chatDetails['receiver']['socketId'],
                                                                      chatId: data['newChat']['chatId'],
                                                                      chatName: data['newChat']['name'],
                                                                    )
                                                            ));
                                                      }
                                                    },
                                                    child: Text(
                                                        "Join Group"
                                                    )
                                                ),
                                                // TextButton(
                                                //   onPressed: () {},
                                                //   child: Text(
                                                //       "Comment"
                                                //   ),
                                                // )
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
                        text1: groups[index]['name'],
                        text2: groups[index]['content'],),
                    ) : Container();
                  }
              ),
            ),
            clicked ? Positioned(
              top: 40,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.all(Radius.circular(45.0))
                ),
                height: 500,
                width: 100,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SfSlider.vertical(
                        min: 0.0,
                        max: 2000.0,
                        value: _value,
                        interval: 200.0,
                        showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        stepSize: 100,
                        //showDivisors: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _value = newValue;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        setState(() {
                          clicked = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ) : Container()
          ],
        ) : Center(child : CircularProgressIndicator()),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.bolt),
            backgroundColor: Colors.yellow[600],
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/createBroadcast');
            },
          ),
        ),
      ),
    );
  }
}