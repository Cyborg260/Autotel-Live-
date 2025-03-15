import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/view_model/services/usersessiondata.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  UserSessionData userSessionData = UserSessionData();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    //print(userSessionData.userApihashKey);
    Timer(const Duration(seconds: 1), (() async {
      userSessionData.checkusersession(context);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: Image(image: AssetImage(AppColors.logoPath)),
        ),
      ),
    );
  }
}
