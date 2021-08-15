import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/networkHandler.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({Key key, this.email}) : super(key: key);
  final String email;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}
class _ResetPasswordState extends State<ResetPassword> {
  bool showPassword = true;
  bool showConfPassword = true;
  TextEditingController _password = TextEditingController();
  TextEditingController _controller = TextEditingController();
  NetworkHandler http = NetworkHandler();
  GlobalKey _globalKey = new GlobalKey<FormState>();
  bool validate = true;
  String error = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Reset password'),
      ),
      body:Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Container(
            child:Column(
              children:[
                SizedBox(height:100),
                // margin: EdgeInsets.symmetric(horizontal: 20),
                // child:
                Neumorphic(
                  child: Column(
                    children:[

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: EdgeInsets.all(8.0),
                        // margin:EdgeInsets.fromLTRB(8, 100, 8, 100),
                        child: Neumorphic(
                          child: Center(
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(10, 1, 0, 1),
                              title: Text(
                                "Enter your new password",
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
                      TextFormField(
                        onTap: () {
                          setState(() {
                            validate = true;
                            error = "";
                          });
                        },
                        controller: _password,
                        obscureText : showPassword,
                        decoration:InputDecoration(
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
                          hintText: "Your unique password",
                          suffixIcon : IconButton(
                            onPressed :(){setState((){showPassword = !showPassword;});
                            },
                            icon: showPassword ? Icon(Icons.visibility_off, color:Colors.black26,)
                                : Icon(Icons.remove_red_eye, color:Colors.black26,),
                          ),

                        ),
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

                      ),

                      // SizedBox(height:30),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: EdgeInsets.all(8.0),
                        // margin:EdgeInsets.fromLTRB(8, 100, 8, 100),
                        child: Neumorphic(
                          child: Center(
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(10, 1, 0, 1),
                              title: Text(
                                "Confirm password",
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
                      TextFormField(

                        obscureText : showConfPassword,
                        controller: _controller,
                        decoration:InputDecoration(
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          hintText: "Your password",
                          suffixIcon : IconButton(
                            onPressed :(){setState((){showConfPassword = !showConfPassword;});
                            },
                            icon: showConfPassword ? Icon(Icons.visibility_off, color:Colors.black26,)
                                : Icon(Icons.remove_red_eye, color:Colors.black26,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:30),
                ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary : Colors.yellow[300],
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                    padding : EdgeInsets.symmetric(horizontal : 50),
                  ),
                  onPressed: () async {
                    String value = _password.text;
                    if (value.length < 8) {
                      setState(() {
                        validate = false;
                        error = "password must be greater than 8";
                      });
                    }
                    else if (!(value.contains('!') || value.contains('@') ||
                        value.contains('#') ||
                        value.contains('%') || value.contains('^') ||
                        value.contains('&') || value.contains('*'))) {
                      setState(() {
                        validate = false;
                        error =
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
                        error = "password must contain number";
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
                        error = "password must contain at least one upper case letter";
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
                        error = "password must contain at least one lower case letter";
                      });
                    }

                    if (value != _controller.text) {
                      setState(() {
                        validate = false;
                        error = "password must match the confirmed password";
                      });
                    }
                     if (validate) {
                       Map<String, dynamic> data = {
                         "email": widget.email,
                         "password": _password.text
                       };
                       Response response = await http.post(
                           "api/user/resetPassword", data);
                       if (response.statusCode == 200 ||
                           response.statusCode == 201) {
                         final snackBar = SnackBar(
                           content: Text(
                               "Password reset, Click 'OK' to login"),
                           action: SnackBarAction(
                             label: "OK",
                             onPressed: () {},
                           ),
                         );
                         ScaffoldMessenger.of(context).showSnackBar(
                             snackBar);
                         Navigator.popUntil(
                             context, ModalRoute.withName('/login'));
                       }
                     }
                  },
                  child : Text(
                    "Submit",
                    style : TextStyle(
                        fontSize : 16.0,
                        letterSpacing: 2.0,
                        color:Colors.black
                    ),
                  ),
                ),
              ],),
          ),
        ),
      ),
    );
  }
}