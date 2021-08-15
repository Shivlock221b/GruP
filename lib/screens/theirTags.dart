// import 'package:flutter/material.dart';
//
// class TheirTags extends StatefulWidget {
//   const TheirTags({Key key, this.tags}) : super(key: key);
//   final List<dynamic> tags;
//   @override
//   TheirTagsState createState() => TheirTagsState();
// }
//
// class TheirTagsState extends State<TheirTags> {
//   // var size = MediaQuery.of(context).size;
//   // itemWidth : size.width / 2;
//   // itemHeight : (size.height - kToolbarHeight - 24) / 2;
//
//   @override
//   Widget build(BuildContext context) {
//     // return Container(
//     //   color: Colors.yellow,
//     // );
//
//     print(widget.tags);
//     return Scaffold(
//       body : GridView.count(
//         crossAxisCount:2,
//           childAspectRatio: (1 / .4),
//         children:List.generate(widget.tags.length,(index)
//         {
//         return Container(
//           padding: const EdgeInsets.all(3.0),
//           height:20,
//           // width:20,
//           child:Card(
//
//           //semanticContainer: true,
//           elevation:10.0,
//           shadowColor: Colors.lightBlueAccent,
//           color: Colors.lightBlueAccent[50],
//           child :Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children:[
//               Flexible(
//                 flex:8,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//           children:[
//                 Text(widget.tags[index].toString(),
//                 //textAlign: TextAlign.left,
//                 softWrap: true,
//                 style:TextStyle(
//                   fontSize:16.0,
//                   color:Colors.black87,
//                   fontFamily:"ArchitectsDaughter-Regular",
//                 )),
//             ],
//                 ),
//               ),
//               Flexible(
//                 flex:2,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children:[
//                     Align(
//                   alignment:Alignment.bottomRight,
//                   child : Text("$index"),
//                 ),
//             ],
//                 ),
//               ),
//             ],
//           ),
//
//         ),
//         );
//         })
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class IconsData {
  IconData icon;
  IconsData(this.icon);
}


class TheirTags extends StatefulWidget {
  const TheirTags({Key key, this.tags}) : super(key: key);
  final List<dynamic> tags;
  @override
  TheirTagsState createState() => TheirTagsState();
}


class TheirTagsState extends State<TheirTags> {

  // int position = 0;
  // int no;
  //  List<int> tagsPopularity = [25,1,2,29,95,67,54,72,0,101,81,201,103,809,742,823,3,287,189,4,53,89,3,4,55,6,70,8,9,101];
  //  int calcIndex(int sub_Numb) {
  //    int index1;
  //    if (sub_Numb <= 25) {
  //      index1 = 0;
  //    }
  //    else if (sub_Numb >= 25 && sub_Numb <= 50) {
  //      index1 = 1;
  //    }
  //    else if (sub_Numb >= 50 && sub_Numb <= 75) {
  //      index1 = 2;
  //    }
  //    else if (sub_Numb >= 75 && sub_Numb <= 100) {
  //      index1 = 3;
  //    }
  //    return index1;
  //  }
  //
  //  List<IconsData> _iconsData = [
  //    IconsData(Icons.workspaces_filled),
  //    IconsData(Icons.auto_awesome),
  //    IconsData(Icons.wb_incandescent_rounded),
  //    IconsData(Icons.local_fire_department),
  //  ];

  // List<Map<Object, IconData>> _categories = [
  //     {
  //       'index': 0,
  //       'icon': Icons.workspaces_filled,
  //     },
  //     {
  //       'index': 1,
  //       'icon': Icons.auto_awesome,
  //     },
  //     {
  //       'index': 2,
  //       'icon': Icons.wb_incandescent_rounded,
  //     },
  //     {
  //       'index': 3,
  //       'icon': Icons.local_fire_department,
  //     },
  //   ];

  @override
  Widget build(BuildContext context) {
    List<dynamic> _list = widget.tags;
    return Scaffold(
      body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (1 / .4),
          children: List.generate(_list.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 20,
                // width:20,
                child: Card(
                  //semanticContainer: true,
                  elevation: 10.0,
                  shadowColor: Colors.lightBlueAccent,
                  color: Colors.lightBlueAccent[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Flexible(
                        flex:8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_list[index]['name'].toString(),
                                //textAlign: TextAlign.left,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                  fontFamily: "Itim",
                                )),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:[
                            Row(
                              children:[
                                Container(
                                  height: 22,
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                    //color: Colors.lightBlueAccent,
                                  ),
                                  child: Row(
                                    children:[
                                      Text(
                                        _list[index]['count'].toString(),
                                        //textDirection: TextDirection.ltr,
                                        //textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: 'Itim',
                                          fontSize: 6,
                                          color: Colors.black,
                                        ),
                                      ),
                                      //),
                                      Container(
                                        //no = tagsPopularity[index],
                                        //position = calcIndex(no),

                                        child: Icon(
                                            Icons.local_fire_department,
                                            // Icons.(_iconsData[no]),
                                            color: Colors.orange,
                                            size: 16
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
      ),
    );
  }
}
