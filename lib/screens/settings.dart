import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showPassword = false;
  XFile _image;
  ImagePicker _picker = ImagePicker();
  NetworkHandler http = NetworkHandler();
  Map<String, dynamic> user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool validate = true;
  String passwordError = "";

  @override
  Widget build(BuildContext context) {

    var applicationBloc = Provider.of<ApplicationBloc>(context, listen: true);
    user = applicationBloc.user;
    _nameController.text = applicationBloc.user['name'];
    _userNameController.text = applicationBloc.user['userName'];
    _passwordController.text = applicationBloc.user['password'];
    _emailController.text = applicationBloc.user['email'];

    return Scaffold(
      appBar: AppBar(

        title: Text('Settings',
          style: TextStyle(
            color: Colors.blue[600],
          ),
        ),
        backgroundColor: Colors.yellow[300],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 5,
                              color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: http.getImage(applicationBloc.user['profilepic'])
                            ,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 3,
                                color: Theme.of(context).scaffoldBackgroundColor
                            ),
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue[600],
                            onPressed: () async {
                              final XFile image = await _picker.pickImage(source: ImageSource.gallery);
                              //var response = http.getImage("shivam");
                              var stream = await http.uploadImage("api/uploadImage", image.path);
                              print(stream.statusCode);
                              var response = await Response.fromStream(stream);
                              applicationBloc.setProfilePicture(json.decode(response.body)['profilepic']);
                              print(response.body);
                              // setState(() {
                              //   _image = image;
                              // });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                buildTextField(" Name",_nameController,false),
                buildTextField(" Username",_userNameController,false),
                buildTextField(" Email ID",_emailController,false),
                buildTextField(" Password",_passwordController, true),
                //SizedBox(height:5.0),
                // Row(
                //   mainAxisAlignment : MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text("Go Anonymous",
                //       style:TextStyle(
                //         fontSize:16,
                //       ),),
                //     Container(
                //       height:40,
                //       width:80,
                //       child: SliderContainer(),
                //     ),
                //   ],
                // ),
                SizedBox(height:25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    OutlinedButton(
                      style:OutlinedButton.styleFrom(
                        //backgroundColor: Colors.yellow[300],
                        padding : EdgeInsets.symmetric(horizontal:50),
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                      ),
                      //  padding : EdgeInsets.symmetric(horizontal:50),
                      // shape:RoundedRectangleBorder(),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child : Text(
                        "Cancel",
                        style : TextStyle(
                            fontSize : 16.0,
                            letterSpacing: 2.0,
                            color:Colors.black
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style:ElevatedButton.styleFrom(
                        primary : Colors.yellow[300],
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                        padding : EdgeInsets.symmetric(horizontal:50),
                      ),
                      //  padding : EdgeInsets.symmetric(horizontal:50),
                      // shape:RoundedRectangleBorder(),
                      onPressed: () async {
                        String value = _passwordController.text;
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

                        Map<String, dynamic> data = {
                          "userName" : _userNameController.text,
                          "email": _emailController.text
                        };
                        Response response = await http.post("api/checkUser", data);
                        if (response.statusCode == 400) {
                          setState(() {
                            validate = false;
                            passwordError = "email address already belongs to a registered user";
                          });
                        } else if (response.statusCode == 401) {
                          setState(() {
                            validate = false;
                            passwordError = "username already belongs to a registered user";
                          });
                        }
                        if (validate) {
                          user['name'] = _nameController.text;
                          user['userName'] = _userNameController.text;
                          user['email'] = _emailController.text;
                          user['password'] = _passwordController.text;
                          applicationBloc.setUser(user);
                        }
                      },
                      child : Text(
                        "Save",
                        style : TextStyle(
                            fontSize : 16.0,
                            letterSpacing: 2.0,
                            color:Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
                !validate ? Center(
                  child: Container(
                    child: Text(
                      passwordError,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red
                      ),
                    ),
                  ),
                ) : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController _controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom:30),
      child: TextFormField(
        onFieldSubmitted: (text) {
          validate = true;
          passwordError = "";
        },
        controller: _controller,
        obscureText : isPassword ? showPassword : false,
        decoration:InputDecoration(
          suffixIcon : isPassword ? IconButton(
            onPressed :(){
              setState((){
                showPassword = !showPassword;
              });
            },
            icon: showPassword ? Icon(Icons.visibility_off, color:Colors.black26,)
                : Icon(Icons.remove_red_eye, color:Colors.black26,),
          )
              : null,
          contentPadding : EdgeInsets.only(bottom:3),
          labelText : labelText,
          //floatingLabelBehavior : FloatingLabelBehavior.always,
          //hintText: placeholder,
          // hintStyle: TextStyle(
          //   color : Colors.black,
          //   fontSize: 18,
          // ),
        ),
      ),
    );
  }
}

class SliderContainer extends StatefulWidget {
  const SliderContainer({Key key}) : super(key: key);

  @override
  _SliderContainerState createState() => _SliderContainerState();
}

class _SliderContainerState extends State<SliderContainer> {
  static double _lowerValue = 0.0;
  static double _upperValue = 1.0;
  double anonymous = 0.0;

  RangeValues values = RangeValues(_lowerValue ,_upperValue );

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight:10,

      ),
      child: Slider(
        //label:anonymous.abs().toString(),
        //divisions:1,
        min: _lowerValue,
        max: _upperValue,
        value: anonymous,
        onChanged:(val)
        {
          setState(() {
            anonymous = val;
          });
        },

      ),
    );
  }
}