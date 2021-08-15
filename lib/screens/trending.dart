import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/services/search_by_name.dart';
import 'package:grup/services/search_by_tags.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Explore extends StatefulWidget {
  const Explore({Key key,this.socket, this.user}) : super(key: key);
  final Socket socket;
  final Map<String, dynamic> user;
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  List<dynamic> tags = [];
  NetworkHandler http = NetworkHandler();

  void initState() {
    getBroadcasts().then((broadcastList) {
      print(broadcastList);
      setState(() {
        tags = broadcastList;
      });
    });
    //getBroadcasts();
    super.initState();

  }

  Future<List<dynamic>> getBroadcasts() async {
    var response = await http.get('api/getAllTags');
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data['tags'];
  }


  @override
  Widget build(BuildContext context) {

    var applicationBloc = Provider.of<ApplicationBloc>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Explore"
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text("Trending",
                    textAlign: TextAlign.center,
                    style:TextStyle(color:Colors.white,
                        fontSize: 16
                    ),
                  ),
                ),
                Tab(
                  child: Text("Search by Tags",
                    textAlign: TextAlign.center,
                    style:TextStyle(color:Colors.white,
                        fontSize: 16
                    ),
                  ),
                ),
                Tab(
                  child: Text("Search by Name",
                    textAlign: TextAlign.center,
                    style:TextStyle(color:Colors.white,
                        fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (1 / .4),
                  children: List.generate(tags.length, (index) {
                    return InkWell(
                      onTap: () {
                        Map<String, dynamic> user = applicationBloc.user;
                        print(applicationBloc.user);
                        if (!(user['tags'].contains(tags[index]['name']))) {
                          user['tags'].add(tags[index]['name']);
                          applicationBloc.setUser(user);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
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
                                    Text(tags[index]['name'].toString(),
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
                                                tags[index]['count'].toString(),
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
              SearchByTags(socket: widget.socket,),
              SearchByName(user: widget.user, socket: widget.socket,)
            ],
          ),
          )
      ),
    );
  }
}
