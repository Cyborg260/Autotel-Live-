import 'package:flutter/cupertino.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/osm_address_model.dart';
import 'package:trackerapp/repository/osmaddress_repository.dart';

class OsmAddressViewModel with ChangeNotifier {
  // bool _disposed = false;
  // @override
  // void dispose() {
  //   _disposed = true;
  //   super.dispose();
  // }

  // @override
  // void notifyListeners() {
  //   if (!_disposed) {
  //     super.notifyListeners();
  //   }
  // }

  final _osmaddressrepo = OsmAddressRepository();

  ApiResponse<OsmAddressModel> osmAddressResponse = ApiResponse.loading();

  setOsmAddressResponse(ApiResponse<OsmAddressModel> response) {
    osmAddressResponse = response;
    notifyListeners();
  }

  Future<void> fetchOsmAddress(double lat, double lng) async {
    String latlngEndPoint = '&lat=$lat&lon=$lng';
    // print('Latetst Lang is ' + latlngEndPoint);
    // print(latlngEndPoint);
    // setOsmAddressResponse(ApiResponse.loading());
    _osmaddressrepo.getOsmAddressApi(latlngEndPoint).then((value) {
      // print('Fetching OSM address');
      // print(value.features![0].properties!.displayName);
      setOsmAddressResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setOsmAddressResponse(ApiResponse.error(error.toString()));
      print('address Error Accord');
      // print(error.toString());
    });
  }

  Future<String> fetchOsmAddressAsString(double lat, double lng) async {
    String latlngEndPoint = '&lat=$lat&lon=$lng';
    print('Latetst Lang is ' + latlngEndPoint);
    //setOsmAddressResponse(ApiResponse.loading());
    _osmaddressrepo.getOsmAddressApi(latlngEndPoint).then((value) {
      print('Fetching OSM address');
      print(value.features![0].properties!.displayName);
      return value.features![0].properties!.displayName.toString();
    }).onError((error, stackTrace) {
      print('Error Accord');
      print(error.toString());
      return error.toString();
    });
    return 'Adress not found';
  }
}
