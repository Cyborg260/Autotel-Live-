import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/get_report_model.dart';
import 'package:trackerapp/models/view_report_intial_data.dart';
import 'package:trackerapp/repository/get_report_repository.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class GetReportViewModel with ChangeNotifier {
  final _getReportsrepo = GetReportRepository();
  ApiResponse<GetReportModel> getReportsResponse = ApiResponse.loading();

  setGetReportsResponse(ApiResponse<GetReportModel> response) {
    getReportsResponse = response;
    notifyListeners();
  }

  UserLoginViewModel userLoginViewModel = UserLoginViewModel();

  Future<void> fetchGetReportsFromApi(
      ViewReportIntialData viewReportIntialData) async {
    setGetReportsResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    String getReportDateTime =
        '&date_from=${viewReportIntialData.fromDate}&devices[]=${viewReportIntialData.deviceID.toString()}&date_to=${viewReportIntialData.toDate}&format=${viewReportIntialData.reportFormat}&type=${viewReportIntialData.reportType.toString()}';
    print(getReportDateTime);
    _getReportsrepo
        .getReportsApi(userApiKeyString, getReportDateTime)
        .then((value) {
      if (kDebugMode) {
        print(value.url);
      }
      setGetReportsResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setGetReportsResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('Error Accord$error');
      }
    });
  }
}
