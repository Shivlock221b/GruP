import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/group_profile.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:grup/services/broadcast.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../tags.dart';

class GroupBroadCasts extends StatefulWidget {

  //List<Location> list = [];

  @override
  _GroupBroadCastsState createState() => _GroupBroadCastsState();
}

class _GroupBroadCastsState extends State<GroupBroadCasts> {
  Socket socket;
  NetworkHandler http = NetworkHandler();
  List<dynamic> groups = [];
  ScrollController _scrollController = ScrollController();
  bool ready = false;
  bool clicked = false;
  double _value = 500.0;
  //LocationData _locationData;
  Map<String, dynamic> _locationData;
  @override
  void initState() {
    getGroups().then((groupList) {
      print(groupList);
      setState(() {
        groups = groupList;
        ready = true;
      });
    });
    //getBroadcasts();
    super.initState();

  }

  Future<List<dynamic>> getGroups() async {
    var response = await http.get('api/getGroups');
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data['groups'];
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    _locationData = applicationBloc.selectedLocation;
    socket = data['socket'];


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.yellow[300],
          centerTitle: true,
          title: Text(
            "Groups",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                    Icons.location_searching
                ),
                onPressed: () {
                  setState(() {
                    clicked = true;
                  });
                }
            )
          ],
        ),
        backgroundColor: Colors.blue[50],
        body: applicationBloc.user['tags'].length != 0 ? _locationData != null ? ready ? Stack(
          children: [
            // Container(
            //     // child: Image.asset(
            //     //     'assets/singapore.jpg',
            //     //   fit: BoxFit.cover,
            //     // ),
            //   ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: groups.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print(groups[index]['content']);
                    return Geolocator.distanceBetween(
                        groups[index]['location']['Latitude'], groups[index]['location']['Longitude'],
                        _locationData['latitude'], _locationData['longitude']) <= _value ?
                    InkWell(
                      onTap: () async {
                        // Response response = await http.post("api/getGroupProfile", groups[index]);
                        // Map<String, dynamic> map = json.decode(response.body);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (builder) => GroupProfile(
                              socket: this.socket,
                              group: groups[index],
                            )
                        ));
                      },
                      child: BroadCast(
                        text1: groups[index]['name'],
                        text2: groups[index]['content'],),
                    ) : Container();
                  }
              ),
            ),
            clicked ? Positioned(
              top: 40,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.all(Radius.circular(45.0))
                ),
                height: 500,
                width: 100,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SfSlider.vertical(
                        min: 0.0,
                        max: 2000.0,
                        value: _value,
                        interval: 200.0,
                        showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        stepSize: 100,
                        //showDivisors: true,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _value = newValue;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        setState(() {
                          clicked = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ) : Container()
          ],
        ) : Center(child : CircularProgressIndicator())
            : Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/location.jpg'
              ),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 550,),
                Text(
                  "Choose a location to see groups"
                ),
              ],
            ),
          ),
        ) : Center(
          child: Container(
            child: Text(
              "Add Tags to view groups or look for trending tags and Groups in 'Explore' tab",
              style: TextStyle(
                  fontSize: 16
              ),
            ),
          ),
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.bolt),
            backgroundColor: Colors.yellow[600],
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/createBroadcast');
            },
          ),
        ),
      ),
    );
  }
}