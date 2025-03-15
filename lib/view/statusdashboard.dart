import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/device_data_model.dart';
import 'package:trackerapp/models/device_on_map_model.dart';
import 'package:trackerapp/models/devices_model.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';

import 'package:trackerapp/view_model/device_view_viewmodel.dart';

class StatusDashboard extends StatefulWidget {
  const StatusDashboard({super.key});

  @override
  State<StatusDashboard> createState() => _StatusDashboardState();
}

class _StatusDashboardState extends State<StatusDashboard> {
  DeviceViewViewModel deviceViewViewModel = DeviceViewViewModel();
  late String stopTime;
  late List<DevicesModel> groupList = [];
  late List<dynamic> devicesList = [];
  late List<DeviceData> deviceDataList = [];
  late List<dynamic> searchedDeviceList = [];
  late List<dynamic> _searchResult = [];

  late List<String> stopTimeInHours;
  late String iconPathfromApi;
  late String iconColorFromApi;
  late double latFromApi;
  late double lngFromApi;
  late Color mainBoxbgColor;
  late String vehicleStatus;
  late Color vehicleStatuscColor;
  late double latfromApi;
  late double lngfromApi;
  late String getAddressstring = 'Karachi';
  Color keyColor = Colors.grey;
  late List<dynamic>? sensorsData;
  int runningCount = 0;
  int stoppedCount = 0;
  int idleCount = 0;
  int oflineCount = 0;
  int noDataCount = 0;
  int allCount = 0;
  late String deviceStatus;
  late String filterDeviceStatus;

  Future<String> getAdress(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    return placemarks.reversed.last.subAdministrativeArea.toString();
  }

  setDevicesStatusCounters(List<dynamic> devicesList) {
    for (var device in devicesList) {
      allCount = allCount + 1;
      deviceStatus = device['online']; // == "online";
      if (device['time'] == "Not connected") {
        noDataCount = noDataCount + 1;
      } else {
        if (device['online'] == "offline") {
          oflineCount = oflineCount + 1;
        } else {
          device['sensors'].forEach((sensor) {
            if (sensor['name'] == "Ignition" ||
                sensor['name'] == "IGNITION" ||
                sensor['name'] == "ignition") {
              if (sensor['value'].toString() == "On" &&
                  device["speed"] > 0 &&
                  deviceStatus == "online") {
                runningCount = runningCount + 1;
              } else if (sensor['value'].toString() == "On" &&
                  device["speed"] == 0) {
                idleCount = idleCount + 1;
              } else if (sensor['value'].toString() == "Off") {
                stoppedCount = stoppedCount + 1;
              }
            }
          });
        }
      }
    }
  }

  deviceListFilter(String filterVal, List<dynamic> devicesList) async {
    _searchResult.clear();

    if (filterVal == "all") {
      _searchResult.addAll(devicesList);
      return;
    }

    for (var device in devicesList) {
      filterDeviceStatus = device['online'];
      if (filterVal == "nodata") {
        if (device['time'] == "Not connected") _searchResult.add(device);
      } else {
        if (filterVal == "offline") {
          if (device['online'] == "offline" &&
              device['time'] != "Not connected") {
            _searchResult.add(device);
          }
        } else {
          if (device['sensors'] == null) {
            return;
          }
          device['sensors'].forEach((sensor) {
            if (filterVal == "stopped") {
              if (sensor['name'] == "Ignition" ||
                  sensor['name'] == "IGNITION" ||
                  sensor['name'] == "ignition") {
                if (sensor['value'].toString() == "Off" &&
                    filterDeviceStatus != "offline") {
                  _searchResult.add(device);
                }
              }
            } else if (filterVal == "running" &&
                filterDeviceStatus != "offline") {
              if (sensor['name'] == "Ignition" ||
                  sensor['name'] == "IGNITION" ||
                  sensor['name'] == "ignition") {
                if (sensor['value'].toString() == "On" && device["speed"] > 0) {
                  _searchResult.add(device);
                }
              }
            } else if (filterVal == "idle" && filterDeviceStatus != "offline") {
              if (sensor['name'] == "Ignition" ||
                  sensor['name'] == "IGNITION" ||
                  sensor['name'] == "ignition") {
                if (sensor['value'].toString() == "On" &&
                    device["speed"] == 0) {
                  _searchResult.add(device);
                }
              }
            }
          });
        }
      }
    }
  }

  @override
  void initState() {
    deviceViewViewModel.getDeviceDataListFromApi();
    // deviceViewViewModel.getDeviceDataFromApi();
    // getAdress(24.852433, 67.085667).then((value) {
    //   getAddressstring = value;
    //   Utils.flushBarErrorMessage(getAddressstring, context);
    // }).onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage(error.toString(), context);
    // });
    Timer.periodic(const Duration(seconds: 10), (timer) {
      //deviceViewViewModel.getDeviceDataListFromApi();
    });

    super.initState();
  }

  @override
  void dispose() {
    //  _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status Dashboard',
          style: AppColors.appTitleTextStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ChangeNotifierProvider<DeviceViewViewModel>(
            create: (BuildContext context) => deviceViewViewModel,
            child: Consumer<DeviceViewViewModel>(
              builder: (context, value, child) {
                switch (value.getDeviceModelListResponse.status) {
                  case Status.LOADING:
                    return const Center(child: CircularProgressIndicator());
                  case Status.ERROR:
                    return Center(
                        child: Text(value.getDeviceModelListResponse.message
                            .toString()));
                  case Status.COMPLETED:
                    runningCount = 0;
                    stoppedCount = 0;
                    idleCount = 0;
                    oflineCount = 0;
                    noDataCount = 0;
                    allCount = 0;
                    groupList.clear();
                    devicesList.clear();
                    deviceDataList.clear();
                    groupList.addAll(value.getDeviceModelListResponse.data!);
                    int groupIndex = 0;
                    //print('groups added');
                    for (var element in groupList) {
                      int deviceIndex = 0;

                      devicesList.addAll(element.items!);
                      for (var device in element.items!) {
                        DeviceData newdevice = DeviceData();
                        newdevice.groupid = groupIndex;
                        newdevice.deviceIndexInGroup = deviceIndex;
                        newdevice.devicedata = device;
                        deviceDataList.add(newdevice);
                        deviceIndex = deviceIndex + 1;
                      }
                      groupIndex = groupIndex + 1;
                    }

                    setDevicesStatusCounters(devicesList);
                    // print('device counter set');
                    // print('Stops : $stoppedCount');
                    // print('running : $runningCount');
                    // print('nodata : $noDataCount');
                    // print('idle: $idleCount');
                    // print('offline : $oflineCount');
                    // print('Device length are ${devicesList.length}');

                    return Expanded(
                      child: ListView.builder(
                        itemCount: groupList.length,
                        itemBuilder: (context, index) {
                          searchedDeviceList.clear();
                          devicesList.clear();
                          devicesList.addAll(groupList[index].items!);
                          setDevicesStatusCounters(devicesList);

                          deviceListFilter('all', devicesList);
                          //print(_searchResult.first['name'].toString());

                          searchedDeviceList.addAll(_searchResult);

                          return Column(children: [
                            Text(groupList[index].title.toString()),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: searchedDeviceList.length,
                                itemBuilder: (context, nestedindex) {
                                  stopTime =
                                      devicesList[nestedindex]['stop_duration'];
                                  stopTimeInHours = stopTime.split(' ');

                                  iconPathfromApi =
                                      devicesList[nestedindex]['icon']['path'];

                                  sensorsData =
                                      devicesList[nestedindex]['sensors'];
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
                                      }
                                    }
                                  }

                                  iconColorFromApi =
                                      devicesList[nestedindex]['icon_color'];
                                  switch (iconColorFromApi) {
                                    case 'red':
                                      mainBoxbgColor = const Color.fromARGB(
                                          255, 250, 208, 208);
                                      vehicleStatus = 'Stop';
                                      vehicleStatuscColor = Colors.red;
                                      break;

                                    case 'green':
                                      mainBoxbgColor = const Color.fromRGBO(
                                          206, 248, 205, 1);
                                      vehicleStatus = 'Driving';
                                      vehicleStatuscColor = Colors.green;
                                      break;
                                    case 'blue':
                                      mainBoxbgColor = const Color.fromARGB(
                                          255, 213, 238, 255);
                                      vehicleStatus = 'Offline';
                                      vehicleStatuscColor = Colors.blueGrey;
                                      break;
                                    case 'yellow':
                                      mainBoxbgColor = const Color.fromARGB(
                                          255, 255, 242, 174);
                                      vehicleStatus = 'Idle';
                                      vehicleStatuscColor = Colors.orange;

                                      break;
                                    case 'black':
                                      mainBoxbgColor = const Color.fromARGB(
                                          255, 255, 242, 174);
                                      vehicleStatus = 'parked';
                                      vehicleStatuscColor = Colors.orange;
                                      break;

                                    default:
                                      mainBoxbgColor = const Color.fromARGB(
                                          255, 213, 216, 218);
                                      vehicleStatus =
                                          'not connected or offline';
                                      vehicleStatuscColor = Colors.black87;
                                  }
                                  return Padding(
                                    padding:
                                        //padding for main stack for print
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutesName.singledevicemap,
                                          arguments: DeviceOnMapintialData(
                                            groupID: index,
                                            itemID: nestedindex,
                                            intialLat: double.parse(value
                                                .getDeviceModelListResponse
                                                .data![index]
                                                .items![nestedindex]['lat']
                                                .toString()),
                                            intiallng: double.parse(value
                                                .getDeviceModelListResponse
                                                .data![index]
                                                .items![nestedindex]['lng']
                                                .toString()),
                                            deviceId: int.parse(value
                                                .getDeviceModelListResponse
                                                .data![index]
                                                .items![nestedindex]['id']
                                                .toString()),
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        //alignment: Alignment.topLeft,
                                        children: [
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 36),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  color:
                                                      const Color(0x4d9e9e9e),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 1,
                                                  color: Color.fromARGB(
                                                      255, 155, 150, 150),
                                                  offset: Offset.zero,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Icon(
                                                    Icons.local_parking,
                                                    color: Color.fromARGB(
                                                        255, 98, 120, 247),
                                                    size: 18,
                                                  ),
                                                  const Icon(
                                                    Icons.wifi,
                                                    color: Colors.orange,
                                                    size: 18,
                                                  ),
                                                  Icon(
                                                    Icons.key_sharp,
                                                    color: keyColor,
                                                    size: 18,
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .battery_charging_full_outlined,
                                                    color: Colors.brown,
                                                    size: 18,
                                                  ),
                                                  Row(
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .battery_3_bar_sharp,
                                                        color: Colors.green,
                                                        size: 18,
                                                      ),
                                                      Text('67%')
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 15),
                                            padding: EdgeInsets.zero,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 95,
                                            decoration: BoxDecoration(
                                              color: mainBoxbgColor,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  color:
                                                      const Color(0x4d9e9e9e),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 5,
                                                  color: Color.fromARGB(
                                                      255, 175, 172, 172),
                                                  offset: Offset.zero,
                                                  blurStyle: BlurStyle.normal,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black87,
                                                        radius: 25.7,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          radius: 25,
                                                          child: Image(
                                                            fit: BoxFit.contain,
                                                            image: NetworkImage(
                                                                AppUrl.baseImgURL +
                                                                    iconPathfromApi),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 7,
                                                      ),
                                                      Text(
                                                        stopTimeInHours[0],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        searchedDeviceList[
                                                                    nestedindex]
                                                                ['name']
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${value.getDeviceModelListResponse.data![index].items![nestedindex]['time']}',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        getAddressstring,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${value.getDeviceModelListResponse.data![index].items![nestedindex]['speed']}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Text(
                                                        'km/h',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        vehicleStatus,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                vehicleStatuscColor),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ]);
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
    );
  }
}
