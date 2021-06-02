import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
  String baseUrl = '10.120.8.146:3000';
  //String baseUrl = 'grup-backend.herokuapp.com';
  var logger = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();
  // Map<String, String> data = {
  //   "userName": "Shivlock221b",
  //   "password": "Welcometo321@"
  // };

  // Future get(String url) async {
  //   print("plss");
  //   String token = await storage.read(key: "token");
  //   //url = formater(url);
  //   var uri = Uri.https(baseUrl, 'api/getInfo');
  //   print(token);
  //   var response = await http.get(
  //     uri,
  //     headers: {'Authorization': 'jwt $token'}
  //   );
  //   print(response.statusCode);
  //   logger.i(response.statusCode);
  //   logger.i(response.body);
  //   logger.i(json.decode(response.body));
  //   print(response.statusCode);
  // }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    print("hello");
    print(url);
    print(data);
    //print(await storage.read(key: "token"));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    print(shared);
    String token = await storage.read(key: "token");
    //await storage.write(key: "token", value: token);
    //url = formater(url);
    var uri = Uri.http(baseUrl, url);
    print(uri);
    var response = await http.post(
        uri,
      headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    "Accept": "application/json",
    "Authorization" : "jwt $token"
    },
        body:jsonEncode(<String, dynamic>{
          "data" : data
        })
    );
    logger.i(response.statusCode);
    dynamic res = json.decode(response.body);
    logger.i(res);
    print(res['message']);
    storage.write(key: "token", value: res['token']);
    return response;
  }

  Future<http.Response> patchTags(String url, List<dynamic> data) async {
    print(data.toString());
    var uri = Uri.http(baseUrl, url);
    //print(uri);
    var response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        'Authorization' : "jwt"},
      body: jsonEncode(<String, List<dynamic>>{
        "tags": data
      })
    );
    logger.i(response.statusCode);
    logger.i(json.decode(response.body));
    return response;
  }

  Future<http.Response> getChats(String url, String chatId, String userName) async {
    var uri = Uri.http(baseUrl, url);
    print(await storage.read(key: "token"));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    print(shared);
    String token = await storage.read(key: "token");
    print("jwt $token");
    print(uri);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization" : "jwt $shared"
      },
      body: jsonEncode(<String, String>{
        'chatId' : chatId,
        'userName' : userName
      })
    );
    logger.i(response);
    logger.i(json.decode(response.body));
    return response;
  }

  Future<http.Response> getTextChains(String url, Map<String, dynamic> data) async {
    print("hello");
    print(url);
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    print(shared);
    print(await storage.read(key: "token"));
    String token = await storage.read(key: "token");
    //await storage.write(key: "token", value: token);
    //url = formater(url);
    var uri = Uri.http(baseUrl, url);
    print(uri);
    var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json",
          "Authorization" : "jwt $shared"
        },
        body:jsonEncode(<String, dynamic>{
          "data" : data
        })
    );
    logger.i(response.statusCode);
    dynamic res = json.decode(response.body);
    logger.i(res);
    print(res['message']);
    storage.write(key: "token", value: res['token']);
    return response;
  }
}