import 'dart:ui';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BroadcastCreation extends StatefulWidget {
  @override
  _BroadcastCreationState createState() => _BroadcastCreationState();
}

class _BroadcastCreationState extends State<BroadcastCreation> {
  String text = "";
  bool tick = false;
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue
        ),
        backgroundColor: Colors.yellow[300],
        title: Text(
          'Create Broadcast',
          style: TextStyle(
            color: Colors.blue
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.location_searching_rounded
            ),
            onPressed: () {},
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: NeumorphicText(
                  "What do you want to talk about???",
                  style: NeumorphicStyle(
                    depth: 0,  //customize depth here
                    color: Colors.black, //customize color here
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 22,
                    fontFamily: 'ArchitectsDaughter-Regular.ttf',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(4.0),
                child: Neumorphic(
                  child: TextFormField(
                    //enabled: false,

                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintText: "I had this crazy idea...",
                    ),
                  ),
                ),
              ),
              Neumorphic(
                style: NeumorphicStyle(
                  shadowDarkColor: Colors.black
                ),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Tags",
                          style: TextStyle(
                            fontFamily: 'ArchitectsDaughter-Regular.ttf',
                            fontSize: 28
                          ),
                        )
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: tags.map((x) => Tag(text: x)).toList(),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        width: double.infinity,
                        child: TextField(
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            hintText: 'Enter a Tag name'
                          ),
                          onChanged: (text) {
                            this.text = text;
                          },
                        ),
                      ),
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: Colors.white,
                          shadowDarkColor: Colors.blue
                        ),
                        child: Center(
                          child: TextButton.icon(
                            label: Text(
                              "Add Tag"
                            ),
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                tags.add(this.text);
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Neumorphic(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                style: NeumorphicStyle(
                  color: Colors.blue[200]
                ),
                child: CheckboxListTile(
                  title: Text(
                    'Go Anonymous'
                  ),
                  onChanged: (tick) {
                    setState(() {
                      this.tick = tick;
                    });
                  },
                  value: this.tick,
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
                  SizedBox(width: 130,),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[500],
                          padding: EdgeInsets.all(8.0),
                        ),
                        child: Text(
                            'Use my location'
                        )
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[300],
                        onPrimary: Colors.blue,
                        padding: EdgeInsets.all(8.0),
                      ),
                    icon: Icon(
                      Icons.offline_bolt_sharp
                    ),
                    label: Text(
                      "Broadcast"
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
