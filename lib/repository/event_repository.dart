import 'package:trackerapp/data/network/networkAPIservices.dart';
import 'package:trackerapp/models/event_modle.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';

class EventRepository {
  final NetworkAPIservices _apiServicess = NetworkAPIservices();

  Future<EventsAlerts> eventsAlertsApi(
      String hashkey,
      String fromDate,
      String toDate,
      String eventType,
      String deviceID,
      String pageNumber) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.eventsEndPoint}$hashkey&type=$eventType&date_from=$fromDate&date_to=$toDate&device_id=$deviceID&page=$pageNumber');
      return response = EventsAlerts.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<EventsAlerts> destroyEventsAlertsApi(String hashkey) async {
    try {
      dynamic response = await _apiServicess.getAPIresponse(
          '${AppUrl.baseURL}${AppUrl.destroyEventsEndPoint}$hashkey');
      return response = EventsAlerts.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
