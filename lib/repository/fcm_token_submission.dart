import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/fcm_token_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class FcmTokenRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<FCMTokenModel> fcmTokenSubmmissionApi(
      String hashkey, String fcmToken) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.fcmAlertTokenEndPoint}$hashkey&token=$fcmToken');
      print(response);
      return response = FCMTokenModel.fromJson(response);
    } catch (e) {
      print('Error is ' + e.toString());
      rethrow;
    }
  }
}
