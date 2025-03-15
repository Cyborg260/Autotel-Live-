import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/device_commnad_list_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class GetDeivceCommadList {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();
  List<DeviceCommandsListsModel> devicesCommandsList = [];

  Future<List<DeviceCommandsListsModel>> getDeviceCommandsListApi(
      String hashkey, String deviceID) async {
    try {
      // ignore: prefer_interpolation_to_compose_strings
      dynamic response = await _apiServicess.getAPIresponse(AppUrl.baseURL +
          AppUrl.getDviceCommandsEndPoint +
          hashkey +
          '&device_id=' +
          deviceID);

      devicesCommandsList = List.from(response)
          .map((e) => DeviceCommandsListsModel.fromJson(e))
          .toList();

      return devicesCommandsList;
    } catch (e) {
      print('The actual Error is ' + e.toString());
      rethrow;
    }
  }
}
