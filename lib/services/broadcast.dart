import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BroadCast extends StatelessWidget {

  String text1;
  String text2;
  BroadCast({this.text1, this.text2});

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.7812;
    MediaQuery.of(context).removePadding();
    MediaQuery.of(context).removeViewInsets();
    MediaQuery.of(context).removeViewPadding();
    return Card(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  //height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    //color: Colors.blue
                  ),
                  //color: Colors.blue,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          text1,
                          style: TextStyle(
                            //fontFamily: 'Lobster',
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      SizedBox(height: 5,),
                      Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 22,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(6.0)),
                            color: Colors.green[200]
                          ),
                          child: Text(
                            "Broadcast",
                            style: TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 12,
                              color: Colors.blue[900]
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          width: c_width,
                          child: Text(
                          text2,
                          //maxLines: 1,
                          //softWrap: false,
                          textAlign: TextAlign.left,
                          //overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 15,
                              color: Colors.blue[900]
                          ),
                            ),
                        )
                      ],
                        ),
                      // Container(
                      //   width: c_width,
                      //   child: Text(
                      //     "jflasjflasjalsjalja;ljals;dja;lja;lja;ljaslja;lkja;lja;ljaljlaalasdfasfaasdaaasasdadsfa"
                      //   ),
                      // )
                    ],
                  ),
                  ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
