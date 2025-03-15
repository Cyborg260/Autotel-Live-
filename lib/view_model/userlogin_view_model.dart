import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trackerapp/models/user_login_model.dart';

class UserLoginViewModel with ChangeNotifier {
  Future<bool> saveUsersession(UserLoginData user, String userID) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    print('User ID is $userID');
    sp.setString('status', user.status.toString());
    sp.setString('userid', userID);
    sp.setString('userApiHash', user.userApiHash.toString());
    sp.setString('userApiHash', user.userApiHash.toString());
    if (sp.getBool('playAlertSounds') == null) {
      await sp.setBool('playAlertSounds', true);
    }
    if (sp.getDouble('fuelPrice') == null) {
      await sp.setDouble('fuelPrice', 259.0);
    }

    notifyListeners();
    return true;
  }

  Future<UserLoginData> getUserApiHash() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? userApiHash = sp.getString('userApiHash');
    return UserLoginData(userApiHash: userApiHash);
  }

  Future<String> getUserApiHashString() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? userApiHash = sp.getString('userApiHash');
    notifyListeners();
    return Future.value(userApiHash);
  }

  Future<bool> userSessionRemove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseMessaging.instance.deleteToken();
    sp.remove('userApiHash');
    sp.clear();
    return true;
  }
}
