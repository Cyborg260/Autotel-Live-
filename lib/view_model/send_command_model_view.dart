import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/command_result_model.dart';
import 'package:trackerapp/repository/send_command_repository.dart';
import 'package:trackerapp/utils/utils.dart';

import 'userlogin_view_model.dart';

class SendDeviceCommandViewModel with ChangeNotifier {
  final _sendcommadrepo = SendCommandRepositoy();

  ApiResponse<CommandResultModel> deviceCommandResultResponse =
      ApiResponse.loading();

  setDeviceCommandResultResponse(ApiResponse<CommandResultModel> response) {
    deviceCommandResultResponse = response;
    notifyListeners();
  }

  UserLoginViewModel userLoginViewModel = UserLoginViewModel();

  Future<void> sendDeviceCommandToApi(
      String deviceCommand, String deviceID) async {
    setDeviceCommandResultResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _sendcommadrepo
        .deviceCommandResutlApi(userApiKeyString, deviceCommand, deviceID)
        .then((value) {
      Utils.toastMessage(value.message.toString());
      if (kDebugMode) {
        print(value.message);
      }
      setDeviceCommandResultResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setDeviceCommandResultResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('Error Accord');
      }
    });
  }
}
