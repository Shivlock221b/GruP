import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grup/db/datasource.dart';
import 'package:grup/db/db.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class NetworkHandler {
  //String baseUrl = '10.120.8.146:3000';
  // String baseUrl = "172.31.75.147:3000";
  String baseUrl = "172.31.75.128:3000";
  //String baseUrl = 'grup-backend.herokuapp.com';
  var logger = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();
  static Database _db;
  static DataSource _dataSource;
  DataSource get dataSource => _dataSource;
  // Map<String, String> data = {
  //   "userName": "Shivlock221b",
  //   "password": "Welcometo321@"
  // };


  static configure() async {
    _db = await LocalDatabaseFactory().createDatabase();
    _dataSource = DataSource(_db);
  }


  Future<http.Response> get(String url) async {
    print("plss");
    //String token = await storage.read(key: "token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    //url = formater(url);
    var uri = Uri.http(baseUrl, url);
    //print(token);
    Response response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        'Authorization': 'jwt $shared'
      }
    );
    print(response.statusCode);
    logger.i(response.statusCode);
    logger.i(response.body);
    //logger.i(json.decode(response.body));
    print(response.statusCode);
    return response;
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    print("hello");
    print(url);
    print(data);
    //print(await storage.read(key: "token"));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    print(shared);
    //String token = await storage.read(key: "token");
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
    //dynamic res = json.decode(response.body);
    //logger.i(res);
    //print(res['message']);
    //storage.write(key: "token", value: res['token']);
    return response;
  }

  Future<http.Response> patch(String url, Map<String, dynamic> data) async {
    print(data.toString());
    var uri = Uri.http(baseUrl, url);
    //print(uri);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    var response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        'Authorization' : "jwt $shared"},
      body: jsonEncode(<String, Map<String, dynamic>>{
        "data": data
      })
    );
    logger.i(response.statusCode);
    //logger.i(json.decode(response.body));
    return response;
  }

  Future<http.Response> getChats(String url, String chatId,  bool isGroup) async {
    var uri = Uri.http(baseUrl, url);
    print(await storage.read(key: "token"));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    print(shared);
    //String token = await storage.read(key: "token");
    //print("jwt $token");
    print(uri);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization" : "jwt $shared"
      },
      body: jsonEncode(<String, dynamic>{
        'chatId' : chatId,
        "isGroup" : isGroup
      })
    );
    logger.i(response.body);
    //logger.i(json.decode(response.body));
    return response;
  }

  Future<http.Response> getTextChains(String url, Map<String, dynamic> data) async {
    print("hello");
    print(url);
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString('token');
    print(shared);
    //print(await storage.read(key: "token"));
    //String token = await storage.read(key: "token");
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
    //dynamic res = json.decode(response.body);
    //logger.i(res);
    //print(res['message']);
    //storage.write(key: "token", value: res['token']);
    return response;
  }

  NetworkImage getImage(String url) {
    print(url);
    var uri = Uri.http(baseUrl, url);
    print(uri.toString());
    return NetworkImage(uri.toString());
  }

  Future<http.StreamedResponse> uploadImage(String url, String filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String shared = prefs.getString("token");
    var uri = Uri.http(baseUrl, url);
    var request = http.MultipartRequest("PATCH", uri);
    request.files.add(await http.MultipartFile.fromPath("profilepic", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "jwt $shared"
    });
    var response = request.send();
    return response;
  }
}