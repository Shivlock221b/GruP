import 'package:flutter/material.dart';

class TheirBroadcasts extends StatefulWidget {
  const TheirBroadcasts({Key key, this.broadcasts}) : super(key: key);
  final List<dynamic> broadcasts;

  @override
  TheirBroadcastsState createState() => TheirBroadcastsState();
}

class TheirBroadcastsState extends State<TheirBroadcasts> {
  @override
  Widget build(BuildContext context) {
    print(widget.broadcasts);
    return Container(
      color: Colors.blue,
    );
  }
}
