import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grup/networkHandler.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Otp extends StatefulWidget {
  const Otp({Key key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();

}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Forgot password'),
      ),
      body:Container(
        child:Column(
          children:[
            SizedBox(height:100),
            // margin: EdgeInsets.symmetric(horizontal: 20),
            // child:
            Neumorphic(
              child : Column(
                children : [
                  Container(
                    padding : EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin : EdgeInsets.all(8.0),
                    // margin:EdgeInsets.fromLTRB(8, 100, 8, 100),
                    child : Neumorphic(
                      child : Center(
                        child : ListTile(
                          contentPadding : EdgeInsets.fromLTRB(10, 1, 0, 1),
                          title : Text(
                            "Enter the OTP received on your registered email address",

                            style: TextStyle(
                              fontSize: 14,
                              //fontFamily: 'Lobster',
                              color: Colors.blue[900],
                              //backgroundColor: Colors.grey[100]
                            ),
                          ),

                          subtitle: Text("Check your spam if you cannot view the mail in your inbox",
                            style: TextStyle(
                              fontSize: 10,
                              //fontFamily: 'Lobster',
                              color: Colors.blueGrey,
                              //backgroundColor: Colors.grey[100]
                            ),),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      textAlign:TextAlign.center,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
                        hintText: "Enter the OTP",
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
              onPressed: (){},
              child : Text(
                "Submit",
                style : TextStyle(
                    fontSize : 16.0,
                    letterSpacing: 2.0,
                    color:Colors.black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}