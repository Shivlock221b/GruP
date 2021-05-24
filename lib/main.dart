import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grup/profile_page.dart';
import 'package:grup/navdrawer.dart';
import 'package:grup/screens/broadcast_creation.dart';
import 'package:grup/screens/broadscasts.dart';
import 'package:grup/screens/frontpage.dart';
import 'package:grup/screens/login.dart';
import 'package:grup/screens/signup.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: FrontPage(),
      routes: {
        '/signup' : (context) => SignUp(),
        '/login' : (context) => Login(),
        '/localBroadcasts' : (context) => BroadCasts(),
        '/createBroadcast' : (context) => BroadcastCreation(),
        '/profilePage' : (context) => ProfilePage(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context);
  }
}

