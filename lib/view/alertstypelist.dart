import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view_model/alerts_list_view_model.dart';

class AlertsTypeListScreen extends StatefulWidget {
  const AlertsTypeListScreen({super.key});

  @override
  State<AlertsTypeListScreen> createState() => _AlertsTypeListScreenState();
}

class _AlertsTypeListScreenState extends State<AlertsTypeListScreen> {
  AlertsListViewModel alertsListViewModel = AlertsListViewModel();
  bool currentCheckBoxValue = false;

  @override
  void initState() {
    // TODO: implement initState
    alertsListViewModel.fetchAlertsTypeListFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Alerts Settings',
              style: AppColors.appTitleTextStyle,
            ),
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            centerTitle: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChangeNotifierProvider<AlertsListViewModel>(
                create: (BuildContext context) => alertsListViewModel,
                child: Consumer<AlertsListViewModel>(
                  builder: (context, value, _) {
                    switch (value.alertsListResponse.status) {
                      case Status.LOADING:
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                    image:
                                        AssetImage('assets/images/loading.gif'),
                                    width: 100,
                                    height: 100),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Loading...')
                              ],
                            ),
                          ),
                        );
                      case Status.ERROR:
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                    image:
                                        AssetImage('assets/images/loading.gif'),
                                    width: 100,
                                    height: 100),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(AppColors.errorMessage)
                              ],
                            ),
                          ),
                        );
                      case Status.COMPLETED:
                        return Expanded(
                          child: ListView.builder(
                            itemCount: value
                                .alertsListResponse.data!.items.alerts.length,
                            itemBuilder: (context, index) {
                              if (value.alertsListResponse.data!.items
                                      .alerts[index].active ==
                                  1) {
                                currentCheckBoxValue = true;
                              } else {
                                currentCheckBoxValue = false;
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                child: Card(
                                  shape: AppColors.cardBorderShape,
                                  child: ListTile(
                                    title: Text(
                                      value.alertsListResponse.data!.items
                                          .alerts[index].name
                                          .toString(),
                                      style: AppColors.settingTextstyle,
                                    ),
                                    trailing: SizedBox(
                                      width: 50,
                                      child: GFCheckbox(
                                          size: GFSize.SMALL,
                                          activeBgColor: AppColors.buttonColor,
                                          onChanged: (checkboxvalue) async {
                                            if (checkboxvalue) {
                                              alertsListViewModel
                                                  .changeAlertActivation(
                                                      value
                                                          .alertsListResponse
                                                          .data!
                                                          .items
                                                          .alerts[index]
                                                          .id
                                                          .toString(),
                                                      'true');
                                            } else {
                                              alertsListViewModel
                                                  .changeAlertActivation(
                                                      value
                                                          .alertsListResponse
                                                          .data!
                                                          .items
                                                          .alerts[index]
                                                          .id
                                                          .toString(),
                                                      'false');
                                            }
                                            Utils.toastMessage('Updating...');
                                          },
                                          value: currentCheckBoxValue),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );

                      default:
                        const Text('Something went wrong');
                    }
                    return Container();
                  },
                ),
              )
            ],
          )),
    );
  }
}
