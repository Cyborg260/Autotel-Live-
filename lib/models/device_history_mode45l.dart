class DeviceHistoryModel {
  List<dynamic>? items;
  String? distance_sum;
  String? top_speed;
  String? average_speed;
  String? move_duration;
  String? stop_duration;
  Map<dynamic, dynamic>? device;
  int? status;
  DeviceHistoryModel(
      {this.items,
      this.distance_sum,
      this.top_speed,
      this.average_speed,
      this.move_duration,
      this.stop_duration,
      this.device,
      this.status});

  DeviceHistoryModel.fromJson(Map<String, dynamic> json) {
    items = json["items"];
    distance_sum = json["distance_sum"];
    top_speed = json["top_speed"];
    move_duration = json["move_duration"];
    stop_duration = json["stop_duration"];
    device = json["device:"];
    status = json["status"];
  }
}
