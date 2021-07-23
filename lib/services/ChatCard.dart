import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:provider/provider.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({Key key, this.chatName}) : super(key: key);
  final String chatName;

  @override
  Widget build(BuildContext context) {
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    return Neumorphic(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(10)))
      ),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.all(0),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
              ),
            ),
            Text(
              chatName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 10,
                child: Text(
                  applicationBloc.user['count'].toString()
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
