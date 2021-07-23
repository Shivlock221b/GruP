import 'package:flutter/material.dart';
import 'package:grup/screens/theirTags.dart' ;
import 'package:grup/screens/theirBroadcasts.dart' ;
import 'package:grup/screens/theirMutualGroups.dart';


class Tabs extends StatefulWidget {
  const Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  //TabController controller;
  @override
  // void initState()
  // {
  //   controller = TabController(length:3,vsync:this, initialIndex:0);
  //   super.initState();
  // }
  // @override
  // void dispose()
  // {
  //   controller.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.yellow[300],
          bottom:TabBar(
          //controller : controller,
            indicatorColor:Colors.black,
            tabs : <Widget>[
            Tab(
            child: Text("Tags",
            textAlign: TextAlign.center,
            style:TextStyle(color:Colors.black,
                fontSize: 16
            ),
          ),
        ),
          Tab(
          child: Text("Broadcasts",
          textAlign: TextAlign.center,
          style:TextStyle(color:Colors.black,
           fontSize: 16),
          ),
          ),
          Tab(
           child: Text("Mutual Groups",
          textAlign: TextAlign.center,
          style:TextStyle(color:Colors.black,
          fontSize: 16),
          ),
          ),
          ],
          ),
        ),
        body : Container(
          child: TabBarView(
          //controller:controller,
          children:<Widget>[
              TheirTags(),
              TheirBroadcasts(),
              TheirMutualGroups()
            // Text("First Screen"),
            // Text("Second Screen"),
            // Text("Third Screen")
          ],
        ),
        ),

      ),
    );//Container
  }//widget build
}//class
