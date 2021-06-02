import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({Key key, this.isSender, this.message}) : super(key: key);
  final bool isSender;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 50
        ),
        child: Card(
          color: isSender? Colors.blue[500] : Colors.yellow[300],
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isSender? Colors.white : Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }
}
