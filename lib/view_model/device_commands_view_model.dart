import 'package:flutter/foundation.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/device_commnad_list_model.dart';
import 'package:trackerapp/repository/device_command_list_repository.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class DeviceCommandsViewModel with ChangeNotifier {
  final _deviceCommandsRepo = GetDeivceCommadList();
  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  ApiResponse<List<DeviceCommandsListsModel>> getDeviceCommandsListResponse =
      ApiResponse.loading();
  late String userApiKeyString;
  setGetDeviceCommandsList(
      ApiResponse<List<DeviceCommandsListsModel>> response) {
    getDeviceCommandsListResponse = response;
    notifyListeners();
  }

  setCmmadSelection() {
    notifyListeners();
  }

  Future<void> getDeviceCommandListFromApi(String deviceID) async {
    setGetDeviceCommandsList(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    userApiKeyString = await userApiKey;
    print('Fetching Commands');

    _deviceCommandsRepo
        .getDeviceCommandsListApi(userApiKeyString, deviceID)
        .then((value) {
      setGetDeviceCommandsList(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setGetDeviceCommandsList(ApiResponse.error(error.toString()));
      print('Errro is ' + error.toString());
    });
  }
}
