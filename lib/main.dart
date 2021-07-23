import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/profile_page.dart';
import 'package:grup/navdrawer.dart';
import 'package:grup/screens/Event_creation.dart';
import 'package:grup/screens/broadcast_creation.dart';
import 'package:grup/screens/broadscasts.dart';
import 'package:grup/screens/chats.dart';
import 'package:grup/screens/events.dart';
import 'package:grup/screens/frontpage.dart';
import 'package:grup/screens/group_creation.dart';
import 'package:grup/screens/groups.dart';
import 'package:grup/screens/login.dart';
import 'package:grup/screens/settings.dart';
import 'package:grup/screens/signup.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogin = false;
Map<String, dynamic> user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('token')) {
    print(prefs.getString('token'));
    print(isLogin);
    NetworkHandler http = NetworkHandler();
    Response response = await http.get("api/getUser");
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("true");
      isLogin = true;
      user = json.decode(response.body)['user'];
    } else {
      print("false");
      isLogin = false;
    }
  } else {
    isLogin = false;
  }
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: isLogin ? ProfilePage(user: user,) : FrontPage(),
        routes: {
          '/signup' : (context) => SignUp(),
          '/login' : (context) => Login(),
          '/localBroadcasts' : (context) => BroadCasts(),
          '/createBroadcast' : (context) => BroadcastCreation(),
          '/profilePage' : (context) => ProfilePage(),
          './settings' : (context) => Settings(),
          '/frontpage' : (context) => FrontPage(),
          '/createEvent' : (context) => EventCreation(),
          '/createGroup' : (context) => GroupCreation(),
          '/eventBroadcasts' : (context) => EventBroadCasts(),
          '/groupBroadcasts' : (context) => GroupBroadCasts()
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context);
  }
}

