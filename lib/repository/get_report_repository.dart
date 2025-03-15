import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/get_report_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class GetReportRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<GetReportModel> getReportsApi(
      String hashkey, String getReportDateTime) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(AppUrl.baseURL +
          AppUrl.generateReports +
          hashkey +
          getReportDateTime);
      return response = GetReportModel.fromJson(response);
    } catch (e) {
      print('Error is ' + e.toString());
      rethrow;
    }
  }
}
