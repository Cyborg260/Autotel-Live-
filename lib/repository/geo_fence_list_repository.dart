import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/geo_fence_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class GeoFenceListRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<GeoFenceModel> geoFenceListFromAPI(String hashkey) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          AppUrl.baseURL + AppUrl.getGeoFenceListEndPoint + hashkey);
      //print(response[0].toString());
      return response = GeoFenceModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeGeoFenceActivationStatus(
      String hashkey, String fenceID, int fenceStatus) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.changeGeoFenceActivationEndPoint}$hashkey&id=$fenceID&active=$fenceStatus');
      //print(response[0].toString());
      // return response = GeoFenceModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGeoFenceActivationStatus(
      String hashkey, String fenceID) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.deleteGeoFenceEndPoint}$hashkey&geofence_id=$fenceID');
      //print(response[0].toString());
      // return response = GeoFenceModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
