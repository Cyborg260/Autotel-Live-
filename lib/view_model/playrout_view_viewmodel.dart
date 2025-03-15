import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/device_history_model.dart';
import 'package:trackerapp/models/playbackrout.dart';
import 'package:trackerapp/models/track_play_rout_model.dart';
import 'package:trackerapp/view_model/osmaddress_view_view_model.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

import 'package:trackerapp/repository/device_history_repository.dart';

class PlayRoutOnMapViewModel with ChangeNotifier {
  final DeviceHistoryRepository _historyRepository = DeviceHistoryRepository();
  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  OsmAddressViewModel osmAddressViewModel = OsmAddressViewModel();
  ApiResponse<DeviceHistoryModel> deviceRoutHistoryResponse =
      ApiResponse.loading();
  List<Marker> mapMarkers = [];
  List<LatLng> polyLatLng = [];
  List<LatLng> tripsLatLng = [];
  List<LatLng> parkedLatLngs = [];
  List<LatLng> eventsLatLngs = [];
  List<int> playBackTimeSpeed = [800, 600, 400, 200]; //in milliseconds
  int selectedPlayBackSpeed = 0;

  List<PlayBackRoute> routeList = [];
  List<PlayBackRoute> tripsPlayBackList = [];
  List<TripsRoutModel> tripsList = [];
  BitmapDescriptor startIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor parkingIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor eventsIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;
  var carIconPath = "assets/images/car_icon6.png";
  int sliderValueMax = 0;
  int currentSliderValue = 0;
  int tripCount = 0;
  int stopCount = 0;
  int routIndex = 0;
  late DateTime previousDate;
  double intermidateDistance = 0;
  double tripIntermidateDistance = 0;
  String deviceName = '';

  void resetalllistData() {
    mapMarkers.clear();
    polyLatLng.clear();
    parkedLatLngs.clear();
    eventsLatLngs.clear();
    routeList.clear();
    tripsPlayBackList.clear();
    currentSliderValue = 0;
    sliderValueMax = 0;
    intermidateDistance = 0;
    tripIntermidateDistance = 0;
    selectedPlayBackSpeed = 0;
  }

  final Set<Polyline> routPolyLine = {};
  setPlayBackSpeed() {
    if (selectedPlayBackSpeed < 3) {
      selectedPlayBackSpeed++;
    } else if (selectedPlayBackSpeed == 3) {
      selectedPlayBackSpeed = 0;
    }

    notifyListeners();
  }

  playUsingSlider(int sliderValue) {
    currentSliderValue = sliderValue;
    // print('Current Slider Value is ' + currentSliderValue.toString());
    var m = mapMarkers.firstWhere((p) => p.markerId == const MarkerId("0"));
    mapMarkers.remove(m);
    mapMarkers.add(
      Marker(
        markerId: const MarkerId('0'),
        position: LatLng(
            double.parse(routeList[currentSliderValue].latitude.toString()),
            double.parse(routeList[currentSliderValue].longitude.toString())),
        infoWindow: InfoWindow(title: currentSliderValue.toString()),
        icon: carIcon,
        rotation: double.parse(routeList[currentSliderValue].course.toString()),
      ),
    );

    notifyListeners();
  }

  setCompleteRoutPolyLineLatLng(List<LatLng> poltlatlng) {
    routPolyLine.add(
      Polyline(
          polylineId: const PolylineId('1'),
          points: poltlatlng,
          color: Colors.deepOrange,
          width: 2,
          zIndex: 0),
    );
    notifyListeners();
  }

  setSingleRoutPolyLineLatLng(List<LatLng> poltlatlng) {
    routPolyLine.add(
      Polyline(
          polylineId: const PolylineId('2'),
          points: poltlatlng,
          color: Colors.green,
          width: 6,
          startCap: Cap.buttCap,
          zIndex: 1),
    );
    notifyListeners();
  }

  void removeSingleRoutPolyLineLatLng() {
    routPolyLine.removeWhere((polyline) => polyline.polylineId.value == '2');
    // notifyListeners();
  }

  resetCompleteRoutPolyLineLatLng() {
    routPolyLine.clear();

    notifyListeners();
  }

  resetGoogleMap() {
    notifyListeners();
  }

  Future<String> getOSMAddress(lat, lng) async {
    Future<String> addressFromOSM =
        osmAddressViewModel.fetchOsmAddressAsString(lat, lng);
    String finalAddress = await addressFromOSM;
    return finalAddress;
  }

  setDeviceHistoryResponse(ApiResponse<DeviceHistoryModel> response) {
    deviceRoutHistoryResponse = response;
    notifyListeners();
  }

  setParkingPointsMarkers() async {
    var iconPath = "assets/images/stops.png";
    parkingIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32, 32)),
      iconPath,
    );
    for (var element in parkedLatLngs) {
      mapMarkers.add(
        Marker(
          markerId: MarkerId(('Parking ${element.latitude}').toString()),
          anchor: const Offset(0.5, 0.5),
          position: element,
          draggable: true,
          // rotation: double.parse(routeList[0].course),

          icon: parkingIcon,
        ),
      );
    }
  }

  setEventsPointsMarkers() async {
    var iconPath = "assets/images/alert.png";
    eventsIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(32, 32)),
      iconPath,
    );
    int i = 0;
    for (var element in eventsLatLngs) {
      i++;
      mapMarkers.add(
        Marker(
          markerId: MarkerId(('Events$i')),
          anchor: const Offset(0.5, 0.5),
          position: element,
          draggable: true,
          // rotation: double.parse(routeList[0].course),

          icon: eventsIcon,
        ),
      );
    }
  }

  setInitialCarMarker() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      carIconPath,
    );
    mapMarkers.add(
      Marker(
          markerId: const MarkerId('0'),
          anchor: const Offset(0.5, 0.5),
          position: LatLng(double.parse(routeList[0].latitude.toString()),
              double.parse(routeList[0].longitude.toString())),
          // updated position
          // rotation: double.parse(routeList[0].course),
          rotation: double.parse(routeList[0].course.toString()),
          draggable: true,
          icon: carIcon,
          infoWindow: const InfoWindow(title: 'Car')),
    );
  }

  setStartAndEndPointMarkers() async {
    var iconPath = "assets/images/start.png";
    var iconPathEnd = "assets/images/end.png";
    startIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(100, 100)),
      iconPath,
    );
    endIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(100, 100)),
      iconPathEnd,
    );
    mapMarkers.add(
      Marker(
        markerId: MarkerId((routeList.length + 2).toString()),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(double.parse(routeList[0].latitude.toString()),
            double.parse(routeList[0].longitude.toString())),
        // updated position
        // rotation: double.parse(routeList[0].course),
        draggable: true,
        icon: startIcon,
      ),
    );
    mapMarkers.add(
      Marker(
        markerId: MarkerId((routeList.length + 2).toString()),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(
            double.parse(routeList[routeList.length - 1].latitude.toString()),
            double.parse(routeList[routeList.length - 1].longitude.toString())),
        // updated position
        // rotation: double.parse(routeList[0].course),
        draggable: true,
        icon: endIcon,
      ),
    );

    // notifyListeners();
  }

  Future<void> fetchDeviceRoutHisotyFromApi(String deviceID, String fromDate,
      String toDate, String fromTime, String toTime) async {
    setDeviceHistoryResponse(ApiResponse.loading());
    resetalllistData();
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    String userApiKeyString = await userApiKey;

    String deviceHistoryDateTime =
        '&device_id=$deviceID&from_date=$fromDate&from_time=$fromTime&to_date=$toDate&to_time=$toTime';
    _historyRepository
        .deviceHistoryApi(userApiKeyString, deviceHistoryDateTime)
        .then((value) async {
      deviceName = value.device.name;
      for (var element in value.items) {
        if (element.status == 2) {
          tripsPlayBackList.clear();
          tripsLatLng.clear();
          TripsRoutModel newTrip = TripsRoutModel();
          newTrip.status = element.status;
          newTrip.totalTripDuration = element.time;
          newTrip.tripStart = element.show;
          newTrip.tripEnd = element.left;
          newTrip.distance = element.distance;
          newTrip.topSpeed = element.topSpeed;
          newTrip.avgSpeed = element.avgSpeed;

          element.statusItems.forEach((elementInStatus) async {
            if (elementInStatus['latitude'] != null &&
                elementInStatus['longitude'] != null) {
              PlayBackRoute tripsPlayBackListRout = PlayBackRoute();

              tripsPlayBackListRout.deviceId =
                  elementInStatus['device_id'].toString();
              tripsPlayBackListRout.longitude =
                  elementInStatus['longitude'].toString();
              tripsPlayBackListRout.latitude =
                  elementInStatus['latitude'].toString();
              tripsPlayBackListRout.speed = elementInStatus['speed'];
              tripsPlayBackListRout.course =
                  elementInStatus['course'].toString();
              tripsPlayBackListRout.rawTime =
                  elementInStatus['raw_time'].toString();
              tripsPlayBackListRout.time = elementInStatus['time'].toString();
              tripsLatLng.add(LatLng(
                  double.parse(elementInStatus['latitude'].toString()),
                  double.parse(elementInStatus['longitude'].toString())));
              previousDate =
                  DateTime.parse(elementInStatus['raw_time'].toString());
              tripsPlayBackListRout.distance =
                  tripIntermidateDistance.toString();

              tripsPlayBackList.add(tripsPlayBackListRout);

              tripIntermidateDistance =
                  tripIntermidateDistance + elementInStatus['distance'];
            }
          });
          newTrip.tripRoutLatLng = tripsLatLng.toList();
          newTrip.tripPlayBackRout = tripsPlayBackList.toList();
          print(
              'tripplayback length is stops ${newTrip.tripPlayBackRout.length}');
          tripsList.add(newTrip);
          stopCount++;
          //Add parkisng Positions in list when vehicle stops

          parkedLatLngs.add(LatLng(
              element.statusItems[0]['lat'], element.statusItems[0]['lng']));
        }
        if (element.status == 5) {
          //Add events Positions in list when vehicle stops
          eventsLatLngs.add(LatLng(
              double.parse(element.statusItems[0]['lat'].toString()),
              double.parse(element.statusItems[0]['lng'].toString())));
        }
        // Create Trip List
        if (element.status == 1) {
          tripsPlayBackList.clear();
          TripsRoutModel newTrip = TripsRoutModel();
          newTrip.status = element.status;
          newTrip.totalTripDuration = element.time;
          newTrip.tripStart = element.show;
          newTrip.tripEnd = element.left;
          newTrip.distance = element.distance;
          newTrip.topSpeed = element.topSpeed;
          newTrip.avgSpeed = element.avgSpeed;

          element.statusItems.forEach((elementInStatus) async {
            if (elementInStatus['latitude'] != null &&
                elementInStatus['longitude'] != null) {
              PlayBackRoute tripsPlayBackListRout = PlayBackRoute();

              tripsPlayBackListRout.deviceId =
                  elementInStatus['device_id'].toString();
              tripsPlayBackListRout.longitude =
                  elementInStatus['longitude'].toString();
              tripsPlayBackListRout.latitude =
                  elementInStatus['latitude'].toString();
              tripsPlayBackListRout.speed = elementInStatus['speed'];
              tripsPlayBackListRout.course =
                  elementInStatus['course'].toString();
              tripsPlayBackListRout.rawTime =
                  elementInStatus['raw_time'].toString();
              tripsLatLng.add(LatLng(
                  double.parse(elementInStatus['latitude'].toString()),
                  double.parse(elementInStatus['longitude'].toString())));
              tripsPlayBackListRout.time = elementInStatus['time'].toString();
              previousDate =
                  DateTime.parse(elementInStatus['raw_time'].toString());
              tripsPlayBackListRout.distance =
                  tripIntermidateDistance.toString();

              tripsPlayBackList.add(tripsPlayBackListRout);

              tripIntermidateDistance =
                  tripIntermidateDistance + elementInStatus['distance'];
            }
          });
          newTrip.tripRoutLatLng = tripsLatLng.toList();
          newTrip.tripPlayBackRout = tripsPlayBackList.toList();
          print(
              'tripplayback length is trips ${newTrip.tripPlayBackRout.length}');
          tripsList.add(newTrip);
          tripCount++;
        }
        // Create complete rout list
        element.statusItems.forEach((element) async {
          // Add polyline Coordinates
          if (element['latitude'] != null && element['longitude'] != null) {
            PlayBackRoute completePlayBackRout = PlayBackRoute();
            // address =
            //     await getOSMAddress(element['latitude'], element['longitude']);
            completePlayBackRout.deviceId = element['device_id'].toString();
            completePlayBackRout.longitude = element['longitude'].toString();
            completePlayBackRout.latitude = element['latitude'].toString();
            completePlayBackRout.speed = element['speed'];
            completePlayBackRout.course = element['course'].toString();
            completePlayBackRout.rawTime = element['raw_time'].toString();
            completePlayBackRout.time = element['time'].toString();
            previousDate = DateTime.parse(element['raw_time'].toString());
            completePlayBackRout.distance = intermidateDistance.toString();

            // Create Route list for Slider
            routeList.add(completePlayBackRout);
            polyLatLng.add(LatLng(double.parse(element['latitude'].toString()),
                double.parse(element['longitude'].toString())));
            intermidateDistance = intermidateDistance + element['distance'];
          }
        });
      }

      sliderValueMax = polyLatLng.length - 1;
      print('Total trips are $tripCount');
      print('Total routs are ${routeList.length}');
      print('Total events are ${eventsLatLngs.length}');
      print('Lat long Length is ${polyLatLng.length}');
      if (routeList.length > 0) {
        setInitialCarMarker();
        setCompleteRoutPolyLineLatLng(polyLatLng);
        setStartAndEndPointMarkers();
        setParkingPointsMarkers();
        //setEventsPointsMarkers();
      }

      setDeviceHistoryResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setDeviceHistoryResponse(ApiResponse.error(error.toString()));
      print('The error is $error');
    });
  }
}
