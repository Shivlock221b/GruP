import 'dart:convert';
import 'dart:ui';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/services/customLocation.dart';
import 'package:grup/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:grup/networkHandler.dart';
import 'package:provider/provider.dart';

class EventCreation extends StatefulWidget {
  @override
  _EventCreationState createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  String text = "";
  bool tick = false;
  List<String> tags = [];
  TextEditingController _controller = TextEditingController();
  TextEditingController _tagsController = TextEditingController();
  bool _serviceEnabled;
  loc.Location _location = loc.Location();
  loc.PermissionStatus _permissionStatus;
  loc.LocationData _locationData;
  List<Placemark> list;
  NetworkHandler http = NetworkHandler();
  DateTime _dateTime;
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 0);
  TextEditingController _dateController = TextEditingController();
  dynamic Latitude;
  dynamic Longitude;
  dynamic address;
  String selectedAddress = "";
  @override
  Widget build(BuildContext context) {

    var applicationBloc = Provider.of<ApplicationBloc>(context);
    DateTime picked;
    TimeOfDay timePicked;
    print(_dateTime);
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.blue
        ),
        backgroundColor: Colors.yellow[300],
        title: Text(
          'Create Event',
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
                  "What plan do you have in mind ???",
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
                    controller: _controller,
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
                        children: tags.map((x) => InkWell(
                            onTap: () {
                              setState(() {
                                tags.remove(x);
                              });
                            },
                            child: Tag(text: x))).toList(),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        width: double.infinity,
                        child: TextFormField(
                          controller: _tagsController,
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
                          // onChanged: (text) {
                          //   this.text = text;
                          // },
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
                                tags.add(_tagsController.text);
                              });
                              _tagsController.clear();
                            },
                          ),
                        ),
                      )
                    ],
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
                            "Event Time",
                            style: TextStyle(
                                fontFamily: 'ArchitectsDaughter-Regular.ttf',
                                fontSize: 28
                            ),
                          )
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        width: double.infinity,
                        child: TextFormField(
                          readOnly: true,
                          onTap: () async {
                            _dateController.clear();
                            picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101)
                            );
                            timePicked = await showTimePicker(
                                context: context,
                                initialTime: _time
                            );
                            print("timemmmemememememem");
                            print(timePicked.toString());
                            setState(() {
                              _dateTime = picked;
                              _dateController.text = _dateTime.toString().substring(0, 11);
                              _time = timePicked;
                              _dateController.text = _dateController.text + timePicked.toString().substring(10, 15);
                            });
                          },
                          controller: _dateController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              hintText: 'Choose a Date and Time'
                          ),
                          // onChanged: (text) {
                          //   this.text = text;
                          // },
                        ),
                      ),
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
              SizedBox(height: 10,),
              selectedAddress != "" ? Container(
                //color: Colors.white,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    selectedAddress,
                    style: TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ) : Container(),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: ElevatedButton(
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
                                return CustomLocation(isUserLocation: false);
                              }
                          );
                          Latitude = data["Location"]['lat'];
                          Longitude = data["Location"]['lng'];
                          list = await placemarkFromCoordinates(Latitude, Longitude);
                          address = list[0];
                          setState(() {
                            selectedAddress = data["title"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[500],
                          padding: EdgeInsets.all(8.0),
                        ),
                        child: Text(
                            'Choose Location'
                        )
                    ),
                  ),
                  SizedBox(width: 120,),
                  Container(
                    margin: EdgeInsets.all(0.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          _serviceEnabled = await _location.serviceEnabled();
                          if (!_serviceEnabled) {
                            _serviceEnabled = await _location.requestService();
                            if (!_serviceEnabled) {
                              return;
                            }
                          }
                          _permissionStatus = await _location.hasPermission();
                          if (_permissionStatus == loc.PermissionStatus.denied) {
                            _permissionStatus = await _location.requestPermission();
                            if (_permissionStatus != loc.PermissionStatus.granted) {
                              return;
                            }
                          }
                          _locationData = await _location.getLocation();
                          Latitude = _locationData.latitude;
                          Longitude = _locationData.longitude;
                          list = await placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
                          address = list[0];
                          setState(() {
                            selectedAddress = "Your Location";
                          });
                        },
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
                    onPressed: () async {
                      var utc = DateFormat("yyyy-MM-dd HH:mm");
                      String time = utc.parse(_dateController.text, false).toString();
                      Map<String, dynamic> data = {
                        'content': _controller.text,
                        'tags': tags,
                        'Latitude': Latitude,
                        'Longitude': Longitude,
                        'address' : address,
                        'day' : _dateTime.day,
                        'month' : _dateTime.month,
                        'year' : _dateTime.year,
                        'hour' : _time.hour,
                        'minute' : _time.minute,
                        "time" : _dateController.text,
                        "utc": time
                      };
                      var response = await http.post('api/createEvent', data);
                      print(json.decode(response.body));
                      tags.clear();
                      _dateController.clear();
                      selectedAddress = "";
                      _tagsController.clear();
                      _controller.clear();
                      final snackBar = SnackBar(
                        content: Text("Broadcast created, press OK to see your broadcasts"),
                        action: SnackBarAction(
                          label: "OK",
                          onPressed: () {
                            Navigator.pop(context);
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
