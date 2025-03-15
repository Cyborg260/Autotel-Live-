import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/alert_list_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class AlertListRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<AlertsListModel> alertsTypeListApi(String hashkey) async {
    try {
      dynamic response = await _apiServicess
          .getAPIresponse(AppUrl.baseURL + AppUrl.getAlertsTypeList + hashkey);
      //print(response);
      return response = AlertsListModel.fromJson(response);
    } catch (e) {
      print('the error is' + e.toString());
      rethrow;
    }
  }

  Future<void> changeAlertValueApi(
      String hashkey, String alertID, String activationStatus) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.changeAlertValue}$hashkey&id=$alertID&active=$activationStatus');
      //print(response);
      //return response = AlertsListModel.fromJson(response);
    } catch (e) {
      print('the error is' + e.toString());
      rethrow;
    }
  }
}
