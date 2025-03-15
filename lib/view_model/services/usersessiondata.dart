import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:trackerapp/models/user_login_model.dart';
import 'package:trackerapp/repository/fcm_token_submission.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view_model/services/playsounds.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

import 'dart:async';

class UserSessionData {
  Future<UserLoginData> getUserData() => UserLoginViewModel().getUserApiHash();
  FcmTokenRepository _fcmTokenRepository = FcmTokenRepository();
  late String apihashkey;
  void checkusersession(BuildContext context) async {
    getUserData().then((value) {
      if (value.userApiHash == null || value.userApiHash == '') {
        if (kDebugMode) {
          print('No user Login');
        }
        Navigator.pushReplacementNamed(context, RoutesName.login);
      } else {
        print('User is Login');
        apihashkey = value.userApiHash.toString();

        int currentHour = DateTime.now().hour;
        String welcomeMessage = '';
        if (currentHour > 0 && currentHour < 12) {
          welcomeMessage = 'Good Morning';
        } else if (currentHour > 12 && currentHour < 18) {
          welcomeMessage = 'Good Afternood';
        } else if (currentHour > 18 && currentHour < 24) {
          welcomeMessage = 'Good evening';
        }

        // PlaySounds.playStringAnnoucment(welcomeMessage);
        FirebaseMessaging.instance.getToken().then((fcmToken) {
          print('FCM token is ' + fcmToken.toString());
          _fcmTokenRepository
              .fcmTokenSubmmissionApi(apihashkey, fcmToken.toString())
              .then((value) => print('Token Submitted'));
        });

        print(apihashkey);
        Navigator.pushReplacementNamed(context, RoutesName.home);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
