import 'package:flutter/material.dart';
import 'package:grup/services/ChatCard.dart';

class TheirMutualGroups extends StatefulWidget {
  const TheirMutualGroups({Key key, this.mutual}) : super(key: key);
  final List<dynamic> mutual;

  @override
  TheirMutualGroupsState createState() => TheirMutualGroupsState();
}

class TheirMutualGroupsState extends State<TheirMutualGroups> {
  @override
  Widget build(BuildContext context) {
    print(widget.mutual);
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.mutual.length,
          itemBuilder: (context, index) {
            return Card(
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
                    widget.mutual[index]['name'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
