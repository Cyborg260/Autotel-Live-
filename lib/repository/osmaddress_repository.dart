import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/osm_address_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class OsmAddressRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<OsmAddressModel> getOsmAddressApi(String latlngEndPoint) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          AppUrl.osmbaseURL + AppUrl.osmAddressEndPoint + latlngEndPoint);
      //  print(AppUrl.osmbaseURL + AppUrl.osmAddressEndPoint + latlngEndPoint);
      return response = OsmAddressModel.fromJson(response);
    } catch (e) {
      // print('Eroor is ' + e.toString());
      rethrow;
    }
  }
}
