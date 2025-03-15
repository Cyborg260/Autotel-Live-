class AppUrl {
  // New Server
  static var baseURL = 'https://track.autotel.pk/api';
  static var baseImgURL = 'https://track.autotel.pk/';
  //Old Server
  // static var baseURL = 'https://login.aitrack.pk/api';
  // static var baseImgURL = 'https://login.aitrack.pk/';
  static var loginEndPoint = '/login';
  static var eventsEndPoint = '/get_events?user_api_hash=';
  static var destroyEventsEndPoint = '/destroy_events?user_api_hash=';
  static var getDevicesEndPoint = '/get_devices?user_api_hash=';
  static var getDeviceHistoryEndPoint = '/get_history?user_api_hash=';
  static var generateReportType = '/get_reports_types?user_api_hash=';
  static var generateReports = '/generate_report?user_api_hash=';
  static var osmbaseURL = 'http://nominatim.autotel.pk:8080';
  static var getAlertsTypeList = '/get_alerts?user_api_hash=';
  static var changeAlertValue = '/change_active_alert?user_api_hash=';
  static var osmAddressEndPoint = '/reverse?format=geojson';
  static var fcmAlertTokenEndPoint = '/fcm_token?user_api_hash=';
  static var changePasswordEndPoint = '/change_password?user_api_hash=';
  static var getGeoFenceListEndPoint = '/get_geofences?user_api_hash=';
  static var changeGeoFenceActivationEndPoint =
      '/change_active_geofence?user_api_hash=';
  static var deleteGeoFenceEndPoint = '/destroy_geofence?user_api_hash=';
  static var getDviceCommandsEndPoint = '/get_device_commands?user_api_hash=';
  static var sendDeviceCommandEndPoint = '/send_gprs_command?user_api_hash=';
}
