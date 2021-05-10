import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {

  String text = "";
  Tag({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 2.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.yellow[500],
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Text(
        this.text,
        style: TextStyle(
          color: Colors.blue[900],
          fontFamily: 'Lobster',
        ),
      ),
    );
  }
}
