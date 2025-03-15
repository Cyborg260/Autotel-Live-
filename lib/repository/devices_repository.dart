import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/devices_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class GetDevicesRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();
  List<DevicesModel> devicesModelList = [];
  Future<DevicesModel> getDevicesApi(String hashkey) async {
    try {
      dynamic response = await _apiServicess
          .getAPIresponse(AppUrl.baseURL + AppUrl.getDevicesEndPoint + hashkey);
      //print(response[0].toString());
      return response = DevicesModel.fromJson(response[0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DevicesModel>> getDevicesListApi(String hashkey) async {
    try {
      dynamic response = await _apiServicess
          .getAPIresponse(AppUrl.baseURL + AppUrl.getDevicesEndPoint + hashkey);
      devicesModelList =
          (response as List).map((e) => DevicesModel.fromJson(e)).toList();
      return devicesModelList;
    } catch (e) {
      rethrow;
    }
  }
}
