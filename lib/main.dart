import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:notification_permissions/notification_permissions.dart';
import 'package:trackerapp/utils/routes/routes.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view_model/auth_view_model.dart';
import 'package:trackerapp/view_model/device_commands_view_model.dart';
import 'package:trackerapp/view_model/event_view_model.dart';
import 'package:trackerapp/view_model/expnese_record_view_model.dart';
import 'package:trackerapp/view_model/services/playsounds.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

@pragma('vm:entry-point')
Future<void> backGroundHandler(RemoteMessage event) async {
  await Firebase.initializeApp();

  //LocalNotificationServices.showNotifiationForground(event);
  if (event.notification != null) {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getBool('playAlertSounds')!) {
      PlaySounds.playAnnoucment(event);
    }

    // LocalNotificationServices.showNotifiationForground(event);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions = const FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
  );
  if (Platform.isAndroid) {
    firebaseOptions = const FirebaseOptions(
      apiKey:
          "AIzaSyBd7u3Jl_979xmMn3-9NtTcPKqFce5smkY", //*** API can be found in FCM google JSON file
      appId: "1:339329536042:android:d08f2ba006966d45abb353",
      messagingSenderId: "339329536042",
      projectId: "autotel-2f5a1",
    );
  } else if (Platform.isIOS) {
    firebaseOptions = const FirebaseOptions(
      apiKey: 'AIzaSyByXVejFx0oYq-U5I37HaBqoeq9dcaV-bk',
      appId: '1:339329536042:ios:61a6b0beced80f67abb353',
      messagingSenderId: '339329536042',
      projectId: 'autotel-2f5a1',
    );
  }

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  FirebaseMessaging.instance.requestPermission();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: true,
  //   provisional: true,
  //   sound: true,
  // );

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: true,
  //   provisional: true,
  //   sound: true,
  // );
  //FirebaseMessaging.onBackgroundMessage(backGroundHandler);
  FirebaseMessaging.onBackgroundMessage(backGroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserLoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseRecordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseRecordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeviceCommandsViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.white,
        ),
        initialRoute: RoutesName.splashSceen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
