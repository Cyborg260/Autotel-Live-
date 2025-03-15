import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackerapp/repository/change_password_repository.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/submitbutton.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view/home.dart';
import 'package:trackerapp/view_model/expnese_record_view_model.dart';
import 'package:trackerapp/view_model/services/usersessiondata.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';
import 'package:trackerapp/view_model/vehicle_maintenance_view_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserSessionData userSessionData = UserSessionData();
  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  VehicleMaintenanceViewModel vehicleMaintenanceViewModel =
      VehicleMaintenanceViewModel();
  ExpenseRecordViewModel expenseRecordViewModel = ExpenseRecordViewModel();

  FlutterTts ftts = FlutterTts();
  SharedPreferences? sp;
  bool currentCheckBoxValue = false;
  bool? alertsNotifications = false;
  double? fuelprice = 200;
  String? userID = 'User ID';
  Future<bool> getSharedPreferenceInstance() async {
    sp = await SharedPreferences.getInstance();
    currentCheckBoxValue = sp!.getBool('playAlertSounds')!;
    userID = sp!.getString('userid');
    fuelprice = sp!.getDouble('fuelPrice');

    return Future.value(currentCheckBoxValue);
  }

  Future<void> setFuelPrice(BuildContext context) {
    final fuelPriceController = TextEditingController();
    FocusNode fuelFocusNode = FocusNode();
    return showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Set Fuel Price'),
                        InkWell(
                          child: const Icon(Icons.close),
                          onTap: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: fuelPriceController,
                      focusNode: fuelFocusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Current Fuel Cost per Liter",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: Color(0xfff2f2f3),
                        isDense: false,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        prefixIcon: Icon(
                          Icons.price_change_outlined,
                          color: Color(0xff212435),
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SubmitButton(
                      title: 'Set Fuel Price',
                      onPresse: () async {
                        if (double.parse(fuelPriceController.text) < 200 ||
                            double.parse(fuelPriceController.text) > 1000) {
                          Utils.toastMessage(
                              'Please enter value from 200 to 1000 range');
                          fuelPriceController.clear();
                          fuelFocusNode.requestFocus();
                          return;
                        }
                        final SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setDouble('fuelPrice',
                            double.parse(fuelPriceController.text));
                        print(fuelPriceController.text);
                        getSharedPreferenceInstance();
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changePassword(BuildContext context) async {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    FocusNode passwordFocusNode = FocusNode();

    UserLoginViewModel userLoginViewModel = UserLoginViewModel();
    ChangePasswordRepository changePasswordRepository =
        ChangePasswordRepository();
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();

    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Change Password'),
                        InkWell(
                          child: const Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
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
                        fillColor: Color(0xfff2f2f3),
                        isDense: false,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        prefixIcon: Icon(
                          Icons.price_change_outlined,
                          color: Color(0xff212435),
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: Color(0xfff2f2f3),
                        isDense: false,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        prefixIcon: Icon(
                          Icons.price_change_outlined,
                          color: Color(0xff212435),
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SubmitButton(
                      title: 'Change Password',
                      onPresse: () async {
                        String userApiKeyString = await userApiKey;

                        if (passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          Utils.flushBarErrorMessage(
                              'Please enter password', context);
                          return;
                        }
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          passwordController.clear();
                          confirmPasswordController.clear();
                          passwordFocusNode.requestFocus();
                          Utils.flushBarErrorMessage(
                              'Confirmation Password does not match', context);
                          return;
                        }
                        changePasswordRepository
                            .changePasswordFromApi(
                                userApiKeyString, passwordController.text)
                            .then((value) {
                          if (value.status == 1) {
                            Utils.toastMessage('Password has been changed');
                            Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                navBarIndex = 0;
                                userLoginViewModel
                                    .userSessionRemove()
                                    .then((value) {
                                  userSessionData.checkusersession(context);
                                });
                              },
                            );
                          } else {
                            Utils.flushBarErrorMessage(
                                value.message.toString(), context);
                          }
                        }).onError((error, stackTrace) {
                          Utils.flushBarErrorMessage(
                              'Password cannot be changed at this moment',
                              context);
                        });

                        // setState(() {
                        //   Navigator.pop(context);
                        // });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    expenseRecordViewModel.fetchExpenseRecordsForVehicle('');
    vehicleMaintenanceViewModel.fetchVehicleMaintenanceList('');
    getSharedPreferenceInstance().then((value) {
      currentCheckBoxValue = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getSharedPreferenceInstance();
    return SafeArea(
      child: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Settings',
              style: AppColors.appTitleTextStyle,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.buttonColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.person),
                              //VerticalDivider(),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // height: 30,
                      width: MediaQuery.of(context).size.width - 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             children: [
                          //               Text('aghabro@gmail.com'),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Column(
                          //         children: [
                          //           Text('aghabro@gmail.com'),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Card(
                            shape: AppColors.cardBorderShape,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(247, 6, 84, 117),
                                radius: 16,
                                child: Icon(
                                  size: 18,
                                  Icons.person,
                                ),
                              ),
                              title: Text(
                                userID.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              trailing: Container(
                                child: GFButton(
                                  onPressed: () {
                                    navBarIndex = 0;
                                    userLoginViewModel
                                        .userSessionRemove()
                                        .then((value) {
                                      userSessionData.checkusersession(context);
                                    });
                                  },
                                  text: "Logout",
                                  textStyle:
                                      AppColors.settingPageButtonTextStyle,
                                  color: AppColors.buttonColor,
                                  shape: GFButtonShape.pills,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Card(
                            shape: AppColors.cardBorderShape,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(247, 11, 105, 6),
                                radius: 16,
                                child: Icon(
                                  size: 18,
                                  Icons.key,
                                ),
                              ),
                              title: const Text(
                                'Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              trailing: GFButton(
                                onPressed: () async {
                                  // changePassword(context);
                                },
                                text: 'Change',
                                textStyle: AppColors.settingPageButtonTextStyle,
                                color: AppColors.buttonColor,
                                shape: GFButtonShape.pills,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      //height: 30,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.buttonColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.settings),
                                //  VerticalDivider(),
                                Text(
                                  'Tools',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      // height: 30,
                      width: MediaQuery.of(context).size.width - 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             children: [
                          //               Text('aghabro@gmail.com'),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Column(
                          //         children: [
                          //           Text('aghabro@gmail.com'),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Card(
                            shape: AppColors.cardBorderShape,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName.geoFenceList);
                              },
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(247, 5, 93, 152),
                                  radius: 16,
                                  child: Icon(
                                    size: 18,
                                    Icons.fence,
                                  ),
                                ),
                                title: Text(
                                  'Geofecne Settings',
                                  style: AppColors.settingTextstyle,
                                ),
                                trailing: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.arrow_forward),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shape: AppColors.cardBorderShape,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName.alertsTypeList);
                              },
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(247, 91, 4, 153),
                                  radius: 16,
                                  child: Icon(
                                    size: 18,
                                    Icons.notifications,
                                  ),
                                ),
                                title: Text(
                                  'Alerts Settings',
                                  style: AppColors.settingTextstyle,
                                ),
                                trailing: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.arrow_forward),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shape: AppColors.cardBorderShape,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(247, 144, 6, 132),
                                radius: 16,
                                child: Icon(
                                  size: 18,
                                  Icons.speaker,
                                ),
                              ),
                              title: Text(
                                'Play Alerts Announcement',
                                style: AppColors.settingTextstyle,
                              ),
                              trailing: SizedBox(
                                // height: 25,
                                width: 50,
                                child: GFCheckbox(
                                    size: GFSize.SMALL,
                                    activeBgColor: AppColors.buttonColor,
                                    onChanged: (checkboxvalue) async {
                                      if (checkboxvalue) {
                                        currentCheckBoxValue = true;
                                        sp!.setBool('playAlertSounds',
                                            currentCheckBoxValue);
                                        setState(() {});
                                      } else {
                                        currentCheckBoxValue = false;
                                        sp!.setBool('playAlertSounds',
                                            currentCheckBoxValue);
                                        setState(() {});
                                      }
                                    },
                                    value: currentCheckBoxValue),
                              ),
                            ),
                          ),
                          Card(
                            shape: AppColors.cardBorderShape,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(247, 182, 63, 8),
                                radius: 16,
                                child: Icon(
                                  size: 18,
                                  Icons.gas_meter_outlined,
                                ),
                              ),
                              title: Text(
                                'Fuel Cost : Rs.$fuelprice/l',
                                style: AppColors.settingTextstyle,
                              ),
                              trailing: GFButton(
                                onPressed: () {
                                  setFuelPrice(context);
                                },
                                text: "Set Price",
                                textStyle: AppColors.settingPageButtonTextStyle,
                                color: AppColors.buttonColor,
                                shape: GFButtonShape.pills,
                                size: 20,
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.viewExpenseScreen,
                                  arguments: {'vehicleId': ''});
                            },
                            child: Card(
                              shape: AppColors.cardBorderShape,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          maxRadius: 16,
                                          backgroundColor: Colors.blueAccent,
                                          child: Icon(
                                              Icons.attach_money_outlined,
                                              size: 18),
                                        ),
                                        const VerticalDivider(
                                          width: 24,
                                        ),
                                        Text(
                                          'Vehicle Expenses',
                                          style: AppColors.settingTextstyle,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ChangeNotifierProvider.value(
                                          value: expenseRecordViewModel,
                                          child:
                                              Consumer<ExpenseRecordViewModel>(
                                            builder: (context, viewModel, _) {
                                              double totalAmount = viewModel
                                                  .calculateTotalAmount();
                                              return Text('Rs.$totalAmount');
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesName.viewMaintenanceSchedule,
                              );
                            },
                            child: Card(
                              shape: AppColors.cardBorderShape,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          maxRadius: 16,
                                          backgroundColor: Colors.red[800],
                                          child: const Icon(
                                            Icons.car_repair,
                                            size: 18,
                                          ),
                                        ),
                                        const VerticalDivider(
                                          width: 24,
                                        ),
                                        Text(
                                          'Maintenance',
                                          style: AppColors.settingTextstyle,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 16,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value:
                                                    vehicleMaintenanceViewModel,
                                                child: Consumer<
                                                    VehicleMaintenanceViewModel>(
                                                  builder:
                                                      (context, viewModel, _) {
                                                    return Text(viewModel
                                                        .maintenanceList.length
                                                        .toString());
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            InkWell(
                                                onTap: () => Navigator.pushNamed(
                                                    context,
                                                    RoutesName
                                                        .addVehicleMaintenanceScreen),
                                                child: const CircleAvatar(
                                                    maxRadius: 16,
                                                    child: Text('+'))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: SubmitButton(
                //     title: 'Play ',
                //     onPresse: () async {
                //       await ftts.setLanguage("en-US");
                //       await ftts.setSpeechRate(0.6); //speed of speech
                //       await ftts.setVolume(1.0); //volume of speech
                //       await ftts.setPitch(1); //pitc of sound
                //       var result = await ftts.speak("Vehicle-Ignition-Turned-Off");
                //       if (result == 1) {
                //         //speaking
                //       } else {
                //         //not speaking
                //       }
                //     },
                //   ),
                // ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
