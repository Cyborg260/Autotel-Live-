import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PlaySounds {
  static void playAnnoucment(RemoteMessage message) async {
    FlutterTts ftts = FlutterTts();
    ftts.setLanguage("en-US");
    ftts.setSpeechRate(0.5); //speed of speech
    ftts.setVolume(1.0); //volume of speech
    ftts.setPitch(1);
    await ftts.setSharedInstance(true);
    await ftts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt);
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
    print(vehicleNumber);

    await ftts.speak('$vehicleNumber $notificationAnnoucementString');
  }

  // void playAnnoucments(RemoteMessage message) async {
  //   FlutterTts ftts = FlutterTts();
  //   List<String> notificationArray = message.notification!.title!.split(' ');
  //   List<String> notificationStringList = [];
  //   late String notificationAnnoucementString;
  //   for (var i = 1; i < notificationArray.length; i++) {
  //     notificationStringList.add(notificationArray[i]);
  //   }
  //   notificationAnnoucementString = notificationStringList.join(' ');

  //   List<String> vehicleNumberr = notificationArray[0].split('');
  //   String vehicleNumber = 'Alert! ';
  //   for (var element in vehicleNumberr) {
  //     vehicleNumber = "$vehicleNumber $element";
  //   }
  //   vehicleNumber = '$vehicleNumber .';
  //   print(vehicleNumber);

  //   await ftts.speak('$vehicleNumber $notificationAnnoucementString');
  // }

  // static void playStringAnnoucment(String message) async {
  //   FlutterTts ftts = FlutterTts();

  //   await ftts.speak(message);
  // }
}
