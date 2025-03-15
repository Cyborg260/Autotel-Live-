class EventsAlerts {
  int? status;
  Items? items;

  EventsAlerts({this.status, this.items});

  EventsAlerts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items!.toJson();
    }
    return data;
  }
}

class Items {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Items(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Items.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? deviceId;
  dynamic? geofenceId;
  dynamic? poiId;
  int? positionId;
  int? alertId;
  String? type;
  String? message;
  dynamic? address;
  int? altitude;
  int? course;
  dynamic? latitude;
  dynamic? longitude;
  dynamic? power;
  int? speed;
  String? time;
  int? deleted;
  String? createdAt;
  String? updatedAt;
  Additional? additional;
  dynamic? description;
  dynamic? driver;
  dynamic? violation;
  int? hideEvents;
  dynamic? notificationDetails;
  String? name;
  String? detail;
  dynamic? geofence;
  String? deviceName;

  Data(
      {this.id,
      this.userId,
      this.deviceId,
      this.geofenceId,
      this.poiId,
      this.positionId,
      this.alertId,
      this.type,
      this.message,
      this.address,
      this.altitude,
      this.course,
      this.latitude,
      this.longitude,
      this.power,
      this.speed,
      this.time,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.additional,
      this.description,
      this.driver,
      this.violation,
      this.hideEvents,
      this.notificationDetails,
      this.name,
      this.detail,
      this.geofence,
      this.deviceName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deviceId = json['device_id'];
    geofenceId = json['geofence_id'];
    poiId = json['poi_id'];
    positionId = json['position_id'];
    alertId = json['alert_id'];
    type = json['type'];
    message = json['message'];
    address = json['address'];
    altitude = json['altitude'];
    course = json['course'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    power = json['power'];
    speed = json['speed'];
    time = json['time'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    additional = json['additional'] != null
        ? new Additional.fromJson(json['additional'])
        : null;
    description = json['description'];
    driver = json['driver'];
    violation = json['violation'];
    hideEvents = json['hide_events'];
    notificationDetails = json['notification_details'];
    name = json['name'];
    detail = json['detail'];
    geofence = json['geofence'];
    deviceName = json['device_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['device_id'] = this.deviceId;
    data['geofence_id'] = this.geofenceId;
    data['poi_id'] = this.poiId;
    data['position_id'] = this.positionId;
    data['alert_id'] = this.alertId;
    data['type'] = this.type;
    data['message'] = this.message;
    data['address'] = this.address;
    data['altitude'] = this.altitude;
    data['course'] = this.course;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['power'] = this.power;
    data['speed'] = this.speed;
    data['time'] = this.time;
    data['deleted'] = this.deleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.additional != null) {
      data['additional'] = this.additional!.toJson();
    }
    data['description'] = this.description;
    data['driver'] = this.driver;
    data['violation'] = this.violation;
    data['hide_events'] = this.hideEvents;
    data['notification_details'] = this.notificationDetails;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['geofence'] = this.geofence;
    data['device_name'] = this.deviceName;
    return data;
  }
}

class Additional {
  int? stopDuration;
  String? movedAt;
  int? overspeedSpeed;

  Additional({this.stopDuration, this.movedAt, this.overspeedSpeed});

  Additional.fromJson(Map<String, dynamic> json) {
    stopDuration = json['stop_duration'];
    movedAt = json['moved_at'];
    overspeedSpeed = json['overspeed_speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stop_duration'] = this.stopDuration;
    data['moved_at'] = this.movedAt;
    data['overspeed_speed'] = this.overspeedSpeed;
    return data;
  }
}
