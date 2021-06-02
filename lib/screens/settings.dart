import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
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
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
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
                          image: AssetImage('assets/photo.jpg'),
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
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildTextField(" Name"," Shivam Tiwari",false),
              buildTextField(" Username"," Shivlock221b",false),
              buildTextField(" Email ID"," shivam.desire@gmail.com",false),
              buildTextField(" Password"," ********", true),
              //SizedBox(height:5.0),
              Row(
                mainAxisAlignment : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Go Anonymous",
                    style:TextStyle(
                      fontSize:16,
                    ),),
                  Container(
                    height:40,
                    width:80,
                    child: SliderContainer(),
                  ),
                ],
              ),
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
                    onPressed: (){},
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
                    onPressed: (){},
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom:30),
      child: TextField(
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
          floatingLabelBehavior : FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            color : Colors.black,
            fontSize: 18,
          ),
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