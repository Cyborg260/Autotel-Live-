import 'package:flutter/foundation.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/geo_fence_model.dart';
import 'package:trackerapp/repository/geo_fence_list_repository.dart';

import 'userlogin_view_model.dart';

class GeoFenceViewViewModel with ChangeNotifier {
  final _geofencerepo = GeoFenceListRepository();

  ApiResponse<GeoFenceModel> geoFenceListResponse = ApiResponse.loading();
  setGeoFenceListResponse(ApiResponse<GeoFenceModel> response) {
    geoFenceListResponse = response;
    notifyListeners();
  }

  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  Future<void> fetchGeoFenceFromApi() async {
    //setGeoFenceListResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    print(userApiKey);
    _geofencerepo.geoFenceListFromAPI(userApiKeyString).then((value) {
      if (kDebugMode) {
        for (var element in value.items.geofences) {
          element.name;
        }
      }
      setGeoFenceListResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setGeoFenceListResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('Error Accord');
      }
    });
  }

  Future<void> deleteGeoFenceFromAPI(String fenceID) async {
    // setGeoFenceListResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _geofencerepo
        .deleteGeoFenceActivationStatus(userApiKeyString, fenceID)
        .then((value) => fetchGeoFenceFromApi())
        .onError((error, stackTrace) {
      setGeoFenceListResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('Error Accord');
      }
    });
  }

  Future<void> changeGeoFenceStatusFromAPI(
      String fenceID, int fenceStatus) async {
    // setGeoFenceListResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _geofencerepo
        .changeGeoFenceActivationStatus(userApiKeyString, fenceID, fenceStatus)
        .then((value) => fetchGeoFenceFromApi())
        .onError((error, stackTrace) {
      setGeoFenceListResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('Error Accord');
      }
    });
  }
}
