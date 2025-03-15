import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/event_modle.dart';
import 'package:trackerapp/repository/event_repository.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class EventViewModel with ChangeNotifier {
  final _eventrepo = EventRepository();

  ApiResponse<EventsAlerts> eventsAlertsResponse = ApiResponse.loading();

  setEventsAlertsResponse(ApiResponse<EventsAlerts> response) {
    eventsAlertsResponse = response;
    notifyListeners();
  }

  resetEventsAlertsResponse() {
    notifyListeners();
  }

  UserLoginViewModel userLoginViewModel = UserLoginViewModel();

  Future<void> fetchEventsAlertsFromApi(
    String deviceID,
    String eventType,
    String fromDate,
    String toDate,
    String pageNumber,
  ) async {
    //   setEventsAlertsResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _eventrepo
        .eventsAlertsApi(
            userApiKeyString, fromDate, toDate, eventType, deviceID, pageNumber)
        .then((value) {
      if (kDebugMode) {
        print(value.items!.total);
      }
      setEventsAlertsResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setEventsAlertsResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('Error Accord' + error.toString());
      }
    });
  }

  Future<void> destroyEventsAlertsFromApi() async {
    //setEventsAlertsResponse(ApiResponse.loading());

    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;
    _eventrepo.destroyEventsAlertsApi(userApiKeyString).then((value) {
      if (kDebugMode) {
        print('Status is' + value.status.toString());
      }
      //setEventsAlertsResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setEventsAlertsResponse(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('Error Accord');
      }
    });
  }
}
