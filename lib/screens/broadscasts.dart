import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grup/Pages/IndividualChat.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/screens/viewProfile.dart';
import 'package:grup/services/DialogBox.dart';
import 'package:grup/services/broadcast.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../tags.dart';

class BroadCasts extends StatefulWidget {

  //List<Location> list = [];

  @override
  _BroadCastsState createState() => _BroadCastsState();
}

class _BroadCastsState extends State<BroadCasts> {
  Socket socket;
  NetworkHandler http = NetworkHandler();
  List<dynamic> broadcasts = [];
  ScrollController _scrollController = ScrollController();
  bool ready = false;
  bool clicked = false;
  double _value = 500.0;
  Map<String, dynamic> user;
  //LocationData _locationData;
  Map<String, dynamic> _locationData;
  @override
  void initState() {
    getBroadcasts().then((broadcastList) {
      print(broadcastList);
      setState(() {
        broadcasts = broadcastList;
        ready = true;
      });
    });
    //getBroadcasts();
    super.initState();

  }

  Future<List<dynamic>> getBroadcasts() async {
    var response = await http.get('api/getBroadcasts');
    Map<String, dynamic> data = json.decode(response.body);
    print(data['message']);
    return data['broadcasts'];
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    _locationData = applicationBloc.selectedLocation;
    socket = data['socket'];
    user = data['user'];


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.blue[600],
          ),
          backgroundColor: Colors.yellow[300],
          centerTitle: true,
          title: Text(
            "Broadcasts",
            style: TextStyle(
              color: Colors.blue[600],
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
        body: user['tags'].length != 0 ? _locationData != null ? ready ? Stack(
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
                  itemCount: broadcasts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print(broadcasts[index]['content']);
                    return Geolocator.distanceBetween(
                        broadcasts[index]['location']['Latitude'], broadcasts[index]['location']['Longitude'],
                        _locationData['latitude'], _locationData['longitude']) <= _value ?
                    InkWell(
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
                              return DialogBox(
                                broadcast: broadcasts[index],
                                isLocalBroadcasts: true,
                                socket: socket,
                              );
                            }
                        );
                      },
                      child: BroadCast(
                        text1: broadcasts[index]['sender']['userName'],
                        text2: broadcasts[index]['content'],),
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
                    "Choose a location to see broadcasts"
                ),
              ],
            ),
          ),
        ) : Center(
          child: Container(
            child: Text(
              "Add Tags to view broadcasts or look for trending tags and broadcasts in 'Explore' tab",
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
