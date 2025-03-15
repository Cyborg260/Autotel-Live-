import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/device_data_model.dart';
import 'package:trackerapp/models/device_on_map_model.dart';
import 'package:trackerapp/models/devices_model.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';
import 'package:trackerapp/res/helper/map_helper.dart';
import 'package:trackerapp/res/helper/map_marker.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view_model/device_view_viewmodel.dart';
import 'package:trackerapp/view_model/osmaddress_view_view_model.dart';

class StatusDashboardSecond extends StatefulWidget {
  const StatusDashboardSecond({super.key});

  @override
  State<StatusDashboardSecond> createState() => _StatusDashboardSecondState();
}

class _StatusDashboardSecondState extends State<StatusDashboardSecond> {
  DeviceViewViewModel deviceViewViewModel = DeviceViewViewModel();
  OsmAddressViewModel osmAddressViewModel = OsmAddressViewModel();
  late String stopTime;
  late List<DevicesModel> groupList = [];
  late List<dynamic> devicesList = [];
  late List<BitmapDescriptor> markerImages = [];
  late List<DeviceData> deviceDataList = [];
  late List<DeviceData> deviceDataListResult = [];
  late List<dynamic> searchedDeviceList = [];
  late final List<dynamic> _searchResult = [];
  String batteryVoltage = 'n/a';
  bool immobilizerValue = false;
  Color batteruChargingColor = Colors.grey;
  late List<String> stopTimeInHours;
  late String iconPathfromApi;
  late String iconColorFromApi;
  late double latFromApi;
  late double lngFromApi;
  late Color mainBoxbgColor;
  late String vehicleStatus;
  late Color vehicleStatuscColor;
  late List<OsmAddressViewModel> osmAddress = [];
  late String getAddressstring = 'Karachi';
  Color keyColor = Colors.grey;
  late List<dynamic>? sensorsData;
  late Timer _timer;
  int runningCount = 0;
  int stoppedCount = 0;
  int idleCount = 0;
  int oflineCount = 0;
  int noDataCount = 0;
  int allCount = 0;
  int expiredCount = 0;
  int borderPosition = 0;
  bool isSearchResult = false;
  String filterStatus = 'all';
  late String deviceStatus;
  late String filterDeviceStatus;

  Future<String> getAdress(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    return placemarks.reversed.last.subAdministrativeArea.toString();
  }

  setDevicesStatusCounters(List<dynamic> devicesList) {
    for (var device in devicesList) {
      allCount = allCount + 1;
      deviceStatus = device['online'];
      if (deviceStatus.toLowerCase() == 'ack') {
        stoppedCount = stoppedCount + 1;
      }
      if (deviceStatus.toLowerCase() == 'online') {
        runningCount = runningCount + 1;
      }
      if (device['online'].toString().toLowerCase() == "offline" &&
          device['time'].toString().toLowerCase() != "Not connected") {
        oflineCount = oflineCount + 1;
      }
      if (device['online'].toString().toLowerCase() == "offline" &&
          device['time'].toString().toLowerCase() == "not connected") {
        noDataCount = noDataCount + 1;
      }
      if (device['time'].toString().toLowerCase() == "expired") {
        expiredCount = expiredCount + 1;
      }
      if (deviceStatus.toLowerCase() == 'engine') {
        idleCount = idleCount + 1;
      }
    }
  }

  deviceListFilters(String filterVal, List<DeviceData> devicesList) async {
    _searchResult.clear();

    if (filterVal == "all") {
      _searchResult.addAll(devicesList);
      return;
    }
    for (var device in devicesList) {
      deviceStatus = device.devicedata['online'];

      if (filterVal == "stopped") {
        if (deviceStatus.toLowerCase() == 'ack') {
          _searchResult.add(device);
        }
      } else if (filterVal == "running") {
        if (deviceStatus.toLowerCase() == 'online') {
          _searchResult.add(device);
        }
      } else if (filterVal == "idle") {
        if (deviceStatus.toLowerCase() == 'engine') {
          _searchResult.add(device);
        }
      } else if (filterVal == "offline") {
        if (device.devicedata['online'] == "offline" &&
            device.devicedata['time'] != "Not connected" &&
            device.devicedata['time'] != "Expired") {
          _searchResult.add(device);
        }
      } else if (filterVal == "nodata") {
        if (device.devicedata['online'] == "offline" &&
            device.devicedata['time'] == "Not connected") {
          _searchResult.add(device);
        }
      } else if (filterVal == "expired") {
        if (device.devicedata['time'].toString().toLowerCase() == "expired") {
          _searchResult.add(device);
        }
      }
    }
  }

  void runSearchFilter(String enteredKeyword, List<DeviceData> devicesList) {
    List<DeviceData> results = [];

    _searchResult.clear();

    if (enteredKeyword.isEmpty) {
      isSearchResult = false;
      // if the search field is empty or only contains white-space, we'll display all vehciles
      _searchResult.addAll(devicesList);
    } else {
      results = devicesList
          .where((vehcile) =>
              vehcile.devicedata["name"]
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              vehcile.groupTitle!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // results = devicesList
      //     .where((vehcile) => vehcile.groupTitle!
      //         .toLowerCase()
      //         .contains(enteredKeyword.toLowerCase()))
      //     .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    _searchResult.addAll(results);

    // Refresh the UI
    isSearchResult = true;
    // _foundVehicles = results;
    // deviceHistoryViewModellist.setHistorySearchList();
    // isVehicleListLoaded = true;
  }

  setFilterBarStatus(String status, int statusPosition) {
    filterStatus = status;
    borderPosition = statusPosition;
    isSearchResult = false;
    deviceViewViewModel.setClusterMarkers();
  }

  @override
  void initState() {
    deviceViewViewModel.getDeviceDataListFromApi();

    Timer.periodic(const Duration(seconds: 10), (timer) {
      deviceViewViewModel.getDeviceDataListFromApi();
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   title: Text(
          //     'Status Dashboard',
          //     style: AppColors.appTitleTextStyle,
          //   ),
          //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          //   elevation: 0.0,
          // ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  onChanged: (value) {
                    runSearchFilter(value, deviceDataList);
                    deviceViewViewModel.setClusterMarkers();
                  },
                  decoration: const InputDecoration(
                      labelText: 'Search Vehicle or Group',
                      suffixIcon: Icon(Icons.search)),
                ),
              ),
              ChangeNotifierProvider.value(
                value: deviceViewViewModel,
                //create: (BuildContext context) => deviceViewViewModel,
                child: Consumer<DeviceViewViewModel>(
                  builder: (context, value, child) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setFilterBarStatus('all', 0);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.brown[400],
                                      shape: BoxShape.rectangle,
                                      borderRadius: AppColors
                                          .StatusDshboardBarborderRadius,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: borderPosition == 0 ? 1 : 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Color.fromARGB(
                                              255, 155, 150, 150),
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      allCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: borderPosition == 0
                                            ? Colors.brown[800]
                                            : Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setFilterBarStatus('running', 1);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    width: 40,
                                    //color: Colors.green,
                                    decoration: BoxDecoration(
                                      color: Colors.green[800],
                                      shape: BoxShape.rectangle,
                                      borderRadius: AppColors
                                          .StatusDshboardBarborderRadius,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: borderPosition == 1 ? 1 : 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Color.fromARGB(
                                              255, 155, 150, 150),
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      runningCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Running',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: borderPosition == 1
                                            ? Colors.green[800]
                                            : Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setFilterBarStatus('stopped', 2);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red[600],
                                      shape: BoxShape.rectangle,
                                      borderRadius: AppColors
                                          .StatusDshboardBarborderRadius,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: borderPosition == 2 ? 1 : 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Color.fromARGB(
                                              255, 155, 150, 150),
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      stoppedCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Stop',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: borderPosition == 2
                                            ? Colors.red[500]
                                            : Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setFilterBarStatus('idle', 3);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[800],
                                      shape: BoxShape.rectangle,
                                      borderRadius: AppColors
                                          .StatusDshboardBarborderRadius,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: borderPosition == 3 ? 1 : 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Color.fromARGB(
                                              255, 155, 150, 150),
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      idleCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Idle',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: borderPosition == 3
                                            ? Colors.yellow[800]
                                            : Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setFilterBarStatus('offline', 4);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      shape: BoxShape.rectangle,
                                      borderRadius: AppColors
                                          .StatusDshboardBarborderRadius,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: borderPosition == 4 ? 1 : 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Color.fromARGB(
                                              255, 155, 150, 150),
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      oflineCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Offline',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: borderPosition == 4
                                            ? Colors.blue[800]
                                            : Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setFilterBarStatus('nodata', 5);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      shape: BoxShape.rectangle,
                                      borderRadius: AppColors
                                          .StatusDshboardBarborderRadius,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: borderPosition == 5 ? 1 : 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Color.fromARGB(
                                              255, 155, 150, 150),
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      noDataCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'No data',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: borderPosition == 5
                                            ? Colors.black
                                            : Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setFilterBarStatus('expired', 6);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red[900],
                                      shape: BoxShape.rectangle,
                                      borderRadius: AppColors
                                          .StatusDshboardBarborderRadius,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: borderPosition == 6 ? 1 : 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: Color.fromARGB(
                                              255, 155, 150, 150),
                                          offset: Offset.zero,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      expiredCount.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Expired',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: borderPosition == 6
                                            ? Colors.black
                                            : Colors.black54),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ChangeNotifierProvider<DeviceViewViewModel>.value(
                value: deviceViewViewModel,
                //create: (BuildContext context) => deviceViewViewModel,
                child: Consumer<DeviceViewViewModel>(
                  builder: (context, value, child) {
                    switch (value.getDeviceModelListResponse.status) {
                      case Status.LOADING:
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                    image:
                                        AssetImage('assets/images/loading.gif'),
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
                        deviceViewViewModel.getDeviceDataListFromApi();
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                    image:
                                        AssetImage('assets/images/loading.gif'),
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
                        runningCount = 0;
                        stoppedCount = 0;
                        idleCount = 0;
                        oflineCount = 0;
                        noDataCount = 0;
                        allCount = 0;
                        expiredCount = 0;
                        groupList.clear();
                        devicesList.clear();
                        deviceDataList.clear();
                        groupList
                            .addAll(value.getDeviceModelListResponse.data!);
                        int groupIndex = 0;

                        for (var element in groupList) {
                          int deviceIndex = 0;

                          devicesList.addAll(element.items!);

                          for (var device in element.items!) {
                            DeviceData newdevice = DeviceData();

                            newdevice.groupid = groupIndex;
                            newdevice.deviceIndexInGroup = deviceIndex;
                            newdevice.devicedata = device;
                            newdevice.groupTitle = element.title;

                            deviceDataList.add(newdevice);
                            OsmAddressViewModel osmAddressViewModel =
                                OsmAddressViewModel();
                            osmAddress.add(osmAddressViewModel);
                            deviceIndex = deviceIndex + 1;
                          }
                          groupIndex = groupIndex + 1;
                        }

                        setDevicesStatusCounters(devicesList);

                        if (!isSearchResult) {
                          deviceListFilters(filterStatus, deviceDataList);
                        }

                        deviceDataListResult.clear();
                        for (var element in _searchResult) {
                          deviceDataListResult.add(element);
                        }
                        markerImages.clear();
                        for (var device in deviceDataListResult) {
                          markerImages.add(BitmapDescriptor.defaultMarker);
                        }
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: deviceDataListResult.length,
                            itemBuilder: (context, deviceIndex) {
                              stopTime = deviceDataListResult[deviceIndex]
                                  .devicedata['stop_duration'];
                              stopTimeInHours = stopTime.split(' ');
                              if (deviceDataListResult[deviceIndex]
                                      .devicedata['lat'] ==
                                  0) {
                                latFromApi = 24.945273;
                              } else {
                                latFromApi = double.parse(
                                    deviceDataListResult[deviceIndex]
                                        .devicedata['lat']
                                        .toString());
                              }
                              if (deviceDataListResult[deviceIndex]
                                      .devicedata['lat'] ==
                                  0) {
                                lngFromApi = 67.095811;
                              } else {
                                lngFromApi = double.parse(
                                    deviceDataListResult[deviceIndex]
                                        .devicedata['lng']
                                        .toString());
                              }

                              osmAddress[deviceIndex]
                                  .fetchOsmAddress(latFromApi, lngFromApi);
                              iconPathfromApi =
                                  deviceDataListResult[deviceIndex]
                                      .devicedata['icon']['path'];

                              MapHelper.getMarkerImageFromUrl(
                                      AppUrl.baseImgURL + iconPathfromApi)
                                  .then((markerImageValue) {
                                markerImages[deviceIndex] = markerImageValue;
                              });
                              sensorsData = deviceDataListResult[deviceIndex]
                                  .devicedata['sensors'];
                              keyColor = Colors.grey;
                              if (sensorsData != null) {
                                if (sensorsData!.isNotEmpty) {
                                  for (var element in sensorsData!) {
                                    if (element['name'] == 'Ignition' ||
                                        element['name'] == 'IGNITION') {
                                      switch (element['value']) {
                                        case 'Off':
                                          keyColor = Colors.red;

                                          break;
                                        case 'On':
                                          keyColor = Colors.green;
                                          break;
                                        default:
                                          keyColor = Colors.grey;
                                      }
                                    }
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
                                      if (element['value']
                                              .toString()
                                              .toLowerCase() ==
                                          'off') {
                                        immobilizerValue = false;

                                        'Immobiliser is off';
                                      } else if (element['value']
                                              .toString()
                                              .toLowerCase() ==
                                          'on') {
                                        immobilizerValue = true;
                                      } else {
                                        immobilizerValue = false;
                                      }
                                    }
                                  }
                                }
                              }
                              iconColorFromApi =
                                  deviceDataListResult[deviceIndex]
                                      .devicedata['online']
                                      .toString()
                                      .toLowerCase();
                              switch (iconColorFromApi) {
                                case 'ack':
                                  mainBoxbgColor =
                                      const Color.fromARGB(255, 250, 208, 208);
                                  vehicleStatus = 'Stop';
                                  vehicleStatuscColor = Colors.red[800]!;
                                  break;

                                case 'online':
                                  mainBoxbgColor =
                                      const Color.fromRGBO(206, 248, 205, 1);
                                  vehicleStatus = 'Driving';
                                  vehicleStatuscColor = Colors.green[800]!;
                                  break;
                                case 'offline':
                                  mainBoxbgColor =
                                      const Color.fromARGB(255, 213, 238, 255);
                                  vehicleStatus = 'Offline';
                                  vehicleStatuscColor = Colors.blue[800]!;
                                  break;
                                case 'engine':
                                  mainBoxbgColor =
                                      const Color.fromARGB(255, 255, 242, 174);
                                  vehicleStatus = 'Idle';
                                  vehicleStatuscColor = Colors.orange[800]!;

                                  break;
                                case 'black':
                                  mainBoxbgColor =
                                      const Color.fromARGB(255, 255, 242, 174);
                                  vehicleStatus = 'parked';
                                  vehicleStatuscColor = Colors.orange;
                                  break;

                                default:
                                  mainBoxbgColor =
                                      const Color.fromARGB(255, 213, 216, 218);
                                  vehicleStatus = 'not connected or offline';
                                  vehicleStatuscColor = Colors.black87;
                              }
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.singledevicemap,
                                    arguments: DeviceOnMapintialData(
                                      groupID: deviceDataListResult[deviceIndex]
                                          .groupid,
                                      itemID: deviceDataListResult[deviceIndex]
                                          .deviceIndexInGroup,
                                      intialLat: double.parse(
                                          deviceDataListResult[deviceIndex]
                                              .devicedata['lat']
                                              .toString()),
                                      intiallng: double.parse(
                                          deviceDataListResult[deviceIndex]
                                              .devicedata['lng']
                                              .toString()),
                                      deviceId: int.parse(
                                          deviceDataListResult[deviceIndex]
                                              .devicedata['id']
                                              .toString()),
                                      markerImage: markerImages[deviceIndex],
                                      intialdirection: double.parse(
                                          deviceDataListResult[deviceIndex]
                                              .devicedata['course']
                                              .toString()),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 5, 12, 0),
                                  child: Card(
                                    shape: AppColors.cardBorderShape,
                                    color: mainBoxbgColor,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            vehicleStatuscColor,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        border: Border.all(
                                                            color: const Color(
                                                                0x4d9e9e9e),
                                                            width: 0),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      15,
                                                                      3,
                                                                      15,
                                                                      3),
                                                              child: Text(
                                                                deviceDataListResult[
                                                                        deviceIndex]
                                                                    .devicedata['name'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                                softWrap: false,
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'Group: ',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        deviceDataListResult[
                                                                deviceIndex]
                                                            .groupTitle!,
                                                        style: TextStyle(
                                                            color:
                                                                vehicleStatuscColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                            size: 16,
                                                            Icons.speed,
                                                          ),
                                                          const VerticalDivider(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            'Speed:',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .webhook_outlined,
                                                            size: 18,
                                                          ),
                                                          const VerticalDivider(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            'Status:',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                            Icons.access_time,
                                                            size: 18,
                                                          ),
                                                          const VerticalDivider(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            'Update',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .grey[700]),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const VerticalDivider(
                                                            width: 6,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                '${deviceDataListResult[deviceIndex].devicedata['speed']}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const Text(
                                                                ' km/h',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          const VerticalDivider(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            vehicleStatus,
                                                            style: TextStyle(
                                                                color:
                                                                    vehicleStatuscColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const VerticalDivider(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            stopTime,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const VerticalDivider(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                              deviceDataListResult[
                                                                          deviceIndex]
                                                                      .devicedata[
                                                                  'time'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black87,
                                                          radius: 30,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 29,
                                                            child: Image(
                                                              image: NetworkImage(
                                                                  AppUrl.baseImgURL +
                                                                      iconPathfromApi),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                                indent: 5, endIndent: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircleAvatar(
                                                  radius: 13,
                                                  child: immobilizerValue
                                                      ? const Icon(
                                                          Icons.lock,
                                                          color: Colors.red,
                                                          size: 18,
                                                        )
                                                      : const Icon(
                                                          Icons.lock_open,
                                                          color: Colors.green,
                                                          size: 18,
                                                        ),
                                                ),
                                                const CircleAvatar(
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.wifi,
                                                    color: Colors.orange,
                                                    size: 18,
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons.key_sharp,
                                                    color: keyColor,
                                                    size: 18,
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  radius: 13,
                                                  child: Icon(
                                                    Icons
                                                        .battery_charging_full_outlined,
                                                    color: batteruChargingColor,
                                                    size: 18,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      radius: 13,
                                                      child: Icon(
                                                        Icons
                                                            .battery_3_bar_sharp,
                                                        color: Colors.green,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Text(batteryVoltage,
                                                        style: const TextStyle(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                                indent: 5, endIndent: 5),
                                            ChangeNotifierProvider.value(
                                              value: osmAddress[deviceIndex],
                                              // create: (_) =>
                                              //     osmAddress[deviceIndex],
                                              child:
                                                  Consumer<OsmAddressViewModel>(
                                                builder: (addresscontext,
                                                    address, child) {
                                                  if (address.osmAddressResponse
                                                          .status ==
                                                      null) {
                                                    return const Text(
                                                        'Address not found');
                                                  }
                                                  switch (address
                                                      .osmAddressResponse
                                                      .status) {
                                                    case Status.LOADING:
                                                      return const Text(
                                                          'Loading');
                                                    case Status.ERROR:
                                                      return const Text(
                                                          'Error while fetching address');
                                                    case Status.COMPLETED:
                                                      final displayName = address
                                                              .osmAddressResponse
                                                              .data
                                                              ?.features?[0]
                                                              .properties
                                                              ?.displayName
                                                              ?.toString() ??
                                                          'Unknown Address';
                                                      if (address
                                                              .osmAddressResponse
                                                              .data !=
                                                          null) {
                                                        return Text(
                                                          displayName,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        );
                                                      } else {
                                                        return const Text(
                                                            'Address not found');
                                                      }

                                                    default:
                                                  }
                                                  return Container();
                                                },
                                              ),
                                            ),
                                            //   InkWell(
                                            //     onTap: () {
                                            //       osmAddress[deviceIndex]
                                            //           .fetchOsmAddress(
                                            //               latFromApi, lngFromApi);
                                            //     },
                                            //     child: Text('This is address' +
                                            //         latFromApi.toString() +
                                            //         'lng' +
                                            //         lngFromApi.toString()),
                                            //   )
                                          ],
                                        )),
                                  ),
                                ),
                              );
                            },
                          ),
                        );

                      default:
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
