import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/alert_list_model.dart';
import 'package:trackerapp/models/change_password_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class ChangePasswordRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<ChangePasswordModel> changePasswordFromApi(
      String hashkey, String password) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.changePasswordEndPoint}$hashkey&password=$password&password_confirmation=$password');
      //print(response);
      return response = ChangePasswordModel.fromJson(response);
    } catch (e) {
      print('the error is$e');
      rethrow;
    }
  }
}
