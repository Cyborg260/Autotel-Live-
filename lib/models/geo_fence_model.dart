class GeoFenceModel {
  GeoFenceModel({
    required this.items,
    required this.status,
  });
  late final Items items;
  late final int status;

  GeoFenceModel.fromJson(Map<String, dynamic> json) {
    items = Items.fromJson(json['items']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.toJson();
    _data['status'] = status;
    return _data;
  }
}

class Items {
  Items({
    required this.geofences,
  });
  late final List<Geofences> geofences;

  Items.fromJson(Map<String, dynamic> json) {
    geofences =
        List.from(json['geofences']).map((e) => Geofences.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['geofences'] = geofences.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Geofences {
  Geofences({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.active,
    required this.name,
    required this.coordinates,
    required this.polygonColor,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.radius,
    this.center,
    this.deviceId,
  });
  late final int id;
  late final int userId;
  late final int groupId;
  late final int active;
  late final String name;
  late final String coordinates;
  late final String polygonColor;
  late final String createdAt;
  late final String updatedAt;
  late final String type;
  late final double? radius;
  late final Center? center;
  late final Null deviceId;

  Geofences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    groupId = json['group_id'];
    active = json['active'];
    name = json['name'];
    coordinates = json['coordinates'];
    polygonColor = json['polygon_color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    radius = null;
    center = null;
    deviceId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['group_id'] = groupId;
    _data['active'] = active;
    _data['name'] = name;
    _data['coordinates'] = coordinates;
    _data['polygon_color'] = polygonColor;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['type'] = type;
    _data['radius'] = radius;
    _data['center'] = center;
    _data['device_id'] = deviceId;
    return _data;
  }
}

class Center {
  Center({
    required this.lat,
    required this.lng,
  });
  late final double? lat;
  late final double? lng;

  Center.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}
