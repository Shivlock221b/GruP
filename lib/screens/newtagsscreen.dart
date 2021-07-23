import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grup/bloc/application_bloc.dart';
import 'package:grup/networkHandler.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<dynamic> tags = [];
  NetworkHandler http = NetworkHandler();

  @override
  void initState() {
    getNewTags().then((tagList) {
      setState(() {
        tags = tagList;
      });
    });
    super.initState();
  }

  Future<List<dynamic>> getNewTags() async {
    Response response = await http.get("api/getNewTags");
    Map<String, dynamic> map = json.decode(response.body);
    print(map['message']);
    return map['newTags'];
  }

  @override
  Widget build(BuildContext context) {
    var applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications"
        ),
      ),
      body: ListView.builder(
        itemCount: tags.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  tags[index]['name']
                ),
                subtitle: Text(
                  tags[index]['message']
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    applicationBloc.addTags(tags[index]['name']);
                    setState(() {
                      tags.remove(tags[index]);
                    });
                  },
                  child: Text(
                    "Add Tag"
                  ),
                ),
              ),
              Divider(height: 5,)
            ],
          );
        },
      )
    );
  }
}
