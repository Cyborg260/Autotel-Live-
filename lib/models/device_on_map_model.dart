import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class DeviceOnMapintialData {
  int? groupID;
  int? itemID;
  double? intialLat;
  double? intiallng;
  double? intialdirection;
  int? deviceId;
  BitmapDescriptor? markerImage;
  DeviceOnMapintialData(
      {this.groupID,
      this.itemID,
      this.intialLat,
      this.intiallng,
      this.intialdirection,
      this.deviceId,
      this.markerImage});
}
