import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/device_history_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class DeviceHistoryRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<DeviceHistoryModel> deviceHistoryApi(
      String hashkey, String deviceHistoryDateTime) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(AppUrl.baseURL +
          AppUrl.getDeviceHistoryEndPoint +
          hashkey +
          deviceHistoryDateTime);
      print(AppUrl.baseURL +
          AppUrl.getDeviceHistoryEndPoint +
          hashkey +
          deviceHistoryDateTime);
      return response = DeviceHistoryModel.fromJson(response);
    } catch (e) {
      print('Error is ' + e.toString());
      rethrow;
    }
  }
}
