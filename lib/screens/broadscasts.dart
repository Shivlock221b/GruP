

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
            //SizedBox(height: 10),
            BroadCast(),
          ],
        ),
      )
    );
  }
}
