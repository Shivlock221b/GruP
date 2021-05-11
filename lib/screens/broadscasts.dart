import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grup/services/broadcast.dart';

class BroadCasts extends StatefulWidget {

  //List<Location> list = [];

  @override
  _BroadCastsState createState() => _BroadCastsState();
}

class _BroadCastsState extends State<BroadCasts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue[600],
        ),
        backgroundColor: Colors.yellow[300],
        centerTitle: true,
        title: Text(
          "Broadcasts",
          style: TextStyle(
            color: Colors.blue[600],
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.location_searching
              ),
              onPressed: () {})
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset(
                  'assets/singapore.jpg',
                fit: BoxFit.cover,
              ),
            ),
            BroadCast(text1: 'Chuan Hao', text2: "Wanna meet up, going for lunch at the deck?? !!",),
            BroadCast(text1: 'Aditi Chadha', text2: "Ordering lunch from Al Amaan, anyone wanna join",),
            BroadCast(text1: 'Shivam Tiwari', text2: "Guys, CS2100 query??? Anyone can help"),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          child: Icon(Icons.bolt),
          backgroundColor: Colors.yellow[600],
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/createBroadcast');
          },
        ),
      ),
    );
  }
}
