

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grup/db/datasource.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/profile_page.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ApplicationBloc with ChangeNotifier {

  Map<String, dynamic> selectedLocation;
  ProfilePage _profilePage = ProfilePage();
  bool isLogin = false;
  Map<String, dynamic> user;
  NetworkHandler http = NetworkHandler();
  Map<String, dynamic> broadcastLocation;

  resumeUserLocation() {
    selectedLocation = {
      'latitude': user['location']['Latitude'],
      'longitude': user['location']['Longitude']
    };
    notifyListeners();
  }

  setUserLocation(dynamic data) {
    selectedLocation = {
      'latitude' : data.latitude,
      'longitude' : data.longitude
    };
    print(selectedLocation);
    notifyListeners();
  }

  setSelectedLocation(dynamic data) {
    selectedLocation = {
      'latitude' : data['lat'],
      'longitude' : data['lng']
    };
    print(selectedLocation);
    notifyListeners();
  }

  setLogin() {
    isLogin = !isLogin;
    notifyListeners();
  }

  setUser(Map<String, dynamic> data) {
    print("inside application bloc");
    //user = data["queryUser"][0];
    user = data;
    if (user['location'] != null) {
      selectedLocation = {
        'latitude': user['location']['Latitude'],
        'longitude': user['location']['Longitude']
      };
    }
    notifyListeners();
    http.post('api/setUser', data);
    //print(user);
  }

  setId(dynamic data) {
    if (user['userName'] == data["data"]['chatName']) {
      data['data']['chatName'] = data['data']['sender'];
    }
    dynamic chat = user['chats'].firstWhere((elem) => elem['name'] == data["data"]['chatName'], orElse: () => null);
    chat['members'][data['data']['sender']] = data['socketId'];
    String sender = data['data']['sender'];
    //print(chat['members'][sender]);
    //print(data['data']['sender']);
    //print(data['socketId']);
    notifyListeners();
    //print(user);
    //print(chat);
    //print("inside setId");
    //print(data);
  }

  addId(dynamic data) {
    print("add Ids");
    print(data);
    List<dynamic> chats = user['chats'];
    for (int i = 0; i < chats.length; i++) {
      if (chats[i]['chatId'] == data['chatId']) {
        chats[i]['members'][data['name']] = data['socketId'];
      }
    }
    //dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == data['chatId'], oeElse: () => null);
    //chat['members'][data['name']] = data['socketId'];
    print("problem");
    notifyListeners();
  }

  setIds(dynamic data) {
    print("inside setIds");
    print(user);
    print(user["chats"]);
    dynamic chat = user['chats'].firstWhere((elem) => elem['name'] == data['chatName'], orElse: () => null);
    chat['members'] = data['socketIds'];
    print("problem");
    notifyListeners();
    print(chat);
  }

  setNull(dynamic data) {
    print(data);
    dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == data['chatId'], orElse: () => null);
    chat['members'][data['userName']] = null;
    notifyListeners();
  }

  setCounter(dynamic data) {
    print("inside set counter");
    //print(data);
    dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == data['chatId'], orElse: () => null);
    chat['count'] = chat['count'] + 1;
    user['count'] = user['count'] + 1;
    notifyListeners();
  }

  updateUserData(Map<String, dynamic> data) {
    user = data;
    notifyListeners();
  }

  decreaseCounters(String chatId) {
    print("inside decrease counter");
    dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == chatId, orElse: () => null);
    user['count'] = 0;
    chat['count'] = 0;
    notifyListeners();
    http.post('api/updateCounter', user);
  }

  addTags(String tag) async {
    user['tags'].add(tag);
    print("************************************");
    print("************************************");
    print("************************************");
    print("************************************");
    print(user);
    await http.post("api/addTags", user);
    notifyListeners();
  }

  updateUser(dynamic data) {
    user['count'] = data['count'];
    user['chats'] = data['chats'];
    notifyListeners();
  }

  setBroadcastLocation(dynamic data) {
    broadcastLocation = {
      'latitude' : data.latitude,
      'longitude' : data.longitude
    };
    print(selectedLocation);
    notifyListeners();
  }

  updateBroadcastLocation(dynamic data) {
    broadcastLocation = {
      'latitude' : data['lat'],
      'longitude' : data['lng']
    };
    print(selectedLocation);
    notifyListeners();
  }

  clearUnread(dynamic data) {
    dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == data['chatId'] );
    chat['unread'].clear();
    notifyListeners();
  }
  // setUserLogout() {
  //
  // }

  setProfilePicture(String url) {
    print(url);
    user['profilepic'] = url;
    print(user['profilepic']);
    notifyListeners();
  }

  addFriend(dynamic data) {
    user['friends'].insert(0, data);
    notifyListeners();
  }

  removeFriendAndBlock(dynamic data, Socket socket) {
    user['friends'].remove(data);
    user['blocked'].insert(0, data);
    dynamic chat = user['chats'].firstWhere((elem) => elem['name'] == data);
    Map<String, dynamic> map = {
      "userName": user['userName'],
      "chatId": chat['chatId']
    };
    socket.emit("leave", map);
    user['chats'].remove(chat);
    notifyListeners();
  }

  removeFriendAndChat(dynamic data, Socket socket) {
    dynamic chat = user['chats'].firstWhere((elem) => elem['name'] == data);
    user['chats'].remove(chat);
    user['friends'].remove(data);
    notifyListeners();
  }

  removeChat(dynamic data) {
    dynamic chat = user['chats'].firstWhere((elem) => elem['name'] == data);
    user['chats'].remove(chat);
    notifyListeners();
  }

  removeBlocked(dynamic data) {
    user['blocked'].remove(data);
    notifyListeners();
  }

}