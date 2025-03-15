import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class AuthRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = await _apiServicess.postAPIresponse(
          AppUrl.baseURL + AppUrl.loginEndPoint, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
