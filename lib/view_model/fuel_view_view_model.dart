import 'package:flutter/cupertino.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/device_history_model.dart';
import 'package:trackerapp/repository/device_history_repository.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class FuelReportViewModel with ChangeNotifier {
  final DeviceHistoryRepository _historyRepository = DeviceHistoryRepository();
  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  ApiResponse<DeviceHistoryModel> deviceRoutHistoryResponse =
      ApiResponse.loading();
  setDeviceHistoryResponse(ApiResponse<DeviceHistoryModel> response) {
    deviceRoutHistoryResponse = response;
    notifyListeners();
  }

  Future<void> fetchDeviceRoutHisotyFromApi(String deviceID, String fromDate,
      String toDate, String fromTime, String toTime) async {
    setDeviceHistoryResponse(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    String deviceHistoryDateTime =
        '&device_id=$deviceID&from_date=$fromDate&from_time=$fromTime&to_date=$toDate&to_time=$toTime';
    _historyRepository
        .deviceHistoryApi(userApiKeyString, deviceHistoryDateTime)
        .then(
      (value) {
        setDeviceHistoryResponse(ApiResponse.complete(value));
      },
    ).onError(
      (error, stackTrace) {
        setDeviceHistoryResponse(ApiResponse.error(error.toString()));
      },
    );
  }
}
