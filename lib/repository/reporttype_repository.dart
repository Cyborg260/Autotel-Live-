import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/report_type_model.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class ReportTypeRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();
  Future<ReportTypeModel> reportTypesApi(String hashkey) async {
    try {
      dynamic response = await _apiServicess
          .getAPIresponse(AppUrl.baseURL + AppUrl.generateReportType + hashkey);
      // response = ReportTypeModel.fromJson(response);
      print(response.runtimeType);
      return response = ReportTypeModel.fromJson(response);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
