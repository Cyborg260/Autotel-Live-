// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view_model/auth_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../res/components/submitbutton.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  _launchURLBrowser(String link) async {
    var url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 0,
              ),
              Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                width: 250,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                ),
                child:

                    ///***If you have exported images you must have to copy those images in assets/images directory.
                    Image(
                  image: AssetImage(AppColors.logoPath),
                  // fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                child: Row(
                  children: const [
                    Text(
                      "Sign in!",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextField(
                  controller: emailController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon:
                        Icon(Icons.person, color: Color(0xff212435), size: 15),
                  ),
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (value) {
                    Utils.fieldFocusChange(
                        context, emailFocusNode, passwordFocusNode);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Color(0xff212435),
                      size: 15,
                    ),
                  ),
                  focusNode: passwordFocusNode,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: SubmitButton(
                  loading: authViewModel.loading,
                  onPresse: () async {
                    if (emailController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          'Please enter username', context);
                    } else if (passwordController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          'Please enter password', context);
                    } else {
                      Map data = {
                        'email': emailController.text.toString(),
                        'password': passwordController.text.toString(),
                      };
                      Map dataDemo = {
                        'email': 'aghazeeshan@gmail.com',
                        'password': '1234567',
                      };
                      authViewModel.loginApi(data, context);
                    }
                  },
                  title: 'Sign In',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dont have an account? '),
                  GestureDetector(
                  onTap: () => _launchURLBrowser('mailto:info@theplatinumtrack.com'),
                    child: Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
