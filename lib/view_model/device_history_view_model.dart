import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/device_history_model.dart';
import 'package:trackerapp/repository/device_history_repository.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class DeviceHistoryViewModel with ChangeNotifier {
  final DeviceHistoryRepository _historyRepository = DeviceHistoryRepository();
  ApiResponse<DeviceHistoryModel> deviceHistoryResponse = ApiResponse.loading();
  String summarStatment = 'Loading summary...';
  setSummaryStatment(String summary) {
    summarStatment = summary;
    notifyListeners();
  }

  setHistorySearchList() {
    notifyListeners();
  }

  setDeviceHistoryResponse(ApiResponse<DeviceHistoryModel> response) {
    deviceHistoryResponse = response;
    notifyListeners();
  }

  UserLoginViewModel userLoginViewModel = UserLoginViewModel();

  Future<void> fetchDeviceHisotyFromApi(String deviceID, String fromDate,
      String toDate, String fromTime, String toTime) async {
    setDeviceHistoryResponse(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    String deviceHistoryDateTime =
        '&device_id=$deviceID&from_date=$fromDate&from_time=$fromTime&to_date=$toDate&to_time=$toTime';
    _historyRepository
        .deviceHistoryApi(userApiKeyString, deviceHistoryDateTime)
        .then((value) {
      setDeviceHistoryResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setDeviceHistoryResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchTodayDeviceHisotyFromApi(String deviceID, int days) async {
    late String toDate;
    late String fromDate;
    String fromTime = '00:00:01';
    String toTime = '23:59:00';
    DateTime dt;
    DateFormat newFormat;
    dt = DateTime.now();
    newFormat = DateFormat("yy-MM-dd");
    toDate = newFormat.format(dt);

    setDeviceHistoryResponse(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;

    switch (days) {
      case 0:
        toDate = newFormat.format(dt);
        fromDate = newFormat.format(dt);
        break;

      case 1:
        toDate = newFormat.format(dt.subtract(const Duration(days: 1)));
        fromDate = newFormat.format(dt.subtract(const Duration(days: 1)));

        break;
      case 7:
        toDate = newFormat.format(dt);
        fromDate = newFormat.format(dt.subtract(const Duration(days: 7)));
        break;
      case 30:
        toDate = newFormat.format(dt);
        fromDate = newFormat.format(dt.subtract(const Duration(days: 30)));
        break;
      default:
    }

    String deviceHistoryDateTime =
        '&device_id=$deviceID&from_date=$fromDate&from_time=$fromTime&to_date=$toDate&to_time=$toTime';
    _historyRepository
        .deviceHistoryApi(userApiKeyString, deviceHistoryDateTime)
        .then((value) {
      switch (days) {
        case 0:
          summarStatment =
              'Today, Your vehicle traveled ${value.distanceSum} with maximum speed at ${value.topSpeed}.';
          break;
        case 1:
          summarStatment =
              'Yesterday, Your vehicle traveled ${value.distanceSum} with maximum speed at ${value.topSpeed}.';
          break;
        case 7:
          summarStatment =
              'In last 7 days, Your vehicle traveled ${value.distanceSum} with maximum speed at ${value.topSpeed}.';
          break;
        case 30:
          summarStatment =
              'In last 30 days, Your vehicle traveled ${value.distanceSum} with maximum speed at ${value.topSpeed}.';
          break;
        default:
      }

      // print(value.distanceSum);
      // print(value.move_duration);
      // print(value.stop_duration);
      setSummaryStatment(summarStatment);
      setDeviceHistoryResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setDeviceHistoryResponse(ApiResponse.error(error.toString()));
    });
  }
}
