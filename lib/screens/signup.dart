import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/tags.dart';
import 'package:grup/networkHandler.dart';

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
  bool validate = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300],
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
                        hintText: "Shivam Tiwari",
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
                        hintText: "Shivlock221b",
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
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Neumorphic(
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        errorText: validate ? null : error,
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
                        hintText: "shivam.desire1@gmail.com",
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
                          "Phone Number",
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: Colors.blue
                            )
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        hintText: "9120 3839",
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
                        hintText: "Welcometo321@",
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
                      validator: (value) {
                        if (_password.text == value) {
                          return null;
                        }
                        return "pass didn't match";
                      },
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
                        hintText: "Welcometo321@",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  //margin: EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "TAGS",
                          style: TextStyle(
                            fontSize: 20,
                            //fontFamily: 'Lobster',
                            color: Colors.blue[900],
                            //backgroundColor: Colors.grey[100]
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: tags.map((x) => Tag(text: x)).toList()
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(8.0),
                                width: 50,
                                child: Neumorphic(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 0 , 20.0 ,0),
                                        hintText: 'Enter a Tag name'
                                    ),
                                    onChanged: (text) {
                                      this.text = text;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            TextButton.icon(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  tags.add(this.text);
                                });
                              },
                              label: Text(
                                "Add Tag",
                              ),
                            ),
                            SizedBox(width: 80)
                          ]
                      )
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print(tags.toString());
                      Map<String, dynamic> data = {
                        'name' : _name.text,
                        'userName' : _userName.text,
                        'email': _email.text,
                        'password' : _password.text,
                      };
                      print(data);
                      var response = await http.post('api/user/signup', data);
                      if (response.statusCode == 201 || response.statusCode == 200) {
                        await http.patchTags('api/updateUser', tags);
                        Map<String, dynamic> details = json.decode(response.body);
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        Map<String, dynamic> details = json.decode(response.body);
                        setState(() {
                          validate = false;
                          error = details["message"];
                        });
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
      )
    );
  }
}

