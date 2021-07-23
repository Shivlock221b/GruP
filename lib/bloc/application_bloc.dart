import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grup/networkHandler.dart';
import 'package:grup/profile_page.dart';

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
    dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == data['chatId'], oeElse: () => null);
    chat['memebers'][data['userName']] = data['socketId'];
    notifyListeners();
  }

  setIds(dynamic data) {
    print("inside setIds");
    print(user);
    print(user["chats"]);
    dynamic chat = user['chats'].firstWhere((elem) => elem['name'] == data['chatName'], orElse: () => null);
    chat['members'] = data['socketIds'];
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

  // setCounterNull(String chatId) {
  //   dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == chatId, orElse: () => null);
  //   chat['count'] = 0;
  //   notifyListeners();
  // }
  //
  // setUserCounter(int count) {
  //   if (user['count'] == null) {
  //     user['count'] = 0;
  //   } else {
  //     user['count'] = user['count'] - count;
  //   }
  //
  //   notifyListeners();
  // }

  decreaseCounters(String chatId) {
    dynamic chat = user['chats'].firstWhere((elem) => elem['chatId'] == chatId, orElse: () => null);
    user['count'] = user['count'] - chat['count'];
    chat['count'] = 0;
    notifyListeners();
    http.post('api/updateCounter', user);
  }

  addTags(String tag) {
    user['tags'].add(tag);
    print("************************************");
    print("************************************");
    print("************************************");
    print("************************************");
    print(user);
    //http.post("api/addTags", )
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
  // setUserLogout() {
  //
  // }

  setProfilePicture(String url) {
    print(url);
    user['profilepic'] = url;
    print(user['profilepic']);
    notifyListeners();
  }

}