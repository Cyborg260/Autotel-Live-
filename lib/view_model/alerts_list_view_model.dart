import 'package:flutter/material.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/alert_list_model.dart';
import 'package:trackerapp/repository/alert_type_list_repository.dart';

import 'userlogin_view_model.dart';

class AlertsListViewModel with ChangeNotifier {
  final _repoAlertListView = AlertListRepository();
  ApiResponse<AlertsListModel> alertsListResponse = ApiResponse.loading();
  setAlertsListTypeResponse(ApiResponse<AlertsListModel> response) {
    alertsListResponse = response;
    notifyListeners();
  }

  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  Future<void> fetchAlertsTypeListFromAPI() async {
    // setAlertsListTypeResponse(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _repoAlertListView.alertsTypeListApi(userApiKeyString).then(
      (value) {
        setAlertsListTypeResponse(ApiResponse.complete(value));
      },
    ).onError((error, stackTrace) {
      setAlertsListTypeResponse(ApiResponse.error(error.toString()));
      print('Error List ' + error.toString());
    });
  }

  Future<void> changeAlertActivation(
      String alertID, String activationStatus) async {
    // setAlertsListTypeResponse(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _repoAlertListView
        .changeAlertValueApi(userApiKeyString, alertID, activationStatus)
        .then((value) => fetchAlertsTypeListFromAPI());
  }
}
