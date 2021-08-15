import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/RSVPEvents.dart';
import 'package:grup/screens/blocked.dart';
import 'package:grup/screens/broadcast_history.dart';
import 'package:grup/screens/friends.dart';
import 'package:grup/screens/newtagsscreen.dart';
import 'package:grup/screens/requests.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class NavDrawer extends StatefulWidget {
  //const NavDrawer({Key key}) : super(key: key);
  Map<String, dynamic> data;
  Socket socket;
  NavDrawer({this.data, this.socket, this.hasLoggedOut});
  bool hasLoggedOut;

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  NetworkHandler http = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // image: DecorationImage(
                  //   image: AssetImage(
                  //     'assets/newDrawer.jpg'
                  //   ),
                  //   fit: BoxFit.fill
                  // )
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.0)),
                    child: Text(
                      'Directory',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        //fontFamily: 'Lobster',
                      )
                    ),
                  ),
                )
                // Text(
                //   "Fields",
                //   style: TextStyle(
                //     color: Colors.blue[900],
                //     fontSize: 28,
                //     fontWeight: FontWeight.bold,
                //     fontFamily: 'Lobster'
                //   ),
                // ),
              ),
            ),
            Divider(height: 10),
            Container(
              //margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
              decoration: BoxDecoration(
                border: Border(
                  //top: BorderSide.merge(new BorderSide(), new BorderSide()),
                  bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
                )
              ),
              child: InkWell(
                onTap: () async {
                  Response response = await http.get("api/getBroadcastHistory");
                  print(response.body);
                  Map<String, dynamic> data = json.decode(response.body);
                  print(data);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (builder) => BroadcastHistory(
                        data: data,
                      )
                  ));
                },
                child: ListTile(
                  title: Text(
                    'Your Broadcasts',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[900],
                      //fontFamily: 'Lobster'
                    ),
                  ),
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
              decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide.merge(new BorderSide(), new BorderSide()),
                    bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
                  )
              ),
              child: InkWell(
                onTap: () async {
                  // Response response = await http.get("api/getFriends");
                  // print(response.statusCode);
                  // print(response.body);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (builder) => Friends(
                        friends: applicationBloc.user['friends'],
                        userName: widget.data['userName'],
                        socket: widget.socket
                      )
                    )
                  );
                },
                child: ListTile(
                  title: Text(
                    'Your Friends',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[900],
                      //fontFamily: 'Lobster'
                    ),
                  ),
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
              decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide.merge(new BorderSide(), new BorderSide()),
                    bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
                  )
              ),
              child: InkWell(
                onTap: () async {
                  Response response = await http.get("api/getRequests");
                  print(response.statusCode);
                  Map<String, dynamic> map = json.decode(response.body);
                  List<dynamic> requests = map['requests'];
                  List<dynamic> sent = map['sent'];
                  Navigator.push(context, MaterialPageRoute(
                    builder: (builder) => Requests(
                      requests: requests,
                      sent: sent,
                      socket: widget.socket,
                    )
                  ));
                },
                child: ListTile(
                  title: Text(
                    'Requests',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[900],
                      //fontFamily: 'Lobster'
                    ),
                  ),
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
              decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide.merge(new BorderSide(), new BorderSide()),
                    bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
                  )
              ),
              child: InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (builder) => Notifications()
                  ));
                },
                child: ListTile(
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[900],
                      //fontFamily: 'Lobster'
                    ),
                  ),
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.all(1.0),
      padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
      decoration: BoxDecoration(
      border: Border(
      //top: BorderSide.merge(new BorderSide(), new BorderSide()),
      bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
      )
      ),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (builder) => RSVPEvents(socket: widget.socket,)
                  ));
                },
                child: ListTile(
                  title: Text(
                    "RSVP'd Events",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[900],
                      //fontFamily: 'Lobster'
                    ),
                  ),
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
              decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide.merge(new BorderSide(), new BorderSide()),
                    bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
                  )
              ),
              child: InkWell(
                onTap: () async {
                  // Response response = await http.get("api/getFriends");
                  // print(response.statusCode);
                  // print(response.body);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (builder) => Blocked(
                          friends: applicationBloc.user['blocked'],
                          userName: widget.data['userName'],
                          socket: widget.socket
                      )
                  )
                  );
                },
                child: ListTile(
                  title: Text(
                    'Blocked Users',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[900],
                      //fontFamily: 'Lobster'
                    ),
                  ),
                ),
              ),
            ),
            Container(
      //margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
      decoration: BoxDecoration(
      border: Border(
      //top: BorderSide.merge(new BorderSide(), new BorderSide()),
      bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
      )
      ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, './settings');
                },
                child: ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue[900],
                        //fontFamily: 'Lobster'
                    ),
                  )
                ),
              ),
            ),
            Container(
              //margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
              decoration: BoxDecoration(
                  border: Border(
                    //top: BorderSide.merge(new BorderSide(), new BorderSide()),
                    bottom: BorderSide.merge(new BorderSide(), new BorderSide()),
                  )
              ),
              child: InkWell(
                onTap: () async {
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // prefs.clear();
                  List<dynamic> chats = applicationBloc.user == null? widget.data['chats'] : applicationBloc.user['chats'];
                  chats.forEach((element) {
                    Map<String, dynamic> logoutData = {
                      "chatId": element['chatId'],
                      "userName": widget.data['userName']
                    };
                    widget.socket.emit("/logOut", logoutData);
                  });
                  //applicationBloc.setUserLogout();
                  widget.socket.disconnect();
                  var response = await http.post('api/logout', applicationBloc.user ?? widget.data);
                  print(json.decode(response.body));
                  applicationBloc.setLogin();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.popAndPushNamed(context, '/frontpage');
                },
                child: ListTile(
                    title: Text(
                      "Log Out",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue[900],
                          //fontFamily: 'Lobster'
                      ),
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
