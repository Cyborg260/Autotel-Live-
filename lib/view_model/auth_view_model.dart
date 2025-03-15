import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/models/user_login_model.dart';
import 'package:trackerapp/repository/auth_repository.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view_model/services/usersessiondata.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();
  bool _loading = false;
  bool get loading => _loading;
  UserLoginData userData = UserLoginData();
  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  UserSessionData userSessionData = UserSessionData();
  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    setloading(true);
    _myRepo.loginApi(data).then((value) async {
      setloading(false);
      userData = UserLoginData.fromJson(value);
      await userLoginViewModel.saveUsersession(userData, data['email']);
      //Navigator.pushReplacementNamed(context, RoutesName.home);
      userSessionData.checkusersession(context);
    }).onError((error, stackTrace) {
      setloading(false);
      Utils.flushBarErrorMessage('Incorrect username or password', context);
      if (kDebugMode) {
        print(error.toString());
      }
      inspect(error);
    });
  }
}
