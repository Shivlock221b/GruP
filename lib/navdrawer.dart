import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage(
                  'assets/newDrawer.jpg'
                ),
                fit: BoxFit.fill
              )
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
                    fontFamily: 'Lobster',
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
            child: ListTile(
              title: Text(
                'Your Broadcasts',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[900],
                  fontFamily: 'Lobster'
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
            child: ListTile(
              title: Text(
                'Your Groups',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  color: Colors.blue[900],
                  fontSize: 20
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
            child: ListTile(
              title: Text(
                'Your Events',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[900],
                  fontFamily: 'Lobster'
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
            child: ListTile(
              title: Text(
                'Saved Places',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue[900],
                    fontFamily: 'Lobster'
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
            child: ListTile(
              title: Text(
                "Settings",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue[900],
                    fontFamily: 'Lobster'
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}
