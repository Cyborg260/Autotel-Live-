import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:trackerapp/models/playbackrout.dart';

class TripsRoutModel {
  dynamic status;
  int? routIndex;
  String? tripStart;
  String? tripEnd;
  dynamic distance;
  dynamic topSpeed;
  dynamic avgSpeed;
  String? totalTripDuration;
  List<PlayBackRoute> tripPlayBackRout = [];
  List<LatLng> tripRoutLatLng = [];
}
