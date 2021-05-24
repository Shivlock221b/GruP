import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Tag extends StatelessWidget {

  String text = "";
  Tag({this.text});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(0.0),
      drawSurfaceAboveChild: false,
      style: NeumorphicStyle(
        depth: 5,
        intensity: 0.8,
        shape: NeumorphicShape.convex,
        border: NeumorphicBorder.none(),
        lightSource: LightSource.bottom,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(20.0))),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(5.0, 2.0, 0.0, 2.0),
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
            //fontFamily: 'Lobster',
          ),
        ),
      ),
    );
  }
}
