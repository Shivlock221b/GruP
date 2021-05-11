import 'package:flutter/material.dart';

class BroadcastCreation extends StatelessWidget {
  const BroadcastCreation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create Broadcast',
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(4.0),
            child: TextFormField(
              //enabled: false,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                hintText: "Hey there guys, How's life !!!!",
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[500],
                      padding: EdgeInsets.all(8.0),
                    ),
                    child: Text(
                      'Choose Location'
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[500],
                      padding: EdgeInsets.all(8.0),
                    ),
                    child: Text(
                        'Pick my location'
                    )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
