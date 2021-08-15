import 'package:geocoding/geocoding.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/credentials/secrets.dart' as google;
import 'package:grup/networkHandler.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';

class CustomLocation extends StatefulWidget {
  const CustomLocation({Key key, this.isUserLocation}) : super(key: key);
  final bool isUserLocation;
  @override
  _CustomLocationState createState() => _CustomLocationState();
}

class _CustomLocationState extends State<CustomLocation> {
  //ApplicationBloc _applicationBloc = ApplicationBloc();
  var logger = Logger();
  google.Secrets obj = google.Secrets();
  String kGoogleApiKey;
  Timer timeHandle;
  int calls = 0;
  List<dynamic> searchResults = [];
  NetworkHandler hello = NetworkHandler();

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
      type: MaterialType
          .transparency,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .requestFocus(
              new FocusNode());
        },
        child: Align(
          alignment: Alignment
              .bottomCenter,
          child: Container(
            height: 500,
            margin: EdgeInsets
                .only(
                bottom: 150,
                left: 12,
                right: 12),
            decoration: BoxDecoration(
              color: Colors
                  .white,
              borderRadius: BorderRadius
                  .circular(20),
            ),
            child: Container(
              margin: EdgeInsets
                  .all(5.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blue
                            ),
                            borderRadius: BorderRadius
                                .all(
                                Radius
                                    .circular(
                                    20.0))
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
                        hintText: "Search for a location"
                    ),
                    onChanged: (
                        text) {
                      if (text ==
                          "") {
                        return;
                      }
                      if (timeHandle !=
                          null) {
                        timeHandle
                            .cancel();
                      }
                      timeHandle =
                          Timer(
                              Duration(
                                  milliseconds: 500), () async {
                            print(
                                calls++);
                            String googleKey = obj
                                .googleKey();
                            var googleUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&types=establishment&key=$googleKey';
                            var uri = Uri
                                .parse(
                                googleUrl);
                            var response = await http
                                .get(
                                uri);
                            setState(() {
                              searchResults =
                              json
                                  .decode(
                                  response
                                      .body)['predictions'];
                            });
                            logger
                                .i(
                                searchResults);
                            //print(searchResults);
                          });
                    },
                  ),
                  searchResults
                      .length !=
                      0 ?
                  Container(
                    height: 440,
                    child: ListView
                        .builder(
                      shrinkWrap: true,
                      itemBuilder: (
                          context,
                          index) {
                        return Material(
                          //color: const Color(0xcffFF8906),
                          child: InkWell(
                            onTap: () async {
                                                          //logger.i(applicationBloc.selectedLocation['latitude']);
                              String placeId = searchResults[index]['place_id'];
                              String googleKey = obj.googleKey();
                              var uri = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$googleKey');
                              var response = await http.get(uri);
                              logger.i(json.decode(response.body));
                              dynamic location = json.decode(response.body)['result']['geometry']['location'];
                              if (widget.isUserLocation) {
                                applicationBloc.setSelectedLocation(location);
                                logger.i(applicationBloc
                                    .selectedLocation['latitude']);
                                Map<String, dynamic> data = applicationBloc
                                    .selectedLocation;
                                List<
                                    Placemark> list = await placemarkFromCoordinates(
                                    data['latitude'], data['longitude']);
                                Map<String, dynamic> sendData = {
                                  'Latitude': data['latitude'],
                                  'Longitude': data['longitude'],
                                  'address': list[0]
                                };
                                // var result = await hello.patch(
                                //     "api/updateLocation", sendData);
                                // print(json.decode(result.body));
                              }
                              dynamic locationTitle = searchResults[index]["structured_formatting"]["main_text"];
                              Map<String, dynamic> sendData = {
                                "Location" : location,
                                "title" : locationTitle
                              };
                              Navigator.pop(context, sendData);
                            },
                            child: ListTile(
                              // onTap: () async {
                              //   //logger.i(applicationBloc.selectedLocation['latitude']);
                              //  String placeId = searchResults[index]['place_id'];
                              //  String googleKey = obj.googleKey();
                              //  var uri = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$googleKey');
                              //  var response = await http.get(uri);
                              //  logger.i(json.decode(response.body));
                              //  dynamic location = json.decode(response.body)['result']['geometry']['location'];
                              //  if (widget.isUserLocation) {
                              //    applicationBloc.setSelectedLocation(location);
                              //    logger.i(applicationBloc
                              //        .selectedLocation['latitude']);
                              //    Map<String, dynamic> data = applicationBloc
                              //        .selectedLocation;
                              //    List<
                              //        Placemark> list = await placemarkFromCoordinates(
                              //        data['latitude'], data['longitude']);
                              //    Map<String, dynamic> sendData = {
                              //      'Latitude': data['latitude'],
                              //      'Longitude': data['longitude'],
                              //      'address': list[0]
                              //    };
                              //    var result = await hello.patch(
                              //        "api/updateLocation", sendData);
                              //    print(json.decode(result.body));
                              //  } else {
                              //    applicationBloc.updateBroadcastLocation(location);
                              //  }
                              //  //  print(_applicationBloc.selectedLocation);
                              //  //  logger.i(_applicationBloc.selectedLocation);
                              // },
                              title: Text(
                                searchResults[index]["structured_formatting"]["main_text"],
                              ),
                              subtitle: Text(
                                searchResults[index]["structured_formatting"]["secondary_text"],
                              )
                            ),
                          ),
                        );
                      },
                      itemCount: searchResults
                          .length,
                    ),
                  ) : Container(
                    child: Text(
                      "Search for a location you want to visit",
                      style: TextStyle(
                          fontSize: 10
                      ),),
                  )
                ],
              ),
            ),
          ),
        ),
      )
      ,
    );
  }
}
