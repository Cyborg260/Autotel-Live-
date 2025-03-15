import 'package:flutter/foundation.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/report_type_model.dart';
import 'package:trackerapp/repository/reporttype_repository.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class ReportTypeViewModel with ChangeNotifier {
  final _reportTypeRepo = ReportTypeRepository();

  ApiResponse<ReportTypeModel> reportsTypeResponse = ApiResponse.loading();
  setReportsTypeResponse(ApiResponse<ReportTypeModel> response) {
    reportsTypeResponse = response;
    notifyListeners();
  }

  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  Future<void> fetchReportsTypeFromApi() async {
    setReportsTypeResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _reportTypeRepo.reportTypesApi(userApiKeyString).then((value) {
      if (kDebugMode) {
        for (var element in value.items!) {
          // print(element.name);
        }
        // print(value.items!.length);
      }
      setReportsTypeResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setReportsTypeResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('this is $error');
      }
    });
  }
}
