import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/group_profile.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:grup/services/searchTags.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../tags.dart';
import 'DialogBox.dart';
import 'broadcast.dart';

class SearchByTags extends StatefulWidget {
  const SearchByTags({Key key, this.socket}) : super(key: key);
  final Socket socket;

  @override
  _SearchByTagsState createState() => _SearchByTagsState();
}

class _SearchByTagsState extends State<SearchByTags> {

  List<String> tags = [];
  List<dynamic> broadcasts = [];
  TextEditingController _tagsController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  NetworkHandler http = NetworkHandler();
  String dropdownValue = "Broadcasts";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Card(
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
                    trailing: DropdownButton<String>(
                      value: dropdownValue,
                      hint: Text(
                        "Choose Category"
                      ),
                      menuMaxHeight: 200,
                      iconSize: 15,
                      elevation: 16,
                      style: const TextStyle(color: Colors.blueAccent),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (String newValue) async {
                        Map<String, dynamic> data = {
                          "tags": tags
                        };
                        Response response;
                        if (newValue == "Broadcasts") {
                          response = await http.post(
                              'api/getSelectedBroadcasts', data);
                        } else if (newValue == "Events") {
                          response = await http.post("api/getSelectedEvents", data);
                        } else {
                          response = await http.post("api/getSelectedGroups", data);
                        }
                        setState(() {
                          dropdownValue = newValue;
                          broadcasts = json.decode(response.body)['broadcasts'];
                        });
                      },
                      items: <String>["Broadcasts", "Events", "Groups"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
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
                        icon: Icon(Icons.add),
                        onPressed: () async {
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
                                  tags: this.tags,
                                );
                              }
                          );
                            if (data != null && data != "") {
                              tags.add(
                                  data);
                              Map<String, dynamic> map = {
                                "tags" : tags
                              };
                              Response response;
                              if (dropdownValue == "Broadcasts") {
                                response = await http.post(
                                    'api/getSelectedBroadcasts', map);
                              } else if (dropdownValue == "Events") {
                                response = await http.post("api/getSelectedEvents", map);
                              } else {
                                response = await http.post("api/getSelectedGroups", map);
                              }
                              print(response.body);
                              setState(() {
                                broadcasts = json.decode(response.body)['broadcasts'];
                              });
                              //_controller.clear();
                            }
                        },
                        label: Text(
                          "Add Tag",
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: broadcasts.length,
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showGeneralDialog(
                          barrierLabel: "Label",
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 200),
                          context: context,
                          transitionBuilder: (context, anim1, anim2, child) {
                            return SlideTransition(
                              position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation1, animation2) {
                            List<dynamic> tags = broadcasts[index]['tags'];
                            if (dropdownValue == "Broadcasts") {
                              return DialogBox(
                                broadcast: broadcasts[index],
                                isLocalBroadcasts: true,
                                socket: widget.socket,
                              );
                            } else if (dropdownValue == "Events") {
                              return DialogBox(
                                broadcast: broadcasts[index],
                                isLocalEvents: true,
                                socket: widget.socket,
                              );
                            }
                            return GroupProfile(
                              socket: widget.socket,
                              group: broadcasts[index]
                            );
                          }
                      );
                    },
                    child: BroadCast(
                      text1: broadcasts[index]['sender']['userName'],
                      text2: broadcasts[index]['content'],),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
