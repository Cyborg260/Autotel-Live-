import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/command_result_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class SendCommandRepositoy {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<CommandResultModel> deviceCommandResutlApi(
      String hashkey, String deviceCommand, String deviceID) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.sendDeviceCommandEndPoint}$hashkey&device_id=$deviceID&type=$deviceCommand');
      return response = CommandResultModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
