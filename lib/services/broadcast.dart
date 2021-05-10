import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BroadCast extends StatelessWidget {

  String text;
  BroadCast({this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              height: 40,
              width: 40,
              color: Colors.blue,
              child: Text(
                "Hi everyone akshflakfklasjf"
              ),
              // child: Text(
              //   "Chuan Hao",
              //   style: TextStyle(
              //     fontFamily: 'Lobster',
              //     fontSize: 20,
              //   ),
              // ),
            ),
          )
        ],
      ),
    );
  }
}
