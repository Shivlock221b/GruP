import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/services/searchTags.dart';
import 'package:http/http.dart';

import '../tags.dart';

class CustomTag extends StatefulWidget {
  CustomTag({Key key, this.tags}) : super(key: key);
  List<dynamic> tags;
  @override
  _CustomTagState createState() => _CustomTagState();
}

class _CustomTagState extends State<CustomTag> {
  var _tagsController = TextEditingController();
  List<String> tags = [];
  TextEditingController _message = TextEditingController();
  NetworkHandler http = NetworkHandler();
  TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Tag"
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintText: 'Enter the new Tag name'
              ),
              // onChanged: (text) {
              //   this.text = text;
              // },
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
                        ),
                      subtitle: Text(
                        "Add similar tags to popularise the tag to the right people"
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: tags.map((x) => InkWell(
                          onTap: () {
                            setState(() {
                              tags.remove(x);
                            });
                          },
                          child: Tag(text: x))).toList(),
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
                          onPressed: () async {
                          //   setState(() {
                          //     tags.add(_tagsController.text);
                          //   });
                          //   _tagsController.clear();
                            dynamic data = await showGeneralDialog(
                                context: context,
                                barrierLabel: 'Label',
                                barrierColor: Colors.black.withOpacity(0.5),
                                barrierDismissible: true,
                                transitionDuration: Duration(milliseconds: 200),
                                transitionBuilder: (context, anim1, anim2, child) {
                                  return SlideTransition(
                                    position: Tween(begin: Offset(0,1), end: Offset(0,0)).animate(anim1),
                                    child: child,
                                  );
                                },
                                pageBuilder: (context, animation1, animation2) {
                                  return SearchTags(
                                    tags: widget.tags,
                                    createTag: true,
                                  );
                                }
                            );
                            if (data != null) {
                              setState(() {
                                tags.add(data);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    TextFormField(
                      maxLength: 140,
                      controller: _message,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          hintText: 'Optional: Small message for the tag'
                      ),
                      // onChanged: (text) {
                      //   this.text = text;
                      // },
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Map<String, dynamic> data = {
                              "name": _name.text,
                              "tags": tags,
                              "userTags": widget.tags,
                              "message": _message.text
                            };
                            Response response = await http.post("api/createTag", data);
                            final snackBar = SnackBar(
                              content: Text(json.decode(response.body)['message']),
                              action: SnackBarAction(
                                label: "OK",
                                onPressed: () {
                                  Navigator.pop(context, _name.text);
                                  //Navigator.pushReplacementNamed(context, '/login');
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[300],
                            onPrimary: Colors.blue,
                            padding: EdgeInsets.all(8.0),
                          ),
                          icon: Icon(
                              Icons.save_alt
                          ),
                          label: Text(
                              "Create"
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}