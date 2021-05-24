import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class NetworkHandler {
  String baseUrl = '10.120.8.146:3000';
  var logger = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();
  // Map<String, String> data = {
  //   "userName": "Shivlock221b",
  //   "password": "Welcometo321@"
  // };

  Future get(String url) async {
    print("plss");
    String token = await storage.read(key: "token");
    //url = formater(url);
    var uri = Uri.http(baseUrl, 'api/getInfo');
    print(token);
    var response = await http.get(
      uri,
      headers: {'Authorization': 'jwt $token'}
    );
    print(response.statusCode);
    logger.i(response.statusCode);
    logger.i(response.body);
    logger.i(json.decode(response.body));
    print(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    print("hello");
    print(url);
    String token = await storage.read(key: "token");
    //url = formater(url);
    var uri = Uri.http(baseUrl, url);
    print(uri);
    var response = await http.post(
        uri,
      body:data,
      headers: {'Authorization': "jwt $token"}
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
}