import 'dart:async';
import 'package:animated_marker/animated_marker.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/device_history_on_map.dart';
import 'package:trackerapp/models/device_on_map_model.dart';
import 'package:trackerapp/models/event_modle.dart';
import 'package:trackerapp/models/events_intitial_data.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';
import 'package:trackerapp/res/components/submitbutton.dart';
import 'package:trackerapp/res/helper/map_helper.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view/customehistory.dart';
import 'package:trackerapp/view/expenserecordscreen.dart';
import 'package:trackerapp/view_model/device_commands_view_model.dart';
import 'package:trackerapp/view_model/device_history_view_model.dart';
import 'package:trackerapp/view_model/device_view_viewmodel.dart';
import 'package:trackerapp/view_model/event_view_model.dart';
import 'package:trackerapp/view_model/osmaddress_view_view_model.dart';
import 'package:google_map_marker_animation/widgets/animarker.dart';
import 'package:trackerapp/view_model/send_command_model_view.dart';

late Color keyColor;
late Color batteruChargingColor;
late bool immobilizerValue;
late String immobilizerStatus;
late String batteryVoltage;
late String keyStatus;
late double? currentFuelCost;
double vehicleFuelAveragePerKm = 1.0;
late double totalFuelConsumed;

late double totalFuelCost;
final List<LatLng> _poluLatLng = [];

late double currentZoom;
List<Data> alertsList = [];

const kMarkerId = MarkerId('MarkerId1');
const kDuration = Duration(seconds: 5);
const kLocations = [];

class SingleDeviceOnMap extends StatefulWidget {
  final DeviceOnMapintialData? intialData;
  const SingleDeviceOnMap(
    this.intialData, {
    super.key,
  });

  int groupID() {
    return intialData!.groupID!.toInt();
  }

  @override
  State<SingleDeviceOnMap> createState() => _SingleDeviceOnMapState();
}

class _SingleDeviceOnMapState extends State<SingleDeviceOnMap> {
  final animationMarkers = <MarkerId, Marker>{};
  final animationController = Completer<GoogleMapController>();
  final zoomController = Completer<GoogleMapController>();
  late double latestLat = widget.intialData!.intialLat!;
  late double latestLng = widget.intialData!.intiallng!;
  final Completer<GoogleMapController> _completer = Completer();
  final PanelController panelController = PanelController();

  DeviceViewViewModel deviceonmapViewViewModel = DeviceViewViewModel();
  OsmAddressViewModel osmAddressViewModel = OsmAddressViewModel();
  DeviceHistoryViewModel deviceHistoryViewModel = DeviceHistoryViewModel();
  EventViewModel eventViewModel = EventViewModel();
  final List<Marker> _markers = [];

  final Set<Polyline> _polyLine = {};
  double currentZoom = 17.0;
  late String iconPathfromApi;
  late String vehicleStopTime;
  late String vehicleStopStartStatus;
  late int groupId;
  late int itemId;
  late double vehicleDirection;
  late Color mainBoxbgColor;
  late String vehicleStatus;
  late String iconColorFromApi;
  late String vehicleName = '';
  late String updateTime;
  late String vehcleSpeed;
  late BitmapDescriptor carIcon;
  late Color vehicleStatuscColor;
  late List<dynamic>? sensorsData = [];
  late String eventType = '';
  late String fromDate = '';
  late String toDate = '';
  late String pageNumber = '';

  late GoogleMapController myController;
  bool isMapLoaded = false;
  late GoogleMapController myController2;
  late double zoomlatestlat;
  late double zoomlatestlng;
  var dt = DateTime.now();
  var newFormat = DateFormat("yy-MM-dd");
  late String todayDate = newFormat.format(dt);
  final iconImage = "assets/images/car_icon6.png";
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';
  MapType currentMapType = MapType.normal;
  bool enableTraffic = false;
  int locationCounter = 0;
  int animationCounter = 0;
  LatLng previousLatLng = const LatLng(0.0, 0.0);

  Timer? _timer;

  setLocationCounter() {
    locationCounter = locationCounter + 1;
  }

  loadmyLocation(
      double lat, double lng, String vehiclename, double direction) async {
    BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;
    BitmapDescriptor markerImage = BitmapDescriptor.defaultMarker;
    markerImage = await MapHelper.getMarkerImageFromUrl(_markerImageUrl);
    // MarkerIcon.pictureAssetWithCenterText(
    //         assetPath: iconImage, text: vehiclename, size: Size(200, 100))
    //     .then((value) async {
    //   _markers.clear();

    //   _markers.add(Marker(
    //     markerId: const MarkerId('1'),
    //     position: LatLng(lat, lng),
    //     infoWindow: InfoWindow(title: vehiclename),
    //     icon: value,
    //     rotation: direction,
    //   ));
    //   CameraPosition myCameraPosition =
    //       CameraPosition(target: LatLng(lat, lng), zoom: 17);
    //   myController = await _completer.future;

    //   myController.animateCamera(
    //     CameraUpdate.newCameraPosition(myCameraPosition),
    //   );
    // });

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(50, 100)),
      iconImage,
    ).then((icon) async {
      myIcon = icon;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(_markers.length.toString()),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: vehiclename),
        icon: markerImage,
        rotation: direction,
      ));

      // CameraPosition myCameraPosition =
      //     CameraPosition(target: LatLng(lat, lng), zoom: currentZoom);

      // myController = await _completer.future;

      // myController.animateCamera(
      //   CameraUpdate.newCameraPosition(myCameraPosition),
      // );
    });
  }

  currentMapStatus(CameraPosition position) {
    currentZoom = position.zoom;
  }

  void newLocationUpdate(
      LatLng latLng, double direction, String iconPathFromAPI) async {
    final BitmapDescriptor markerImage = await MapHelper.getMarkerImageFromUrl(
        AppUrl.baseImgURL + iconPathFromAPI);
    var marker = Marker(
      markerId: kMarkerId,
      position: latLng,
      icon: markerImage,
      anchor: const Offset(0.5, .05),
      rotation: direction,
    );

    if (locationCounter != (_poluLatLng.length - 1)) {
      locationCounter = locationCounter + 1;
    }

    animationMarkers[kMarkerId] = marker;
  }

  Future<void> getVehicleFuelAveragePerKm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    vehicleFuelAveragePerKm =
        prefs.getDouble('fuelAverage_${widget.intialData!.deviceId}')!;
    currentFuelCost = prefs.getDouble('fuelPrice');
  }

  @override
  void initState() {
    super.initState();
    deviceonmapViewViewModel.getDeviceDataListFromApi();
    getVehicleFuelAveragePerKm();
    //print(widget.intialData!.direction!.toString());
    vehicleDirection = 0.0;
    vehicleDirection = widget.intialData!.intialdirection!;

    _poluLatLng.clear();
    batteruChargingColor = Colors.grey;
    keyStatus = 'N/A';
    immobilizerValue = false;
    immobilizerStatus = 'Immobiliser is not available';
    batteryVoltage = 'N/A';
    currentFuelCost = 249.5;
    keyColor = Colors.grey;
    zoomlatestlat = widget.intialData!.intialLat!;
    zoomlatestlng = widget.intialData!.intiallng!;

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(50, 100)),
      iconImage,
    ).then((value) {
      carIcon = value;
    });
    // MapHelper.getMarkerImageFromUrl(_markerImageUrl).then((neworkIcon) {
    //   //carIcon = neworkIcon;
    //   _markers.add(
    //     Marker(
    //       rotation: vehicleDirection,
    //       markerId: const MarkerId('1'),
    //       position: LatLng(widget.intialData!.intialLat!.toDouble(),
    //           widget.intialData!.intiallng!.toDouble()),
    //       infoWindow: const InfoWindow(title: 'Vehicle'),
    //       // icon: carIcon,
    //       //icon: value,
    //     ),
    //   );
    // });

    // int refreshTime = 1;
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      iconImage,
    ).then((value) {
      _markers.add(
        Marker(
          rotation: vehicleDirection,
          markerId: const MarkerId('1'),
          position: LatLng(widget.intialData!.intialLat!.toDouble(),
              widget.intialData!.intiallng!.toDouble()),
          infoWindow: const InfoWindow(title: 'Vehicle'),
          //icon: value,
        ),
      );
    });

    animationMarkers[kMarkerId] = Marker(
      markerId: kMarkerId,
      position: LatLng(widget.intialData!.intialLat!.toDouble(),
          widget.intialData!.intiallng!.toDouble()),
      icon: widget.intialData!.markerImage!,
      anchor: const Offset(0.5, .05),
      rotation: vehicleDirection,
    );
    // newLocationUpdate(
    //     LatLng(widget.intialData!.intialLat!.toDouble(),
    //         widget.intialData!.intiallng!.toDouble()),
    //     vehicleDirection,
    //     '/device_icons/63bd67980d27a6.70730526_ack.png');

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // refreshTime = 10;
      //print('Timer tick is ' + timer.tick.toString());
      deviceonmapViewViewModel.getDeviceDataListFromApi();

      eventViewModel.fetchEventsAlertsFromApi(
          widget.intialData!.deviceId.toString(),
          eventType,
          fromDate,
          toDate,
          pageNumber);
    });

    deviceHistoryViewModel.fetchTodayDeviceHisotyFromApi(
        widget.intialData!.deviceId.toString(), 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  deviceonmapViewViewModel.getDeviceDataListFromApi();
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(const Duration(milliseconds: 200));

        return true;
      },
      child: SafeArea(
        child: DecoratedBox(
          decoration: AppColors.appScreenBackgroundImage,
          child: Scaffold(
            //  backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Column(
                  children: [
                    ChangeNotifierProvider.value(
                      value: deviceonmapViewViewModel,
                      // create: (BuildContext context) => ,
                      child: Consumer<DeviceViewViewModel>(
                        builder: (context, value, child) {
                          switch (value.getDeviceModelListResponse.status!) {
                            case Status.LOADING:
                              return Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Image(
                                          image: AssetImage(
                                              'assets/images/loading.gif'),
                                          width: 100,
                                          height: 100),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Loading...')
                                    ],
                                  ),
                                ),
                              );
                            case Status.ERROR:
                              deviceonmapViewViewModel
                                  .getDeviceDataListFromApi();
                              return Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Image(
                                          image: AssetImage(
                                              'assets/images/loading.gif'),
                                          width: 100,
                                          height: 100),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(AppColors.errorMessage)
                                    ],
                                  ),
                                ),
                              );
                            case Status.COMPLETED:
                              // _poluLatLng.clear();

                              groupId = widget.intialData!.groupID!.toInt();
                              itemId = widget.intialData!.itemID!.toInt();
                              sensorsData = value.getDeviceModelListResponse
                                  .data![groupId].items![itemId]['sensors'];

                              if (sensorsData != null) {
                                if (sensorsData!.isNotEmpty) {
                                  for (var element in sensorsData!) {
                                    //print(element['name']);
                                    if (element['type']
                                            .toString()
                                            .toLowerCase() ==
                                        'battery') {
                                      batteryVoltage = element['value'];
                                    }
                                    if (element['name']
                                            .toString()
                                            .toLowerCase() ==
                                        'charging') {
                                      if (element['value']
                                              .toString()
                                              .toLowerCase() ==
                                          'on') {
                                        batteruChargingColor = Colors.green;
                                      } else if (element['value']
                                              .toString()
                                              .toLowerCase() ==
                                          'off') {
                                        batteruChargingColor = Colors.red;
                                      } else if (element['value']
                                                  .toString()
                                                  .toLowerCase() ==
                                              '' ||
                                          element['value']
                                                  .toString()
                                                  // ignore: unnecessary_null_comparison
                                                  .toLowerCase() ==
                                              null) {
                                        batteruChargingColor = Colors.grey;
                                      }
                                    }
                                    if (element['name'].toString().trim() ==
                                            'Immobiliser' ||
                                        element['name'].toString().trim() ==
                                            'Immobilizer') {
                                      //  print(element['name'] + ' ' + element['value']);
                                      if (element['value']
                                              .toString()
                                              .toLowerCase() ==
                                          'off') {
                                        immobilizerValue = false;
                                        immobilizerStatus =
                                            'Immobiliser is off';
                                      } else if (element['value']
                                              .toString()
                                              .toLowerCase() ==
                                          'on') {
                                        immobilizerValue = true;
                                        immobilizerStatus = 'Immobiliser is on';
                                      } else {
                                        immobilizerValue = false;
                                        immobilizerStatus =
                                            'Immobiliser is N/A';
                                      }
                                    }

                                    if (element['name'] == 'Ignition' ||
                                        element['name'] == 'IGNITION') {
                                      switch (element['value']) {
                                        case 'Off':
                                          keyColor = Colors.red;
                                          keyStatus = 'OFF';
                                          break;
                                        case 'On':
                                          keyColor = Colors.green;
                                          keyStatus = 'ON';
                                          break;
                                        default:
                                          keyColor = Colors.grey;
                                          keyStatus = 'N/A';
                                      }
                                    }
                                  }
                                }
                              }

                              // sensorsData!.forEach((element) {
                              //   print(element['name'] + '--' + element['value']);
                              // });

                              vehicleDirection = double.parse(value
                                  .getDeviceModelListResponse
                                  .data![groupId]
                                  .items![itemId]['course']
                                  .toString());

                              iconPathfromApi = value
                                  .getDeviceModelListResponse
                                  .data![groupId]
                                  .items![itemId]['icon']['path'];
                              vehicleName = value.getDeviceModelListResponse
                                  .data![groupId].items![itemId]['name'];
                              updateTime = value.getDeviceModelListResponse
                                  .data![groupId].items![itemId]['time'];
                              vehcleSpeed = value.getDeviceModelListResponse
                                  .data![groupId].items![itemId]['speed']
                                  .toString();
                              latestLat = value.getDeviceModelListResponse
                                      .data![groupId].items![itemId]['lat']
                                      .toDouble() ??
                                  0.0;
                              latestLng = value.getDeviceModelListResponse
                                      .data![groupId].items![itemId]['lng']
                                      .toDouble() ??
                                  0.0;
                              iconColorFromApi = value
                                  .getDeviceModelListResponse
                                  .data![groupId]
                                  .items![itemId]['icon_color'];
                              vehicleStopTime = value
                                  .getDeviceModelListResponse
                                  .data![groupId]
                                  .items![itemId]['stop_duration'];
                              List<dynamic> vehicleTail = value
                                  .getDeviceModelListResponse
                                  .data![groupId]
                                  .items![itemId]['tail'];

                              //Add polyline Latlng
                              if (_poluLatLng.isEmpty &&
                                  iconColorFromApi == 'green') {
                                for (var element in vehicleTail) {
                                  _poluLatLng.add(LatLng(
                                      double.parse(element['lat']),
                                      double.parse(element['lng'])));
                                }

                                previousLatLng = _poluLatLng.last;
                              } else {
                                LatLng currentLatLng = LatLng(
                                    double.parse(latestLat.toString()),
                                    double.parse(latestLng.toString()));

                                if (previousLatLng != currentLatLng) {
                                  // print(true);
                                  _poluLatLng.add(currentLatLng);
                                }
                                previousLatLng = currentLatLng;
                              }

                              _polyLine.add(
                                Polyline(
                                    polylineId: const PolylineId('1'),
                                    points: _poluLatLng,
                                    color: Colors.deepOrange,
                                    width: 4),
                              );

                              switch (iconColorFromApi) {
                                case 'red':
                                  mainBoxbgColor =
                                      const Color.fromARGB(220, 212, 2, 2);
                                  vehicleStatus = 'Stop';
                                  vehicleStopStartStatus = 'Stop since ';
                                  vehicleStatuscColor = Colors.white;
                                  break;

                                case 'green':
                                  mainBoxbgColor =
                                      const Color.fromARGB(220, 3, 95, 1);
                                  vehicleStatus = 'Driving';
                                  vehicleStopStartStatus = 'Running since ';
                                  vehicleStatuscColor = Colors.white;

                                  break;
                                case 'blue':
                                  mainBoxbgColor =
                                      const Color.fromARGB(220, 2, 79, 130);
                                  vehicleStatus = 'Offline';
                                  vehicleStopStartStatus = 'Stop since ';
                                  vehicleStatuscColor = Colors.white;
                                  break;
                                case 'yellow':
                                  mainBoxbgColor =
                                      const Color.fromARGB(220, 255, 187, 1);
                                  vehicleStatus = 'Idle';
                                  vehicleStopStartStatus = 'Stop since ';
                                  vehicleStatuscColor = Colors.black;

                                  break;
                                case 'black':
                                  mainBoxbgColor =
                                      const Color.fromARGB(220, 255, 187, 1);

                                  vehicleStatus = 'parked';
                                  vehicleStopStartStatus = 'Stop since ';
                                  vehicleStatuscColor = Colors.black;
                                  break;

                                default:
                                  mainBoxbgColor =
                                      const Color.fromARGB(244, 76, 77, 77);
                                  vehicleStatus = 'not connected or offline';
                                  vehicleStatuscColor = Colors.black87;
                              }
                              // if (locationCounter <= (_poluLatLng.length - 1)) {
                              //   newLocationUpdate(_poluLatLng[locationCounter],
                              //       vehicleDirection, iconPathfromApi);
                              // }
                              newLocationUpdate(LatLng(latestLat, latestLng),
                                  vehicleDirection, iconPathfromApi);

                              // CameraPosition cameraPosition = CameraPosition(
                              //     target: LatLng(latestLat, latestLng),
                              //     zoom: 15);
                              // if (isMapLoaded) {
                              //   myController.animateCamera(
                              //     CameraUpdate.newCameraPosition(
                              //         cameraPosition),
                              //   );
                              // }

                              Future.delayed(Duration.zero, () {
                                osmAddressViewModel.fetchOsmAddress(
                                    latestLat, latestLng);
                              });
                              return Expanded(
                                child: Stack(children: [
                                  AnimatedMarker(
                                      animatedMarkers: animationMarkers.values
                                          .toList()
                                          .toSet(),
                                      duration: const Duration(
                                          seconds:
                                              10), // change the animation duration
                                      fps:
                                          10, // change the animation frames per second
                                      curve: Curves
                                          .ease, // change the animation curve
                                      builder: (context, animatedMarkers) {
                                        return GoogleMap(
                                          buildingsEnabled: false,
                                          indoorViewEnabled: false,
                                          rotateGesturesEnabled: false,
                                          minMaxZoomPreference:
                                              const MinMaxZoomPreference(1, 21),
                                          mapType: currentMapType,
                                          trafficEnabled: enableTraffic,
                                          markers: animatedMarkers,
                                          zoomControlsEnabled: true,
                                          initialCameraPosition: CameraPosition(
                                              target:
                                                  LatLng(latestLat, latestLng),
                                              zoom: 15),
                                          onCameraMove: currentMapStatus,
                                          onMapCreated: (gController) {
                                            myController = gController;
                                            animationController
                                                .complete(gController);
                                            isMapLoaded = true;
                                          },
                                          padding: const EdgeInsets.only(
                                              bottom: 225),
                                          //Complete the future GoogleMapController
                                        );
                                      }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 120,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FloatingActionButton(
                                              heroTag: UniqueKey(),
                                              mini: true,
                                              backgroundColor:
                                                  AppColors.buttonColor,
                                              onPressed: () {
                                                currentMapType =
                                                    currentMapType ==
                                                            MapType.normal
                                                        ? MapType.hybrid
                                                        : MapType.normal;
                                                deviceonmapViewViewModel
                                                    .getDeviceDataListFromApi();
                                              },
                                              child: const Icon(
                                                Icons.map,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FloatingActionButton(
                                              heroTag: UniqueKey(),
                                              backgroundColor:
                                                  enableTraffic == false
                                                      ? AppColors.buttonColor
                                                      : Colors.green,
                                              mini: true,
                                              child: Icon(
                                                Icons.traffic,
                                                color: enableTraffic == false
                                                    ? Colors.black54
                                                    : Colors.white,
                                              ),
                                              onPressed: () {
                                                enableTraffic =
                                                    enableTraffic == false
                                                        ? true
                                                        : false;
                                                deviceonmapViewViewModel
                                                    .getDeviceDataListFromApi();
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FloatingActionButton(
                                              heroTag: UniqueKey(),
                                              backgroundColor:
                                                  AppColors.buttonColor,
                                              mini: true,
                                              child: const Icon(
                                                  Icons.streetview,
                                                  color: Colors.black54),
                                              onPressed: () {
                                                MapsLauncher.launchCoordinates(
                                                    latestLat, latestLng);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FloatingActionButton(
                                              heroTag: UniqueKey(),
                                              backgroundColor:
                                                  AppColors.buttonColor,
                                              mini: true,
                                              child: const Icon(Icons.share,
                                                  color: Colors.black54),
                                              onPressed: () {
                                                Share.share(
                                                    'https://www.google.com/maps/search/?api=1&map_action=pano&query=$latestLat,$latestLng');
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FloatingActionButton(
                                              heroTag: UniqueKey(),
                                              mini: true,
                                              backgroundColor:
                                                  AppColors.buttonColor,
                                              onPressed: () async {
                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 300));
                                                Navigator.of(context).pop();
                                              },
                                              child:
                                                  const Icon(Icons.arrow_back),
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   height: 60,
                                          // ),
                                          // Padding(
                                          //   padding: const EdgeInsets.all(5.0),
                                          //   child: FloatingActionButton(
                                          //     heroTag: UniqueKey(),
                                          //     backgroundColor: Colors.white,
                                          //     mini: true,
                                          //     child: const Icon(
                                          //       Icons.zoom_in,
                                          //       color: Colors.black54,
                                          //       size: 30,
                                          //     ),
                                          //     onPressed: () async {
                                          //       if (currentZoom < 21) {
                                          //         currentZoom = currentZoom + 1;
                                          //         CameraPosition myCameraPosition =
                                          //             CameraPosition(
                                          //                 target: LatLng(
                                          //                     zoomlatestlat,
                                          //                     zoomlatestlng),
                                          //                 zoom: currentZoom);

                                          //         myController2 =
                                          //             await animationController
                                          //                 .future;

                                          //         myController2.animateCamera(
                                          //           CameraUpdate.newCameraPosition(
                                          //               myCameraPosition),
                                          //         );
                                          //       }
                                          //       deviceonmapViewViewModel
                                          //           .getDeviceDataListFromApi();
                                          //     },
                                          //   ),
                                          // ),
                                          // Padding(
                                          //   padding: const EdgeInsets.all(5.0),
                                          //   child: FloatingActionButton(
                                          //     heroTag: UniqueKey(),
                                          //     backgroundColor: Colors.white,
                                          //     mini: true,
                                          //     child: const Icon(
                                          //       Icons.zoom_out,
                                          //       color: Colors.black54,
                                          //       size: 30,
                                          //     ),
                                          //     onPressed: () async {
                                          //       if (currentZoom >= 1) {
                                          //         currentZoom = currentZoom - 1;
                                          //         CameraPosition myCameraPosition =
                                          //             CameraPosition(
                                          //                 target: LatLng(
                                          //                     zoomlatestlat,
                                          //                     zoomlatestlng),
                                          //                 zoom: currentZoom);

                                          //         myController2 =
                                          //             await animationController
                                          //                 .future;

                                          //         myController2.animateCamera(
                                          //           CameraUpdate.newCameraPosition(
                                          //               myCameraPosition),
                                          //         );
                                          //       }
                                          //       deviceonmapViewViewModel
                                          //           .getDeviceDataListFromApi();
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // SlidingUpPanel(
                                  //   minHeight:
                                  //       MediaQuery.of(context).size.height * 0.25,
                                  //   controller: panelController,
                                  //   maxHeight:
                                  //       MediaQuery.of(context).size.height * 0.85,
                                  //   borderRadius: const BorderRadius.only(
                                  //     topLeft: Radius.circular(15.0),
                                  //     topRight: Radius.circular(15.0),
                                  //   ),
                                  //   padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  //   color: const Color.fromARGB(166, 255, 255, 255),
                                  //   panelBuilder: (ScrollController sc) =>
                                  //       _scrollingList(
                                  //           sc,
                                  //           vehicleName,
                                  //           latestLat,
                                  //           latestLng,
                                  //           context,
                                  //           panelController,
                                  //           osmAddressViewModel,
                                  //           deviceHistoryViewModel,
                                  //           eventViewModel,
                                  //           widget.intialData!,
                                  //           sensorsData),
                                  // ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: mainBoxbgColor,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          //border: Border.all(width: 6, color: Colors.red),
                                        ),
                                        height: 70,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black,
                                                    radius: 24.4,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 23,
                                                      child: Image(
                                                        fit: BoxFit.contain,
                                                        image: NetworkImage(
                                                            AppUrl.baseImgURL +
                                                                iconPathfromApi),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    vehicleName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color:
                                                            vehicleStatuscColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      updateTime,
                                                      style: TextStyle(
                                                          color:
                                                              vehicleStatuscColor,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ]),
                                                  Row(children: [
                                                    Text(
                                                      '$vehicleStopStartStatus$vehicleStopTime',
                                                      style: TextStyle(
                                                          color:
                                                              vehicleStatuscColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    vehcleSpeed,
                                                    style: TextStyle(
                                                        color:
                                                            vehicleStatuscColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'km/h',
                                                    style: TextStyle(
                                                        color:
                                                            vehicleStatuscColor,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Text(
                                                    vehicleStatus,
                                                    style: TextStyle(
                                                        color:
                                                            vehicleStatuscColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              );
                            default:
                          }
                          return Container();
                        },
                      ),
                    )
                  ],
                ),
                SlidingUpPanel(
                  minHeight: MediaQuery.of(context).size.height * 0.25,
                  controller: panelController,
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                  color: const Color.fromARGB(166, 255, 255, 255),
                  panelBuilder: (ScrollController sc) => _scrollingList(
                      sc,
                      vehicleName,
                      latestLat,
                      latestLng,
                      context,
                      panelController,
                      deviceonmapViewViewModel,
                      osmAddressViewModel,
                      deviceHistoryViewModel,
                      eventViewModel,
                      widget.intialData!,
                      sensorsData),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _scrollingList(
    ScrollController sc,
    String deviceTitle,
    double latestLat,
    double latestLng,
    BuildContext context,
    PanelController panelController,
    DeviceViewViewModel deviceonmapViewViewModel,
    OsmAddressViewModel osmAddressViewModel,
    DeviceHistoryViewModel deviceHistoryViewModel,
    EventViewModel eventViewModel,
    DeviceOnMapintialData initialData,
    List<dynamic>? sensorsData) {
  // Future.delayed(Duration.zero, () {
  //   deviceonmapViewViewModel.getDeviceDataFromApi();
  // });

  // DeviceCommandsViewModel commandsViewModel = DeviceCommandsViewModel();
  Future<void> setFuelVehicleAveragePerKM(
      BuildContext context, DeviceOnMapintialData initialData) {
    final fuelPriceController = TextEditingController();
    FocusNode fuelFocusNode = FocusNode();
    return showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Set Vehicle Fuel Average'),
                        InkWell(
                          child: const Icon(Icons.close),
                          onTap: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: fuelPriceController,
                      focusNode: fuelFocusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Set Fuel Average(km/l)",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: Color(0xfff2f2f3),
                        isDense: false,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        prefixIcon: Icon(
                          Icons.price_change_outlined,
                          color: Color(0xff212435),
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SubmitButton(
                      title: 'Set Fuel Average',
                      onPresse: () async {
                        if (double.parse(fuelPriceController.text) < 1 ||
                            double.parse(fuelPriceController.text) > 50) {
                          Utils.toastMessage(
                              'Please enter value from 1 to 50 range');
                          fuelPriceController.clear();
                          fuelFocusNode.requestFocus();
                          return;
                        }
                        final SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setDouble('fuelAverage_${initialData.deviceId}',
                            double.parse(fuelPriceController.text));
                        print('Fuel set fuelAverage_${initialData.deviceId} ' +
                            fuelPriceController.text);
                        // getSharedPreferenceInstance();
                        Utils.toastMessage(
                            'Fuel average set.Go back and refresh');
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDatePickerDialog(BuildContext context, String screenRout) {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomeHistoryDateTimePicker(initialData.deviceId!, screenRout),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAddExpenseForm(
      BuildContext context, String vehicleID, String vehicleName) {
    return showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) => AddExpenseScreen(
        vehicleId: vehicleID, // Replace with the actual vehicle ID
        vehicleName: vehicleName, // Replace with the actual vehicle name
      ),
    );
  }

  Future<void> showCommandListPicker(
      BuildContext context, String deviceID) async {
    // commandsViewModel
    //     .getDeviceCommandListFromApi(initialData.deviceId.toString());

    await context
        .read<DeviceCommandsViewModel>()
        .getDeviceCommandListFromApi(initialData.deviceId.toString());

    SendDeviceCommandViewModel sendDeviceCommandViewModel =
        SendDeviceCommandViewModel();
    int groupValue = 1;
    String deviceCommand = 'No Command';
    return showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          child: Column(
            //  mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Select a command'),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              Consumer<DeviceCommandsViewModel>(
                // create: (BuildContext deviceCommandsContext) =>
                //     commandsViewModel,
                // child: Consumer<DeviceCommandsViewModel>(
                builder: (context, deviceCommandsvalue, child) {
                  switch (deviceCommandsvalue
                      .getDeviceCommandsListResponse.status) {
                    case Status.LOADING:
                      return const CircularProgressIndicator();
                    case Status.ERROR:
                      return const Text('Error');
                    case Status.COMPLETED:
                      for (var element in deviceCommandsvalue
                          .getDeviceCommandsListResponse.data!) {
                        if (element.attributes != null) {
                          for (var att in element.attributes!) {
                            print(att.realCommand);
                          }
                        }
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: deviceCommandsvalue
                            .getDeviceCommandsListResponse.data!.length,
                        itemBuilder: (commandsContext, commandIndex) {
                          if (deviceCommandsvalue.getDeviceCommandsListResponse
                                      .data![commandIndex].type
                                      .toString() ==
                                  'custom' ||
                              deviceCommandsvalue.getDeviceCommandsListResponse
                                      .data![commandIndex].type
                                      .toString() ==
                                  'engineResume' ||
                              deviceCommandsvalue.getDeviceCommandsListResponse
                                      .data![commandIndex].type
                                      .toString() ==
                                  'engineStop') {
                            return Container();
                          }
                          return ListTile(
                            title: Text(
                              deviceCommandsvalue.getDeviceCommandsListResponse
                                  .data![commandIndex].title
                                  .toString(),
                              style: AppColors.settingTextstyle,
                            ),
                            trailing: SizedBox(
                              height: 25,
                              width: 25,
                              child: GFRadio(
                                size: 25,
                                activeBorderColor: GFColors.FOCUS,
                                value: commandIndex,
                                groupValue: groupValue,
                                onChanged: (value) async {
                                  print(value);
                                  groupValue = value;
                                  deviceCommand = deviceCommandsvalue
                                      .getDeviceCommandsListResponse
                                      .data![commandIndex]
                                      .type
                                      .toString();
                                  print('Device Command is $deviceCommand');
                                  await context
                                      .read<DeviceCommandsViewModel>()
                                      .setCmmadSelection();
                                },
                                inactiveIcon: null,
                                radioColor: AppColors.buttonColor,
                              ),
                            ),
                          );
                        },
                      );

                    default:
                  }
                  return Container();
                },
                // ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GFButton(
                    onPressed: () async {
                      Utils.toastMessage('Sending Command');
                      sendDeviceCommandViewModel
                          .sendDeviceCommandToApi(
                              deviceCommand, initialData.deviceId.toString())
                          .then((value) {
                        Navigator.pop(context);
                      });
                    },
                    text: 'Send Command',
                    textStyle: AppColors.settingPageButtonTextStyle,
                    color: AppColors.buttonColor,
                    shape: GFButtonShape.pills,
                    size: 30,
                  ),
                  GFButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'Cancel',
                    textStyle: AppColors.settingPageButtonTextStyle,
                    color: AppColors.buttonColor,
                    shape: GFButtonShape.pills,
                    size: 30,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Note: Commands take some time to be implement.'),
              )
            ],
          ),
        ),
      ),
    );
  }

  return ListView(
    controller: sc,
    children: [
      GestureDetector(
        child: Center(
          child: Container(
            height: 5,
            width: 30,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        onTap: () {
          if (panelController.isPanelOpen) {
            panelController.close();
          } else {
            panelController.open();
          }
        },
      ),
      Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 30,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                //border: Border.all(width: 6, color: Colors.red),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    color: Color.fromARGB(255, 155, 150, 150),
                    offset: Offset.zero,
                    blurStyle: BlurStyle.normal,
                  ),
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GFButton(
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      icon: Icon(Icons.key, color: keyColor),
                      //iconSize: 18,
                      text: keyStatus,
                      textColor: Colors.black54,
                      size: GFSize.SMALL,
                      shape: GFButtonShape.pills,
                      color: Colors.black12,
                    ),
                    GFIconButton(
                      onPressed: () {},
                      padding: const EdgeInsets.all(4),
                      icon: Icon(
                        Icons.battery_charging_full_outlined,
                        color: batteruChargingColor,
                      ),
                      iconSize: 20,
                      color: Colors.black12,
                      shape: GFIconButtonShape.circle,
                    ),
                    GFIconButton(
                      onPressed: () {},
                      padding: const EdgeInsets.all(4),
                      icon: const Icon(
                        Icons.wifi,
                        color: Colors.green,
                      ),
                      iconSize: 20,
                      color: Colors.black12,
                      shape: GFIconButtonShape.circle,
                    ),
                    GFIconButton(
                      onPressed: () {},
                      padding: const EdgeInsets.all(4),
                      icon: immobilizerValue
                          ? const Icon(
                              Icons.lock,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.lock_open,
                              color: Colors.green,
                            ),
                      iconSize: 20,
                      color: Colors.black12,
                      shape: GFIconButtonShape.circle,
                    ),
                    GFButton(
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      icon:
                          const Icon(Icons.battery_5_bar, color: Colors.green),
                      //iconSize: 18,
                      text: batteryVoltage,
                      textColor: Colors.black54,
                      size: GFSize.SMALL,
                      shape: GFButtonShape.pills,
                      color: Colors.black12,
                    ),
                  ],
                ),
                const Divider(
                  height: 5,
                ),
                GFTypography(
                  text: 'Current Nearest Location',
                  type: AppColors.deviceOnMapSligePanelHeading,
                  icon:
                      Icon(Icons.location_on_outlined, color: Colors.blue[800]),
                  showDivider: false,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.blue[800],
                ),
                const Divider(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ChangeNotifierProvider.value(
                            value: osmAddressViewModel,
                            //create: (BuildContext addresscontext) =>

                            child: Consumer<OsmAddressViewModel>(
                              builder: (addresscontext, value, child) {
                                switch (value.osmAddressResponse.status!) {
                                  case Status.LOADING:
                                    return const Text('Loading');
                                  case Status.ERROR:
                                    return const Text(
                                        'Error while fetching address');
                                  case Status.COMPLETED:
                                    final displayName = value
                                            .osmAddressResponse
                                            .data
                                            ?.features?[0]
                                            .properties
                                            ?.displayName
                                            ?.toString() ??
                                        'Unknown Address';
                                    return Text(
                                      displayName,
                                      textAlign: TextAlign.center,
                                    );

                                  default:
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 30,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                //border: Border.all(width: 6, color: Colors.red),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    color: Color.fromARGB(255, 155, 150, 150),
                    offset: Offset.zero,
                    blurStyle: BlurStyle.normal,
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: GFTypography(
                          text: 'Travel Summary',
                          type: AppColors.deviceOnMapSligePanelHeading,
                          icon: Icon(
                            Icons.travel_explore_outlined,
                            color: Colors.blue[800],
                          ),
                          showDivider: false,
                          textColor: Colors.blue[800],
                          fontWeight: FontWeight.bold,

                          //textColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      shape: ContinuousRectangleBorder(
                        borderRadius: AppColors.popupmenuborder,
                      ),
                      onSelected: ((value) {
                        switch (value) {
                          case 0:
                            deviceHistoryViewModel
                                .fetchTodayDeviceHisotyFromApi(
                                    initialData.deviceId!.toString(), 0);
                            break;

                          case 1:
                            deviceHistoryViewModel
                                .fetchTodayDeviceHisotyFromApi(
                                    initialData.deviceId!.toString(), 1);
                            break;
                          case 7:
                            deviceHistoryViewModel
                                .fetchTodayDeviceHisotyFromApi(
                                    initialData.deviceId!.toString(), 7);
                            break;
                          case 30:
                            deviceHistoryViewModel
                                .fetchTodayDeviceHisotyFromApi(
                                    initialData.deviceId!.toString(), 30);
                            break;

                          default:
                        }
                      }),
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                            value: 0,
                            child: Text('Today'),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text('yesterday'),
                          ),
                          PopupMenuItem(
                            value: 7,
                            child: Text('7 Days'),
                          ),
                          PopupMenuItem(
                            value: 30,
                            child: Text('30 Days'),
                          ),
                        ];
                      },
                    )
                  ],
                ),

                const Divider(
                  height: 0,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     GFButton(
                //       padding: const EdgeInsets.symmetric(horizontal: 4),
                //       onPressed: () {
                //         deviceHistoryViewModel.fetchTodayDeviceHisotyFromApi(
                //             initialData.deviceId!.toString(), 0);
                //       },
                //       text: "Today",
                //       shape: GFButtonShape.pills,
                //       size: 30,
                //       textColor: Colors.black54,
                //       color: Colors.black12,
                //     ),
                //     GFButton(
                //       padding: const EdgeInsets.symmetric(horizontal: 4),
                //       onPressed: () {
                //         deviceHistoryViewModel.fetchTodayDeviceHisotyFromApi(
                //             initialData.deviceId!.toString(), 1);
                //       },
                //       text: 'Yesterday',
                //       shape: GFButtonShape.pills,
                //       size: 30,
                //       textColor: Colors.black54,
                //       color: Colors.black12,
                //     ),
                //     GFButton(
                //       padding: const EdgeInsets.symmetric(horizontal: 4),
                //       onPressed: () {
                //         deviceHistoryViewModel.fetchTodayDeviceHisotyFromApi(
                //             initialData.deviceId!.toString(), 7);
                //       },
                //       text: '7 Day',
                //       shape: GFButtonShape.pills,
                //       size: 30,
                //       textColor: Colors.black54,
                //       color: Colors.black12,
                //     ),
                //     GFButton(
                //       padding: const EdgeInsets.symmetric(horizontal: 4),
                //       onPressed: () {
                //         deviceHistoryViewModel.fetchTodayDeviceHisotyFromApi(
                //             initialData.deviceId!.toString(), 30);
                //       },
                //       text: '30 Days',
                //       shape: GFButtonShape.pills,
                //       size: 30,
                //       textColor: Colors.black54,
                //       color: Colors.black12,
                //     ),
                //   ],
                // ),
                // const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChangeNotifierProvider.value(
                              value: deviceHistoryViewModel,
                              //create: (BuildContext devicehistorycontext) =>

                              child: Consumer<DeviceHistoryViewModel>(
                                builder: (devicehistorycontext, value, child) {
                                  switch (value.deviceHistoryResponse.status!) {
                                    case Status.LOADING:
                                      return const Text('Loading..');
                                    case Status.ERROR:
                                      return const Text(
                                          'Error while fetching history');
                                    case Status.COMPLETED:
                                      var arr = value.deviceHistoryResponse
                                          .data!.distanceSum
                                          .split(' ');

                                      totalFuelConsumed = double.parse(arr[0]) /
                                          vehicleFuelAveragePerKm;

                                      totalFuelCost =
                                          totalFuelConsumed * currentFuelCost!;

                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            child: Text(
                                              value.summarStatment,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: const [
                                                          Text(
                                                            'Fuel Used',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              '${double.parse((totalFuelConsumed).toStringAsFixed(2))} liters')
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: const [
                                                          Text(
                                                            'Fuel Cost',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              'Rs.${double.parse((totalFuelCost).toStringAsFixed(2))}'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Running Time',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            value
                                                                .deviceHistoryResponse
                                                                .data!
                                                                .moveDuration
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Stop Time',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .red[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(value
                                                              .deviceHistoryResponse
                                                              .data!
                                                              .stopDuration
                                                              .toString()),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );

                                    default:
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
      Container(
          width: MediaQuery.of(context).size.width - 30,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            // border: Border.all(
            //     width: 6, color: Colors.red),
            boxShadow: const [
              BoxShadow(
                blurRadius: 1,
                color: Color.fromARGB(255, 155, 150, 150),
                offset: Offset.zero,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: PopupMenuButton(
                  shape: ContinuousRectangleBorder(
                    borderRadius: AppColors.popupmenuborder,
                  ),
                  onSelected: ((value) {
                    String toDate;
                    String fromDate;
                    String fromTime = '00:00:01';
                    String toTime = '23:59:00';
                    DateTime dt;
                    DateFormat newFormat;
                    dt = DateTime.now();
                    newFormat = DateFormat("yy-MM-dd");
                    toDate = newFormat.format(dt);
                    switch (value) {
                      case 0:
                        toDate = newFormat.format(dt);
                        fromDate = newFormat.format(dt);
                        Navigator.pushNamed(
                          context,
                          RoutesName.playroutonmap,
                          arguments: DeviceHistoryOnMapIntialData(
                              deviceTitle: deviceTitle,
                              deviceId: initialData.deviceId,
                              fromDate: fromDate,
                              toDate: toDate,
                              fromTime: fromTime,
                              toTime: toTime),
                        );
                        break;

                      case 1:
                        toDate = newFormat
                            .format(dt.subtract(const Duration(days: 1)));
                        fromDate = newFormat
                            .format(dt.subtract(const Duration(days: 1)));
                        Navigator.pushNamed(
                          context,
                          RoutesName.playroutonmap,
                          arguments: DeviceHistoryOnMapIntialData(
                              deviceTitle: deviceTitle,
                              deviceId: initialData.deviceId,
                              fromDate: fromDate,
                              toDate: toDate,
                              fromTime: fromTime,
                              toTime: toTime),
                        );
                        break;
                      case 7:
                        toDate = newFormat.format(dt);
                        fromDate = newFormat
                            .format(dt.subtract(const Duration(days: 7)));
                        Navigator.pushNamed(
                          context,
                          RoutesName.playroutonmap,
                          arguments: DeviceHistoryOnMapIntialData(
                              deviceTitle: deviceTitle,
                              deviceId: initialData.deviceId,
                              fromDate: fromDate,
                              toDate: toDate,
                              fromTime: fromTime,
                              toTime: toTime),
                        );
                        break;
                      case 30:
                        toDate = newFormat.format(dt);
                        fromDate = newFormat
                            .format(dt.subtract(const Duration(days: 30)));
                        Navigator.pushNamed(
                          context,
                          RoutesName.playroutonmap,
                          arguments: DeviceHistoryOnMapIntialData(
                              deviceTitle: deviceTitle,
                              deviceId: initialData.deviceId,
                              fromDate: fromDate,
                              toDate: toDate,
                              fromTime: fromTime,
                              toTime: toTime),
                        );
                        break;
                      case 2:
                        showDatePickerDialog(context, 'playroutonmap');
                        break;

                      default:
                        toDate = newFormat.format(dt);
                        fromDate = newFormat.format(dt);
                        Navigator.pushNamed(
                          context,
                          RoutesName.playroutonmap,
                          arguments: DeviceHistoryOnMapIntialData(
                              deviceTitle: deviceTitle,
                              deviceId: initialData.deviceId,
                              fromDate: fromDate,
                              toDate: toDate,
                              fromTime: fromTime,
                              toTime: toTime),
                        );
                    }
                  }),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 93, 161, 245),
                          Color.fromARGB(255, 2, 107, 244),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.history,
                            color: Colors.white,
                            size: 30,
                          ),
                          VerticalDivider(),
                          Text(
                            'View\nHistory',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                  itemBuilder: (BuildContext bc) {
                    return const [
                      PopupMenuItem(
                        value: 0,
                        child: Text('Today'),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('yesterday'),
                      ),
                      PopupMenuItem(
                        value: 7,
                        child: Text('7 Days'),
                      ),
                      PopupMenuItem(
                        value: 30,
                        child: Text('30 Days'),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text('Custom Date'),
                      ),
                    ];
                  },
                ),
              ),
              Expanded(
                child: PopupMenuButton(
                    shape: ContinuousRectangleBorder(
                      borderRadius: AppColors.popupmenuborder,
                    ),
                    onSelected: ((value) {
                      String toDate;
                      String fromDate;
                      String fromTime = '00:00:01';
                      String toTime = '23:59:00';
                      DateTime dt;
                      DateFormat newFormat;
                      dt = DateTime.now();
                      newFormat = DateFormat("yy-MM-dd");
                      toDate = newFormat.format(dt);
                      switch (value) {
                        case 0:
                          toDate = newFormat.format(dt);
                          fromDate = newFormat.format(dt);
                          toDate =
                              newFormat.format(dt.add(const Duration(days: 1)));
                          Navigator.pushNamed(
                            context,
                            RoutesName.reporttype,
                            arguments: DeviceHistoryOnMapIntialData(
                                deviceTitle: deviceTitle,
                                deviceId: initialData.deviceId,
                                fromDate: fromDate,
                                toDate: toDate,
                                fromTime: fromTime,
                                toTime: toTime),
                          );
                          break;

                        case 1:
                          fromDate = newFormat
                              .format(dt.subtract(const Duration(days: 1)));
                          toDate = newFormat.format(dt);
                          Navigator.pushNamed(
                            context,
                            RoutesName.reporttype,
                            arguments: DeviceHistoryOnMapIntialData(
                                deviceTitle: deviceTitle,
                                deviceId: initialData.deviceId,
                                fromDate: fromDate,
                                toDate: toDate,
                                fromTime: fromTime,
                                toTime: toTime),
                          );
                          break;
                        case 7:
                          toDate = newFormat.format(dt);
                          fromDate = newFormat
                              .format(dt.subtract(const Duration(days: 7)));
                          Navigator.pushNamed(
                            context,
                            RoutesName.reporttype,
                            arguments: DeviceHistoryOnMapIntialData(
                                deviceTitle: deviceTitle,
                                deviceId: initialData.deviceId,
                                fromDate: fromDate,
                                toDate: toDate,
                                fromTime: fromTime,
                                toTime: toTime),
                          );
                          break;
                        case 30:
                          toDate = newFormat.format(dt);
                          fromDate = newFormat
                              .format(dt.subtract(const Duration(days: 30)));
                          Navigator.pushNamed(
                            context,
                            RoutesName.reporttype,
                            arguments: DeviceHistoryOnMapIntialData(
                                deviceTitle: deviceTitle,
                                deviceId: initialData.deviceId,
                                fromDate: fromDate,
                                toDate: toDate,
                                fromTime: fromTime,
                                toTime: toTime),
                          );
                          break;
                        case 2:
                          showDatePickerDialog(context, 'reporttype');
                          break;

                        default:
                          toDate =
                              newFormat.format(dt.add(const Duration(days: 1)));
                          fromDate = newFormat.format(dt);
                          Navigator.pushNamed(
                            context,
                            RoutesName.reporttype,
                            arguments: DeviceHistoryOnMapIntialData(
                                deviceTitle: deviceTitle,
                                deviceId: initialData.deviceId,
                                fromDate: fromDate,
                                toDate: toDate,
                                fromTime: fromTime,
                                toTime: toTime),
                          );
                      }
                    }),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 93, 161, 245),
                            Color.fromARGB(255, 2, 107, 244),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              color: Colors.white,
                              Icons.report_outlined,
                              size: 30,
                            ),
                            VerticalDivider(),
                            Text(
                              'View\nReports',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                    itemBuilder: (BuildContext bc) {
                      return const [
                        PopupMenuItem(
                          value: 0,
                          child: Text('Today'),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text('yesterday'),
                        ),
                        PopupMenuItem(
                          value: 7,
                          child: Text('7 Days'),
                        ),
                        PopupMenuItem(
                          value: 30,
                          child: Text('30 Days'),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text('Custom Date'),
                        ),
                      ];
                    }),
              ),
            ],
          )),
      Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          // border: Border.all(
          //     width: 6, color: Colors.red),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
              color: Color.fromARGB(255, 155, 150, 150),
              offset: Offset.zero,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  immobilizerValue
                      ? const Icon(
                          Icons.lock,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.lock_open_rounded,
                          color: Colors.green,
                        ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        immobilizerStatus,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                immobilizerValue ? Colors.red : Colors.green),
                      ),
                      GFButton(
                        onPressed: () => showCommandListPicker(
                            context, initialData.deviceId.toString()),
                        text: immobilizerValue ? 'Unlock' : 'Lock',
                        textStyle: AppColors.settingPageButtonTextStyle,
                        color: AppColors.buttonColor,
                        shape: GFButtonShape.pills,
                        size: 25,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          // border: Border.all(
          //     width: 6, color: Colors.red),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
              color: Color.fromARGB(255, 155, 150, 150),
              offset: Offset.zero,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.attach_money_outlined,
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vehicle Expenses',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Row(
                        children: [
                          GFButton(
                            onPressed: () => Navigator.pushNamed(
                                context, RoutesName.viewExpenseScreen,
                                arguments: {
                                  'vehicleId': initialData.deviceId.toString()
                                }),
                            text: 'View',
                            textStyle: AppColors.settingPageButtonTextStyle,
                            color: AppColors.buttonColor,
                            shape: GFButtonShape.pills,
                            size: 25,
                          ),
                          const SizedBox(width: 2),
                          GFButton(
                            onPressed: () => showAddExpenseForm(context,
                                initialData.deviceId.toString(), deviceTitle),
                            text: 'Add',
                            textStyle: AppColors.settingPageButtonTextStyle,
                            color: AppColors.buttonColor,
                            shape: GFButtonShape.pills,
                            size: 25,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          // border: Border.all(
          //     width: 6, color: Colors.red),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
              color: Color.fromARGB(255, 155, 150, 150),
              offset: Offset.zero,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.car_repair,
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vehicle Maintenance',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 2),
                          GFButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RoutesName.addVehicleMaintenanceScreen,
                              );
                            },
                            text: 'Add',
                            textStyle: AppColors.settingPageButtonTextStyle,
                            color: AppColors.buttonColor,
                            shape: GFButtonShape.pills,
                            size: 25,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          // border: Border.all(
          //     width: 6, color: Colors.red),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
              color: Color.fromARGB(255, 155, 150, 150),
              offset: Offset.zero,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.propane_tank_outlined,
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fuel Average is $vehicleFuelAveragePerKm km/l',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 2),
                          GFButton(
                            onPressed: () {
                              setFuelVehicleAveragePerKM(
                                context,
                                initialData,
                              );
                            },
                            text: 'Set',
                            textStyle: AppColors.settingPageButtonTextStyle,
                            color: AppColors.buttonColor,
                            shape: GFButtonShape.pills,
                            size: 25,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      if (sensorsData!.isNotEmpty)
        SensorContainer(
          sensorsData: sensorsData,
        ),
      ChangeNotifierProvider.value(
        value: eventViewModel,
        // create: (BuildContext context) => eventViewModel,
        child: Consumer<EventViewModel>(
          builder: (context, value, child) {
            switch (value.eventsAlertsResponse.status) {
              case Status.LOADING:
                return const CircleAvatar(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ));
              case Status.ERROR:
                return const CircleAvatar(
                    child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text('n/a',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ));
              case Status.COMPLETED:
                alertsList.clear();
                for (var element
                    in value.eventsAlertsResponse.data!.items!.data!) {
                  alertsList.add(element);
                }

                return Container(
                  width: MediaQuery.of(context).size.width - 30,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      //border: Border.all(width: 6, color: Colors.red),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 2,
                          color: Color.fromARGB(255, 155, 150, 150),
                          offset: Offset.zero,
                          blurStyle: BlurStyle.outer,
                        ),
                      ]),
                  child: Column(
                    children: [
                      GFTypography(
                        text: 'Recent Alerts',
                        type: AppColors.deviceOnMapSligePanelHeading,
                        icon: Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.blue[800],
                        ),
                        showDivider: false,
                        textColor: Colors.blue[800],

                        //textColor: Colors.blueAccent,
                      ),
                      const Divider(),
                      alertsList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: alertsList.length,
                              itemBuilder: (alertscontext, index) {
                                return index < 5
                                    ? Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              alertsList[index]
                                                  .message
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            subtitle: Text(
                                                alertsList[index]
                                                    .createdAt
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                            trailing: const Icon(
                                              Icons
                                                  .notifications_active_outlined,
                                              size: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const Divider(
                                            height: 2,
                                          )
                                        ],
                                      )
                                    : Container();
                              },
                            )
                          : const Text('Recent alerts are not available'),
                      GFButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.eventsScreen,
                              arguments: EventsInitialData(
                                  deviceID: initialData.deviceId.toString(),
                                  eventType: '',
                                  fromDate: '',
                                  toDate: '',
                                  pageNumber: ''));
                        },
                        text: 'View More Alerts',
                        textStyle: AppColors.settingPageButtonTextStyle,
                        color: AppColors.buttonColor,
                        shape: GFButtonShape.pills,
                        size: 25,
                      ),
                    ],
                  ),
                );

              default:
                const Text('THis');
            }

            return Container();
          },
        ),
      ),
      const Divider(),
    ],
  );
}

class SensorContainer extends StatelessWidget {
  const SensorContainer({
    Key? key,
    required this.sensorsData,
  }) : super(key: key);
  final List<dynamic>? sensorsData;
  @override
  Widget build(BuildContext context) {
    IconData sensorIcons = Icons.key;
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          //border: Border.all(width: 6, color: Colors.red),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Color.fromARGB(255, 155, 150, 150),
              offset: Offset.zero,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Column(
        children: [
          GFTypography(
            text: 'Vehicle Sensors',
            type: AppColors.deviceOnMapSligePanelHeading,
            icon: Icon(
              Icons.sensors_outlined,
              color: Colors.blue[800],
            ),
            showDivider: false,
            textColor: Colors.blue[800],

            //textColor: Colors.blueAccent,
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: sensorsData!.length,
            itemBuilder: (context, index) {
              switch (sensorsData![index]['name'].toString().toLowerCase()) {
                case 'ignition':
                  sensorIcons = Icons.key;
                  break;
                case 'gps':
                  sensorIcons = Icons.gps_fixed;
                  break;
                case 'gsm':
                  sensorIcons = Icons.network_cell;
                  break;
                case 'network':
                  sensorIcons = Icons.network_cell;
                  break;
                case 'charging':
                  sensorIcons = Icons.battery_charging_full;

                  break;
                case 'satellites':
                  sensorIcons = Icons.satellite_alt_outlined;
                  break;
                case 'external power':
                  sensorIcons = Icons.battery_charging_full;
                  break;
                case 'internal battery level':
                  sensorIcons = Icons.battery_charging_full;
                  break;
                case 'Immobilizer':
                  sensorIcons = Icons.lock_sharp;
                  break;
                case 'immobiliser':
                  sensorIcons = Icons.lock_sharp;
                  break;
                case 'immobilizer':
                  sensorIcons = Icons.lock_sharp;
                  break;
                case 'odometer':
                  sensorIcons = Icons.speed;
                  break;
                case 'total odometer':
                  sensorIcons = Icons.speed;
                  break;
                case 'engine hours':
                  sensorIcons = Icons.timelapse_sharp;
                  break;
                case 'result':
                  sensorIcons = Icons.report;
                  break;
                case 'external voltage':
                  sensorIcons = Icons.power_settings_new;
                  break;
                case 'external volts':
                  sensorIcons = Icons.power_settings_new;
                  break;
                default:
                  sensorIcons = Icons.sensors;
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            sensorIcons,
                            color: Colors.black54,
                            size: 16,
                          ),
                          const VerticalDivider(),
                          Text(
                              sensorsData![index]['name']
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0)),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          sensorsData![index]['value'].toString(),
                          style: const TextStyle(fontSize: 12),
                          softWrap: true,
                          maxLines: 8,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class AlertsContainer extends StatelessWidget {
  const AlertsContainer({
    Key? key,
    required this.alertList,
  }) : super(key: key);
  final List<Data>? alertList;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          //border: Border.all(width: 6, color: Colors.red),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Color.fromARGB(255, 155, 150, 150),
              offset: Offset.zero,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Column(
        children: [
          GFTypography(
            text: 'Vehicle Sensors',
            type: AppColors.deviceOnMapSligePanelHeading,
            icon: Icon(
              Icons.sensors_outlined,
              color: Colors.blue[800],
            ),
            showDivider: false,
            textColor: Colors.blue[800],

            //textColor: Colors.blueAccent,
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: alertList!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Text(alertList![index].message.toString()),
                    ],
                  ),
                  const Divider()
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
