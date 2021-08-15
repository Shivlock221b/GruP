import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/services/customTag.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SearchTags extends StatefulWidget {
  SearchTags({Key key, this.tags, this.createTag = false,}) : super(key: key);
  final List<dynamic> tags;
  bool createTag;

  @override
  _SearchTagsState createState() => _SearchTagsState();
}

class _SearchTagsState extends State<SearchTags> {

  Logger logger = Logger();
  Timer timeHandle;
  List<dynamic> searchResults = [];
  NetworkHandler http = NetworkHandler();
  ScrollController _scrollController = ScrollController();
  bool createTag = false;
  TextEditingController _text = TextEditingController();

  var _tagsController = TextEditingController();

  @override
  void initState() {
    createTag = widget.createTag;
    super.initState();
  }

  @override
  void dispose() {
    if (timeHandle != null) {
      timeHandle.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 400,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  TextFormField(
                    controller: _text,
                    decoration: InputDecoration(
                      helperText: "Search for tags to add, this will prompt suggestions",
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      contentPadding: EdgeInsets
                          .symmetric(
                          horizontal: 20.0),
                      hintText: "Enter a String"
                    ),
                    onChanged: (text) {
                      if (text == "") {
                        setState(() {
                          searchResults = [];
                        });
                        return;
                      }
                      if (timeHandle != null) {
                        timeHandle.cancel();
                      }
                      timeHandle = Timer(Duration(milliseconds: 500), () async {
                        Map<String, dynamic> data = {
                          "searchText": text,
                          "tags": widget.tags
                        };
                        Response response = await http.post("api/getFilteredTags", data);
                        print(response.body);
                        setState(() {
                          searchResults = json.decode(response.body)['tags'];
                        });
                      });
                    },
                  ),
                  Container(
                    height: createTag? 320 : 270,
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: searchResults.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, searchResults[index]['name']);
                              },
                              child: ListTile(
                                title: Text(
                                  searchResults[index]["name"],
                                  style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 2.0
                                  ),
                                ),
                                trailing: Text(
                                  searchResults[index]['count'].toString()
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                  !createTag ? TextButton.icon(
                    icon: Icon(Icons.create, color: Colors.blue,),
                    onPressed: () async {
                      String text =  await Navigator.push(context, MaterialPageRoute(
                          builder: (builder) => CustomTag()
                      ));
                      if (text != "" && text != null) {
                        Navigator.pop(context, text);
                      }
                    },
                    label: Text("Create Tag", style: TextStyle(fontSize: 16),),
                  ) : Container()
                ],
              ),
            // ) SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       Container(
            //         color: Colors.blue,
            //         child: Row(
            //           children: [
            //             IconButton(
            //                 onPressed: () {
            //                   setState(() {
            //                     createTag = false;
            //                   });
            //                 },
            //                 icon: Icon(Icons.arrow_back)
            //             ),
            //             Text(
            //               "Create Tag"
            //             ),
            //           ],
            //         ),
            //       ),
            //       TextFormField(
            //         controller: _tagsController,
            //         textAlign: TextAlign.left,
            //         decoration: InputDecoration(
            //             enabledBorder: OutlineInputBorder(
            //                 borderSide: BorderSide(
            //                     color: Colors.blue
            //                 ),
            //                 borderRadius: BorderRadius.all(Radius.circular(20.0))
            //             ),
            //             contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            //             hintText: 'Enter the new Tag name'
            //         ),
            //         // onChanged: (text) {
            //         //   this.text = text;
            //         // },
            //       ),
            //       Neumorphic(
            //         style: NeumorphicStyle(
            //             shadowDarkColor: Colors.black
            //         ),
            //         child: Card(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisSize: MainAxisSize.min,
            //             children: <Widget>[
            //               ListTile(
            //                   title: Text(
            //                     "Tags",
            //                     style: TextStyle(
            //                         fontFamily: 'ArchitectsDaughter-Regular.ttf',
            //                         fontSize: 28
            //                     ),
            //                   )
            //               ),
            //               Wrap(
            //                 crossAxisAlignment: WrapCrossAlignment.start,
            //                 children: tags.map((x) => InkWell(
            //                     onTap: () {
            //                       setState(() {
            //                         tags.remove(x);
            //                       });
            //                     },
            //                     child: Tag(text: x))).toList(),
            //               ),
            //               Container(
            //                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                 width: double.infinity,
            //                 child: TextFormField(
            //                   controller: _tagsController,
            //                   textAlign: TextAlign.left,
            //                   decoration: InputDecoration(
            //                       enabledBorder: OutlineInputBorder(
            //                           borderSide: BorderSide(
            //                               color: Colors.blue
            //                           ),
            //                           borderRadius: BorderRadius.all(Radius.circular(20.0))
            //                       ),
            //                       contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            //                       hintText: 'Enter a Tag name'
            //                   ),
            //                   // onChanged: (text) {
            //                   //   this.text = text;
            //                   // },
            //                 ),
            //               ),
            //               Neumorphic(
            //                 style: NeumorphicStyle(
            //                     color: Colors.white,
            //                     shadowDarkColor: Colors.blue
            //                 ),
            //                 child: Center(
            //                   child: TextButton.icon(
            //                     label: Text(
            //                         "Add Tag"
            //                     ),
            //                     icon: Icon(Icons.add),
            //                     onPressed: () {
            //                       setState(() {
            //                         tags.add(_tagsController.text);
            //                       });
            //                       _tagsController.clear();
            //                     },
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ),
        ),
      ),
    )
    );
  }
}
