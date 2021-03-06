import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grup/profile_page.dart';
import 'package:grup/screens/forgotPassword.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map<String, String> data = {};
  GlobalKey _globalKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  NetworkHandler http = NetworkHandler();
  final storage = FlutterSecureStorage();
  bool validate = false;
  String error = "";
  bool showpass = true;
  bool _serviceEnabled;
  loc.Location _location = loc.Location();
  loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.yellow[300],
        body: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)
                ),
                SizedBox(height: 60,),
                Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue[900]
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.all(8.0),
                  child: Neumorphic(
                    child: Center(
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(10, 1, 0, 1),
                        title: Text(
                          "UserName",
                          style: TextStyle(
                            fontSize: 20,
                            //fontFamily: 'Lobster',
                            color: Colors.blue[900],
                            //backgroundColor: Colors.grey[100]
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Neumorphic(
                    child: TextFormField(
                      controller: _username,
                      decoration: InputDecoration(
                        errorText: validate ? null : error,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.0,
                            color: Colors.white,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0
                          )
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        //     borderSide: BorderSide(
                        //         color: Colors.blue
                        //     )
                        // ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        hintText: "Your Username",
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.all(8.0),
                  child: Neumorphic(
                    child: Center(
                      child: ListTile(
                        title: Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 20,
                            //fontFamily: 'Lobster',
                            color: Colors.blue[900],
                            //backgroundColor: Colors.grey[100]
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Neumorphic(
                    child: TextFormField(
                      validator: (value) {
                        if (value.length < 8) return "password has to greater than 8";
                        if (!(value.contains('!') || value.contains('@') || value.contains('#') ||
                            value.contains('%') || value.contains('^') || value.contains('&') || value.contains('*'))) {
                          return "password must contain special characters";
                        }
                        if (!(value.contains("0") || value.contains("1") || value.contains('2') || value.contains('3') ||
                            value.contains('4') || value.contains('5') || value.contains('6') || value.contains('7') ||
                            value.contains('8') || value.contains('9'))) {
                          return "password must contain number";
                        }
                        return null;
                      },
                      controller: _password,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(showpass? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                              setState(() {
                                showpass = !showpass;
                              });
                          },
                        ),
                        errorText: validate? null : error,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.0,
                            color: Colors.white,
                          )
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0
                            )
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        hintText: "Your Password",
                      ),
                      obscureText: showpass,
                    ),
                  ),
                ),
                Row(

                  mainAxisAlignment:MainAxisAlignment.start,
                  children:[
                    SizedBox(width:18),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (builder) => ForgotPassword()
                        ));
                      },
                      child:Text("Forgot password",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                //SizedBox(height: 40,),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String value = _password.text;
                      if (value.length < 8) {
                        setState(() {
                          validate = false;
                          error = "password must be greater than 8";
                        });
                      };
                      if (!(value.contains('!') || value.contains('@') || value.contains('#') ||
                          value.contains('%') || value.contains('^') || value.contains('&') || value.contains('*'))) {
                       setState(() {
                         validate = false;
                         error = "password must contain special characters";
                       });
                      }
                      if (!(value.contains("0") || value.contains("1") || value.contains('2') || value.contains('3') ||
                          value.contains('4') || value.contains('5') || value.contains('6') || value.contains('7') ||
                          value.contains('8') || value.contains('9'))) {
                        setState(() {
                          validate = false;
                          error = "password must contain number";
                        });
                      }
                      setState(() {
                        data = {
                          'userName' : _username.text,
                          'password' : _password.text
                        };
                      });
                      var response = await http.post('api/user/login', data);
                      //print(response.statusCode);
                      if (response.statusCode == 200 || response.statusCode == 201) {
                        Map<String, dynamic> details = json.decode(response.body);
                        //applicationBloc.setUser(details['queryUser'][0]);
                        await storage.write(key: "token", value: details['token']);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('token', details['token']);
                        Navigator.pop(context);
                        //Navigator.pushReplacementNamed(context, '/profilePage', arguments: json.decode(response.body));
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (builder) => ProfilePage(
                              user: details['queryUser'][0]
                            )
                        ));
                      } else {
                        Map<String, dynamic> details = json.decode(response.body);
                        setState(() {
                          validate = false;
                          error = details["message"];
                        });
                        //applicationBloc.setLogin();
                      }
                    },
                    child: Text(
                        "Submit"
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
