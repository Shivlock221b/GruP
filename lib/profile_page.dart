import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/Pages/chat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/db/datasource.dart';
import 'package:grup/models/local_message.dart';
// import 'package:grup/screens/chats.dart';
import 'package:grup/screens/friendBroadcasts.dart';
import 'package:grup/screens/trending.dart';
import 'package:grup/services/customLocation.dart';
import 'package:grup/services/encryption_service.dart';
import 'package:grup/services/searchTags.dart';
import 'package:grup/tags.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grup/navdrawer.dart';
import 'package:grup/networkHandler.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:grup/credentials/secrets.dart' as google;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.user}) : super(key: key);
  Map<String, dynamic> user;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>  with WidgetsBindingObserver {

  bool create = false;
  var logger = Logger();
  String text = "";
  TextEditingController _controller = TextEditingController();
  bool isPressed = false;
  bool _serviceEnabled;
  loc.Location _location = loc.Location();
  loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData;
  Map<String, dynamic> data;
  List<String> tags = [];
  google.Secrets obj = google.Secrets();
  String kGoogleApiKey;
  Map<String, dynamic> clocation;
  bool hasLoggedOut = false;
  int count = 0;
  int calls = 0;
  String selectedAddress = '';
  Timer timeHandle;
  DataSource _dataSource;
  List<String> suggestedTags = [];
  //String baseUrl = '10.120.8.146:3000';
  NetworkHandler hello = NetworkHandler();
  //String uri = Uri.http('10.120.8.146:3000', "").toString();
  //List<dynamic> searchResults = [];
  // IO.Socket socket = IO.io(Uri.https('grup-backend.herokuapp.com', "").toString(),
  //         OptionBuilder()
  //         .setTransports(['websocket'],)// optional
  //         .build(),
  // );
  // IO.Socket socket = IO.io(Uri.http('10.120.8.146:3000', "").toString(),
  //   OptionBuilder()
  //       .setTransports(['websocket'],)
  //       //.disableAutoConnect()
  //       .build(),
  // );
  // IO.Socket socket = IO.io(Uri.http('172.31.75.147:3000', "").toString(),
  //   OptionBuilder()
  //       .setTransports(['websocket'],)
  //   //.disableAutoConnect()
  //       .build(),
  // );
  IO.Socket socket = IO.io(Uri.http('172.31.75.128:3000', "").toString(),
    OptionBuilder()
        .setTransports(['websocket'],)
    //.disableAutoConnect()
        .build(),
  );



  @override
  void initState() {
    _dataSource = hello.dataSource;
    socket.connect();
    print("connecttttttttttttttttttt");
    print(widget.user['_id']);
    socket.emit("signin", widget.user['_id']);
    socket.on('messageSave', (data) async {
        print("inside receive in profile page");
        data['message'] = EncryptionService.decryptAES(data['message']);
        LocalMessage message = LocalMessage(
            data['chatId'], data['sender'], data['message'], data['time'],
            this.data['userName']);
        await _dataSource.addMessage(message);
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      print(data);
      print("inside receive");
        applicationBloc.setCounter(data);
        hello.post('api/updateCounter', applicationBloc.user);
      //}
    });

    socket.on("online", (data) {
      print("online inside individual" + data['userName']);
      Map<String, dynamic> senderData = {
        "chatId": data['chatId'],
        "userName": this.data['userName']
      };
      socket.emit("/replyOnline", senderData);
    });

    socket.on("logOut", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      print("inside logout");
     // applicationBloc.setNull(data);
    });

    socket.on("needCounter", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      print("inside needCounter");
      //applicationBloc.updateUser(data);
      applicationBloc.setUser(data);
    });

    socket.on("newChat", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      socket.emit("join", data['newChat']['_id']);
      applicationBloc.setUser(data['receiver']);
    });

    socket.on("newMember", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.addId(data);
    });

    socket.on("signed in", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.updateUserData(data);
    });

    socket.on("/leave", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.removeFriendAndChat(data, socket);
    });

    socket.on("requestAccepted", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.addFriend(data);
    });

    socket.on("friendAdded", (data) {
      var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.addFriend(data);
    });

    print("Shivvvvvvvvv");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (timeHandle != null) {
      timeHandle.cancel();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    switch(state) {
      case AppLifecycleState.paused:
        print("inside paused");
        socket.emit("detached", data);
        print(data);
        return;
      case AppLifecycleState.inactive:
        print("inside inactive");
        print(data);
        return;
      case AppLifecycleState.detached:
        print("inside detached");
        print(data);
        return;
      case AppLifecycleState.resumed:
        print("inside resumed");
        applicationBloc.setUser(widget.user);
        socket.emit("resume", data['_id']);
        print(data);
        return;
    }
  }



  // @override
  // void dispose() {
  //   timeHandle.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    final applicationBLoc = Provider.of<ApplicationBloc>(context, listen: true);
    //applicationBLoc.setUser(widget.user);
    data = applicationBLoc.user?? widget.user;
    //print(data);
    tags = [];
    if (data['tags'].length > 0) {
      for (int i = 0; i < data['tags'].length; i++) {
        tags.add(data['tags'][i]);
      }
    }
    //socket.connect();
    //socket.emit('signin', data['_id']);
    // socket.on('online', (data) {
    //   print("inside online in profile page");
    //   if (applicationBLoc.user == null) {
    //     applicationBLoc.setUser(this.data);
    //   }
    //   // applicationBLoc.setId(data);
    //   // print(applicationBLoc.user);
    // });


    bool showFb = MediaQuery
        .of(context)
        .viewInsets
        .bottom != 0;
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blue[50],
          drawer: NavDrawer(data: data, socket: socket,hasLoggedOut: hasLoggedOut,),
          appBar: AppBar(
            actions: [
              Stack(
                children: [
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
                            '_id': data['_id'],
                          };
                          var response = await hello.getTextChains(
                              'api/getChats', map);
                          print(socket.id);
                          Map<String,dynamic> loggedUser = json.decode(response.body)['loggeduser'];
                          loggedUser['count'] = 0;
                          applicationBLoc.setUser(loggedUser);

                          // socket.on('/chats', (data) {
                          //   print(data);
                          //   nextPage = data;
                          // });

                          print(json.decode(response.body));
                          await Navigator.push(context, MaterialPageRoute(
                              builder: (builder) =>
                                  Chats(
                                    socket: socket,
                                    thisPage: loggedUser,
                                  )
                          ));
                        //}
                        // setState(() {
                        //   isPressed = false;
                        // });
                      }
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Text(
                      //count.toString()
                      // applicationBLoc.user != null?
                      //   applicationBLoc.user['count'].toString() :
                      data['count'].toString()
                    ),
                  ),
                ],
              ),
            ],
            backgroundColor: Colors.blueAccent,
            title: Text(
              data['userName'],
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
              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Expanded(
              //         flex: 1,
              //         child: Container(
              //           decoration: BoxDecoration(
              //               image: DecorationImage(
              //                   image: AssetImage(
              //                     'assets/The_minions_in_Minions.jpg',
              //                   ),
              //                   fit: BoxFit.cover
              //               )
              //           ),
              //           child: new BackdropFilter(
              //             filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
              //             child: new Container(
              //               decoration: new BoxDecoration(color: Colors.yellow
              //                   .withOpacity(0.0)),
              //               padding: EdgeInsets.all(8.0),
              //               child: Center(
              //                 child: CircleAvatar(
              //                   backgroundImage: AssetImage(
              //                     'assets/${data['profilepic']}',
              //                   ),
              //                   radius: 100.0,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       //SizedBox(height: 50.0),
              //     ],
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   flex: 1,
                    //child:
                    Center(
                      child: Container(
                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //         image: AssetImage(
                        //           'assets/The_minions_in_Minions.jpg',
                        //         ),
                        //         fit: BoxFit.cover
                        //     )
                        //),
                        // child: new BackdropFilter(
                        // filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        //child: new Container(
                        //   decoration: new BoxDecoration(color: Colors.yellow
                        //       .withOpacity(0.0)),
                        //   padding: EdgeInsets.all(8.0),
                        //   child: Center(
                        //     child: CircleAvatar(
                        //       backgroundImage: AssetImage(
                        //         'assets/${data['queryUser'][0]['profilepic']}',
                        //       ),
                        //       radius: 150.0,
                        //     ),
                        //   ),
                        //decoration:BoxDecoration(
                        // image:DecorationImage(
                        //image:AssetImage('assets/Shivam.jpg',),
                        // Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            //image: AssetImage('assets/${data['profilepic']}'),
                            image: hello.getImage(data['profilepic'])
                          ),
                        ),
                        //),
                        // ),
                        //),
                        //image:AssetImage(),
                        //),
                        //),
                      ),
                    ),
                    //),
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
                                          logger.i(applicationBLoc.selectedLocation);
                                          Map<String, dynamic> data = {
                                            "_locationData": applicationBLoc.selectedLocation,
                                            "socket": socket,
                                            "user" : this.data
                                          };
                                          Navigator.pushNamed(
                                              context, '/localBroadcasts', arguments: data);
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
                                        logger.i(applicationBLoc.selectedLocation);
                                        Map<String, dynamic> data = {
                                          "_locationData": applicationBLoc.selectedLocation,
                                          "socket": socket
                                        };
                                        Navigator.pushNamed(
                                            context, '/eventBroadcasts', arguments: data);
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
                                        logger.i(applicationBLoc.selectedLocation);
                                        Map<String, dynamic> data = {
                                          "_locationData": applicationBLoc.selectedLocation,
                                          "socket": socket
                                        };
                                        Navigator.pushNamed(
                                            context, '/groupBroadcasts', arguments: data);
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
                                      onPressed: () async {
                                        //Response response = await hello.get("api/getFriendBroadcasts");
                                        //logger.i(json.decode(response.body));
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (builder) => FriendBroadcasts(user: this.data, socket: this.socket,)
                                        ));
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
                                      onPressed: () async {
                                        // Response response = await hello.get("api/getAllTags");
                                        // print(response.body);
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (builder) => Explore(
                                              socket: socket,
                                              user: data,
                                            )
                                        ));
                                      },
                                    ),
                                    Text(
                                      "Explore",
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 0.5),
                          Card(
                            child: Column(
                              children: [
                                Text(
                                  "Where are you today?",
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                                SizedBox(height: 10,),
                                selectedAddress != "" ? Container(
                                  child: Text(
                                    selectedAddress,
                                    style:  TextStyle(
                                      fontSize: 20
                                    ),
                                  ),
                                ) : Container(),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            dynamic data = await showGeneralDialog(
                                                context: context,
                                                barrierLabel: 'Label',
                                                barrierColor: Colors.black.withOpacity(0.5),
                                                barrierDismissible: true,
                                                transitionDuration: Duration(milliseconds: 200),
                                                transitionBuilder: (context, anim1, anim2, child) {
                                                  return SlideTransition(
                                                    position: Tween(begin: Offset(0,1), end: Offset(0,0)).animate(anim1),
                                                    child: child,
                                                  );
                                                },
                                                pageBuilder: (context, animation1, animation2) {
                                                  return CustomLocation(isUserLocation: true);
                                                }
                                            );
                                            setState(() {
                                              selectedAddress = data['title'];
                                            });
                                          },
                                          child: Text(
                                            "Choose Location"
                                          )
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            _serviceEnabled = await _location.serviceEnabled();
                                            if (!_serviceEnabled) {
                                              _serviceEnabled = await _location.requestService();
                                              if (!_serviceEnabled) {
                                                return;
                                              }
                                            }
                                            _permissionGranted = await _location.hasPermission();
                                            if (_permissionGranted == loc.PermissionStatus.denied) {
                                              _permissionGranted = await _location.requestPermission();
                                              if (_permissionGranted != loc.PermissionStatus.granted) {
                                                return;
                                              }
                                            }
                                            _locationData = await _location.getLocation();
                                            applicationBLoc.setUserLocation(_locationData);
                                            print(applicationBLoc.selectedLocation);
                                            print(_locationData);
                                            List<Placemark> list = await placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
                                            setState(() {
                                              selectedAddress = "Your location";
                                            });
                                            print(list[0]);
                                            Map<String, dynamic> data = {
                                              'Latitude' : _locationData.latitude,
                                              'Longitude' : _locationData.longitude,
                                              'address' : list[0]
                                            };
                                            // var response = await hello.patch('api/updateLocation', data);
                                            // print(json.decode(response.body));
                                          },
                                          child: Text(
                                              "Use My Location"
                                          )
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
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
                                  subtitle: Text(
                                    "Double tap on a tag to remove from the list",
                                    style: TextStyle(
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: tags.map((x) => InkWell(
                                      onDoubleTap: () {
                                        tags.remove(x);
                                        this.data['tags'] = tags;
                                        applicationBLoc.setUser(data);
                                      },
                                        child: Tag(text: x))).toList()
                                ),
                                Neumorphic(
                                  style: NeumorphicStyle(
                                    color: Colors.white,
                                    shadowDarkColor: Colors.blue
                                  ),
                                  child: Center(
                                    child: TextButton.icon(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        dynamic data = await showGeneralDialog(
                                            context: context,
                                            barrierLabel: 'Label',
                                            barrierColor: Colors.black.withOpacity(0.5),
                                            barrierDismissible: true,
                                            transitionDuration: Duration(milliseconds: 200),
                                            transitionBuilder: (context, anim1, anim2, child) {
                                              return SlideTransition(
                                                position: Tween(begin: Offset(0,1), end: Offset(0,0)).animate(anim1),
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (context, animation1, animation2) {
                                              return SearchTags(
                                                tags: this.data['tags'],
                                              );
                                            }
                                        );
                                        //setState(() {
                                        if (data != null && data != "") {
                                          tags.add(
                                              data);
                                          //_controller.clear();
                                          this.data['tags'] = tags;
                                          applicationBLoc.setUser(this.data);
                                        }

                                        //});
                                        // if (applicationBLoc.user == null) {
                                        //   applicationBLoc.setUser(data);
                                        // } else {
                                        //   applicationBLoc.addTags(this.text);
                                        //   _controller.clear();
                                        // }
                                      },
                                      label: Text(
                                        "Add Tag",
                                        style: TextStyle(
                                          fontSize: 16
                                        ),
                                      ),
                                    ),
                                  ),
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
            child: !create ? FloatingActionButton(
              child: Icon(Icons.bolt),
              backgroundColor: Colors.yellow[600],
              onPressed: () {
                setState(() {
                  create = true;
                });
                //Navigator.pushNamed(context, '/createBroadcast');
              },
            ) : Container(
              width: 365,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                    color: Colors.yellow[100]
              ),
              //color: Colors.yellow[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.create),
                        onPressed: () {
                          Navigator.pushNamed(context, '/createBroadcast');
                          setState(() {
                            create = false;
                          });
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.blueAccent,
                        child: Icon(
                            Icons.event,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/createEvent');
                          setState(() {
                            create = false;
                          });
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: FloatingActionButton(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.group_add),
                        onPressed: () {
                          Navigator.pushNamed(context, '/createGroup');
                          setState(() {
                            create = false;
                          });
                        }
                    ),
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.bolt),
                    backgroundColor: Colors.yellow[600],
                    onPressed: () {
                      setState(() {
                        create = false;
                      });
                      //Navigator.pushNamed(context, '/createBroadcast');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
