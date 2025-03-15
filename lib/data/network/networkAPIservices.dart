import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:trackerapp/data/app_exeptions.dart';
import 'package:trackerapp/data/network/baseApiservices.dart';
import 'package:http/http.dart' as http;

class NetworkAPIservices extends BaseAPIservices {
  @override
  Future getAPIresponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 180));
      // print(response.body);
      responseJson = returnResponse(response);
      //print(responseJson);
    } on SocketException {
      throw FetchDataException('no inernect connection', 'Alert');
    }
    return responseJson;
  }

  @override
  Future postAPIresponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 180));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('no inernect connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        //return response.statusCode;
        throw FetchDataException(
            'Error while communication ${response.statusCode.toString()}');
    }
  }
}
