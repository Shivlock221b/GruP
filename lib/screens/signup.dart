import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grup/screens/otp.dart';
import 'package:grup/services/searchTags.dart';
import 'package:grup/tags.dart';
import 'package:grup/networkHandler.dart';
import 'package:location/location.dart' as loc;

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String text = "";
  List<String> tags = [];
  NetworkHandler http = NetworkHandler();
  GlobalKey _globalKey = new GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool validate = true;
  String error = "";
  String emailError = "";
  String passwordError = "";
  bool showpass = true;
  String tagError = "";
  TextEditingController controller = TextEditingController();
  loc.Location _location = loc.Location();
  bool _serviceEnabled;
  loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "User SignUp",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        body: Form(
          key: _globalKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: EdgeInsets.all(8.0),
                    child: Neumorphic(
                      child: Center(
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(10, 1, 0, 1),
                          title: Text(
                            "Name",
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
                        keyboardType: TextInputType.name,
                        controller: _name,
                        decoration: InputDecoration(
                          //errorText: validate ? null : error,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                  color: Colors.blue
                              )
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          hintText: "Your Name",
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
                        onTap: () {
                          setState(() {
                            validate = true;
                            error = "";
                          });
                        },
                        keyboardType: TextInputType.name,
                        controller: _userName,
                        decoration: InputDecoration(
                          errorText: validate ? null : error,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.0,
                                  color: Colors.white
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                              color: Colors.blue
                            )
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          hintText: "Your Persona",
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
                            "Email",
                            style: TextStyle(
                              fontSize: 20,
                              //fontFamily: 'Lobster',
                              color: Colors.blue[900],
                              //backgroundColor: Colors.grey[100]
                            ),
                          ),
                          subtitle: Text(
                            "Must be a valid email address. Only one account is allowed per email address",
                            style: TextStyle(
                              fontSize: 12
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
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        validator: (value) {
                          if (!value.contains('@')) {
                            return "email must be valid";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorText: validate ? null : emailError,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.0,
                                  color: Colors.white
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                  color: Colors.blue
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          hintText: "your email address",
                        ),
                        onTap: () {
                          setState(() {
                            validate = true;
                            error = "";
                          });
                        },
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
                          subtitle: Text(
                            "Password must contain at least on number and one special character and must be greater than 8 in length",
                            style: TextStyle(
                              fontSize: 12
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Neumorphic(
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            validate = true;
                            passwordError = "";
                          });
                        },
                        keyboardType: TextInputType.visiblePassword,
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
                          errorText: validate ? null : passwordError,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.0,
                                  color: Colors.white
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                  color: Colors.blue
                              )
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          hintText: "Your unique password",
                        ),
                        obscureText: showpass,
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
                            "Confirm Password",
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
                        onTap: () {
                          setState(() {
                            validate = true;
                            passwordError = "";
                          });
                        },
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          // if (_password.text == value) {
                          //   setState(() {
                          //     validate = true;
                          //     passwordError = "confirm password must match the password";
                          //   });
                          // }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(showpass? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                showpass = !showpass;
                              });
                            },
                          ),
                          errorText: validate ? null : passwordError,
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.0,
                                  color: Colors.white
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(
                                  color: Colors.blue
                              )
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          hintText: "Your password",
                        ),
                        obscureText: showpass,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
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
                            subtitle: Text(
                              "Optional: Search for tags from existing list",
                              style: TextStyle(
                                fontSize: 12
                              )
                            ),
                              title: Text(
                                "Tags",
                                style: TextStyle(
                                    fontFamily: 'ArchitectsDaughter-Regular.ttf',
                                    fontSize: 28
                                ),
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
                                          tags: this.tags,createTag: true,
                                        );
                                      }
                                  );
                                  if (data != null && data != "" ) {
                                    setState(() {
                                      validate = true;
                                      tagError = "";
                                      tags.add(
                                          data);
                                      //_controller.clear();
                                    });
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
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        !validate ? Text(
                          error  != "" ?  error : emailError != ""?  emailError :  passwordError != "" ? passwordError : tagError != "" ? tagError : "",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red
                          ),
                        ) : Container(),
                        ElevatedButton(
                          onPressed: () async {
                            String value = _password.text;
                            if (value.length < 8) {
                              setState(() {
                                validate = false;
                                passwordError = "password must be greater than 8";
                              });
                            }
                             else if (!(value.contains('!') || value.contains('@') ||
                                value.contains('#') ||
                                value.contains('%') || value.contains('^') ||
                                value.contains('&') || value.contains('*'))) {
                              setState(() {
                                validate = false;
                                passwordError =
                                "password must contain special characters";
                              });
                            }
                            else if (!(value.contains("0") || value.contains("1") ||
                                value.contains('2') || value.contains('3') ||
                                value.contains('4') || value.contains('5') ||
                                value.contains('6') || value.contains('7') ||
                                value.contains('8') || value.contains('9'))) {
                              setState(() {
                                validate = false;
                                passwordError = "password must contain number";
                              });
                            } else if (!(value.contains("A") || value.contains("B") ||value.contains("C") ||value.contains("D")
                                ||value.contains("E") ||value.contains("F") ||value.contains("I") ||value.contains("J")
                                ||value.contains("K") ||value.contains("L") ||value.contains("M") ||value.contains("N")
                                ||value.contains("O") ||value.contains("P") ||value.contains("Q") ||value.contains("R")
                                ||value.contains("S") ||value.contains("T") ||value.contains("U") ||value.contains("V")
                                ||value.contains("W") ||value.contains("X") ||value.contains("Y") ||value.contains("Z")
                                ||value.contains("G") ||value.contains("H"))) {
                              setState(() {
                                validate = false;
                                passwordError = "password must contain at least one upper case letter";
                              });
                            } else if (!(value.contains("a") || value.contains("b") ||value.contains("c") ||value.contains("d")
                                ||value.contains("e") ||value.contains("f") ||value.contains("i") ||value.contains("j")
                                ||value.contains("k") ||value.contains("l") ||value.contains("m") ||value.contains("n")
                                ||value.contains("o") ||value.contains("p") ||value.contains("q") ||value.contains("r")
                                ||value.contains("s") ||value.contains("t") ||value.contains("u") ||value.contains("v")
                                ||value.contains("w") ||value.contains("x") ||value.contains("y") ||value.contains("z")
                                ||value.contains("g") ||value.contains("h"))) {
                              setState(() {
                                validate = false;
                                passwordError = "password must contain at least one lower case letter";
                              });
                            }

                            value = _email.text;
                            if (!value.contains("@")) {
                              setState(() {
                                validate = false;
                                emailError = "invalid email, must have @";
                              });
                            }

                            if (!(_password.text == _confirmPasswordController.text)) {
                              setState(() {
                                validate = false;
                                passwordError = "confirm password must match the password";
                              });
                            }

                            print(tags.toString());
                            Map<String, dynamic> data = {
                              'name': _name.text,
                              'userName': _userName.text,
                              'email': _email.text,
                              'password': _password.text,
                              'tags': tags
                            };
                            print(data);
                            if (validate == true) {
                              var response = await http.post(
                                  'api/user/activateAccount', data);
                                Map<String, dynamic> details = json.decode(
                                    response.body);
                                bool verify = await Navigator.push(context, MaterialPageRoute(
                                    builder: (builder) => Otp(
                                      otp: details['oneTimePass'].toString(),
                                    )
                                ));
                                if (verify) {
                                var res = await http.post(
                                    'api/user/signup', data);
                              if (res.statusCode == 201 ||
                                  res.statusCode == 200) {
                                final snackBar = SnackBar(
                                  content: Text(
                                      "Account created click 'OK' to login"),
                                  action: SnackBarAction(
                                    label: "OK",
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar);
                              } else if (res.statusCode == 400){
                                Map<String, dynamic> details = json.decode(
                                    res.body);
                                setState(() {
                                  validate = false;
                                  emailError = details["message"];
                                  error = "";
                                });
                              } else if (res.statusCode == 401) {
                                Map<String, dynamic> details = json.decode(
                                    res.body);
                                setState(() {
                                  validate = false;
                                  error = details["message"];
                                  emailError = "";
                                });
                              }
                            } else {
                                  setState(() {
                                    error = "Wrong OTP try again";
                                  });
                                }
                            }
                          },
                          child: Text(
                              "Submit",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

