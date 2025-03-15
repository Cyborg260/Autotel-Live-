import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackerapp/models/events_intitial_data.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/view/alerts.dart';
import 'package:trackerapp/view/alldevicesonmap.dart';
import 'package:trackerapp/view/contactusscreen.dart';
import 'package:trackerapp/view/dashboard.dart';
import 'package:trackerapp/view/settings.dart';
import 'package:trackerapp/view/statusdashboard%20copy.dart';
import 'package:trackerapp/view_model/services/localnotification.dart';
import 'package:trackerapp/view_model/services/playsounds.dart';

int navBarIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts fttsss = FlutterTts();
  EventsInitialData eventsInitialData = EventsInitialData();

  var routs = [
    const Dashboard(),
    const StatusDashboardSecond(),
    const DevicesOnMap(),
    EventsAlertsPage(
      EventsInitialData(
          deviceID: '',
          eventType: '',
          fromDate: '',
          toDate: '',
          pageNumber: ''),
    ),
    const SettingScreen(),
    const ContactUsScreen(),
  ];

  void playAnnoucments(RemoteMessage message) async {
    FlutterTts fttsssss = FlutterTts();
    List<String> notificationArray = message.notification!.title!.split(' ');
    List<String> notificationStringList = [];
    late String notificationAnnoucementString;
    for (var i = 1; i < notificationArray.length; i++) {
      notificationStringList.add(notificationArray[i]);
    }
    notificationAnnoucementString = notificationStringList.join(' ');

    List<String> vehicleNumberr = notificationArray[0].split('');
    String vehicleNumber = 'Alert! ';
    for (var element in vehicleNumberr) {
      vehicleNumber = "$vehicleNumber $element";
    }
    vehicleNumber = '$vehicleNumber .';

    await fttsss.speak('$vehicleNumber $notificationAnnoucementString');
  }

  Future<bool> _onWillPop(context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    LocalNotificationServices.initilize();
    fttsss.setLanguage("en-US");
    fttsss.setSpeechRate(0.5); //speed of speech
    fttsss.setVolume(1.0); //volume of speech
    fttsss.setPitch(1); //pitc of sound

    FirebaseMessaging.instance.getToken().then((value) => print(value));

    FirebaseMessaging.instance.getInitialMessage().then((event) async {
      if (event != null) {
        if (event.notification != null) {
          LocalNotificationServices.showNotifiationForground(event);
          final SharedPreferences sp = await SharedPreferences.getInstance();
          if (sp.getBool('playAlertSounds')!) {
            PlaySounds.playAnnoucment(event);
          }
        }
      }
    });
    FirebaseMessaging.onMessage.listen((event) async {
      LocalNotificationServices.showNotifiationForground(event);
      if (event.notification != null) {
        final SharedPreferences sp = await SharedPreferences.getInstance();

        if (sp.getBool('playAlertSounds')!) {
          PlaySounds.playAnnoucment(event);
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      final SharedPreferences sp = await SharedPreferences.getInstance();

      if (sp.getBool('playAlertSounds')!) {
        PlaySounds.playAnnoucment(event);
      }
      if (event.notification != null) {}
      setState(() {
        navBarIndex = 3;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: routs[navBarIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              label: navBarIndex == 0 ? 'Dashboard' : 'Home',
              activeIcon: const Icon(Icons.dashboard),
              // backgroundColor: Color(0xffefecec)
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Status',
                activeIcon: Icon(Icons.map)),
            const BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Map',
                activeIcon: Icon(Icons.location_on)),
            const BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                label: 'Alerts',
                activeIcon: Icon(Icons.notifications)),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
                activeIcon: Icon(Icons.settings)),
            const BottomNavigationBarItem(
                icon: Icon(Icons.phone_in_talk_outlined),
                label: 'Contact',
                activeIcon: Icon(Icons.phone_in_talk)),
          ],
          showSelectedLabels: true,
          selectedItemColor: AppColors.buttonColor,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(color: Colors.black87),

          backgroundColor: AppColors.buttonColor,
          iconSize: 28.0,
          //backgroundColor: Colors.white ,
          elevation: 1,

          currentIndex: navBarIndex,
          onTap: ((index) {
            setState(() {
              navBarIndex = index;
            });
          }),
        ),
      ),
    );
  }
}
