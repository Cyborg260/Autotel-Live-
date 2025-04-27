import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackerapp/data/globalsharedveriables.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/devices_model.dart';
import 'package:trackerapp/models/events_intitial_data.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view/home.dart';
import 'package:trackerapp/view_model/device_view_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trackerapp/view_model/event_view_model.dart';
import 'package:trackerapp/view_model/expnese_record_view_model.dart';
import 'package:trackerapp/view_model/vehicle_maintenance_view_model.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DeviceViewViewModel deviceViewViewModelOnDashboard = DeviceViewViewModel();
  EventViewModel eventViewModel = EventViewModel();
  EventViewModel eventViewModelExcessDrive = EventViewModel();
  EventViewModel eventViewModelGeoFence = EventViewModel();
  EventViewModel eventViewModelOverSpeed = EventViewModel();
  EventViewModel eventViewModelCustom = EventViewModel();
  EventViewModel eventViewModelStopDuration = EventViewModel();
  EventViewModel eventViewModelIdleDurations = EventViewModel();
  ExpenseRecordViewModel expenseRecordViewModel = ExpenseRecordViewModel();
  VehicleMaintenanceViewModel vehicleMaintenanceViewModel =
      VehicleMaintenanceViewModel();
  late VideoPlayerController _controller;
  int runningCount = 0;
  int stoppedCount = 0;
  int idleCount = 0;
  int oflineCount = 0;
  int noDataCount = 0;
  int allCount = 0;
  int expiredCount = 0;
  late Legend legendProperties;
  late List<DevicesModel> groupList = [];
  late List<Color> sfgPaletteColor = [];
  late List<dynamic> devicesList = [];
  late List<_ChartData> vehicleStatusCountdata;
  late List<_ChartData> dataBar;
  late TooltipBehavior _tooltip;
  late TextStyle dashBoardHeadingStyle;
  late DataLabelSettings vehicleStatusGraphLableSettings;
  late String deviceID = '';
  late String eventType = '';
  late String fromDate = '';
  late String toDate = '';
  late String pageNumber = '';
  late DateTime dt = DateTime.now();
  late DateFormat newFormat = DateFormat("yy-MM-dd");

  Map<String, double> dataMap = {
    "Moving": 5,
    "Stopped": 3,
    "Idle": 2,
    "Offline": 2,
  };
  Map<String, String> legenstMap = {
    "Moving": 'Running (5)',
    "Stopped": 'Stopped (3)',
    "Idle": '2',
    "Offline": "2",
  };

  final colorList = <Color>[
    const Color.fromARGB(255, 3, 95, 1),
    const Color.fromARGB(255, 212, 2, 2),
    const Color.fromARGB(255, 255, 187, 1),
    const Color.fromARGB(255, 2, 79, 130),
  ];
  Future<void> saveDefaultFuelAverageForVehicle(
      List<Map<String, dynamic>> vehiclesNamesIdMap) async {
    for (var vehicleMap in vehiclesNamesIdMap) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getDouble('fuelAverage_${vehicleMap['id']}') == null) {
        String key =
            'fuelAverage_${vehicleMap['id']}'; // Creates a unique key like "fuelAverage_Car"
        prefs.setDouble(key, 13.0);
      } else {
        // print(prefs.getDouble('fuelAverage_${vehicleMap['id']}'));
        // print('fuelAverage_${vehicleMap['id']}');
      }
    }
  }

  setDevicesStatusCounterss(List<dynamic> devicesList) async {
    vehicleNames.clear();
    vehiclesNamesIdMap.clear();
    for (var device in devicesList) {
      vehicleNames.add(device['name']);
      vehiclesNamesIdMap.add({"id": device['id'], "name": device['name']});
      // if (prefs.getInt(device['id'].toString()) == null) {
      //   prefs.setInt(device['id'].toString(), 13);
      //   print('Default fuel data added for ' + device['id'].toString());
      // }
      allCount = allCount + 1;
      var deviceStatus = device['online'];
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

  @override
  void initState() {
    expenseRecordViewModel.fetchExpenseRecordsForVehicle('');
    vehicleMaintenanceViewModel.fetchVehicleMaintenanceList('');
    deviceViewViewModelOnDashboard.getDeviceDataListFromApi();
    toDate = newFormat.format(dt.add(const Duration(days: 1)));
    fromDate = newFormat.format(dt);
    sfgPaletteColor = [
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.blue,
      Colors.grey,
      const Color.fromARGB(255, 138, 13, 4)
    ];
    dashBoardHeadingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54);
    vehicleStatusGraphLableSettings = const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.inside,
        showZeroValue: false,
        useSeriesColor: false);

    legendProperties = Legend(
      isVisible: true,
      position: LegendPosition.right,
      isResponsive: true,
      width: '100%',
    );
    vehicleStatusCountdata = [
      _ChartData('Running', 1),
      _ChartData('Stopped', 1),
      _ChartData('Idle', 1),
      _ChartData('Offline', 1),
      _ChartData('No Data', 1),
      _ChartData('Expired', 1),
    ];
    dataBar = [
      _ChartData('Runninga', 4),
      _ChartData('Stoped', 26),
      _ChartData('Idle', 3),
      _ChartData('Offline', 2),
      _ChartData('fast', 4),
      _ChartData('urltraFast', 26),
      _ChartData('Idlea', 3),
      _ChartData('Offlinea', 2),
      _ChartData('Runningaa', 4),
      _ChartData('Stopeda', 26),
      _ChartData('Idlea', 3),
      _ChartData('Offlinea', 2),
      _ChartData('fasta', 4),
      _ChartData('urltraFasta', 26),
      _ChartData('Idleaa', 3),
      _ChartData('Offlineaa', 2)
    ];
    dataBar.add(_ChartData('Offlineaaa', 56));
    _tooltip = TooltipBehavior(enable: true);
    Timer.periodic(const Duration(seconds: 30), (timer) {
      deviceViewViewModelOnDashboard.getDeviceDataListFromApi();
    });
    eventViewModel.fetchEventsAlertsFromApi(
        deviceID, eventType, fromDate, toDate, pageNumber);
    eventViewModelOverSpeed.fetchEventsAlertsFromApi(
        deviceID, 'overspeed', fromDate, toDate, pageNumber);
    eventViewModelCustom.fetchEventsAlertsFromApi(
        deviceID, 'custom', fromDate, toDate, pageNumber);
    eventViewModelExcessDrive.fetchEventsAlertsFromApi(
        deviceID, 'distance', fromDate, toDate, pageNumber);
    eventViewModelGeoFence.fetchEventsAlertsFromApi(
        deviceID, 'zone_out', fromDate, toDate, pageNumber);
    eventViewModelStopDuration.fetchEventsAlertsFromApi(
        deviceID, 'stop_duration', fromDate, toDate, pageNumber);
    eventViewModelIdleDurations.fetchEventsAlertsFromApi(
        deviceID, 'idle_duration', fromDate, toDate, pageNumber);
    super.initState();

    _controller =
        VideoPlayerController.network('http://103.31.82.31/images/appvideo.mp4')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {
              _controller.setLooping(true);
              _controller.play();
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Dashboard',
              style: AppColors.appTitleTextStyle,
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: AppColors.cardBorderShape,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Vehicle Status',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      ChangeNotifierProvider.value(
                        value: deviceViewViewModelOnDashboard,
                        // create: (BuildContext context) =>
                        //     deviceViewViewModelOnDashboard,
                        child: Consumer<DeviceViewViewModel>(
                          builder: (context, value, child) {
                            switch (value.getDeviceModelListResponse.status) {
                              case Status.LOADING:
                                return SfCircularChart(
                                  margin: const EdgeInsets.all(0),
                                  // title: ChartTitle(text: 'Vehicle Status'),
                                  tooltipBehavior: _tooltip,
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: const Image(
                                          image: AssetImage(
                                              'assets/images/loading.gif'),
                                          height: 50,
                                          width: 50),
                                    )
                                  ],
                                  legend: legendProperties,
                                  palette: sfgPaletteColor,
                                  series: <CircularSeries>[
                                    DoughnutSeries<_ChartData, String>(
                                      onPointTap:
                                          (ChartPointDetails details) {},
                                      dataLabelSettings:
                                          vehicleStatusGraphLableSettings,
                                      dataSource: vehicleStatusCountdata,
                                      xValueMapper: (_ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                    )
                                  ],
                                );
                              case Status.ERROR:
                                return SfCircularChart(
                                  margin: const EdgeInsets.all(0),
                                  //   title: ChartTitle(text: 'Vehicle Status'),
                                  tooltipBehavior: _tooltip,
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: const Image(
                                          image: AssetImage(
                                              'assets/images/loading.gif'),
                                          height: 70,
                                          width: 70),
                                    )
                                  ],
                                  legend: legendProperties,
                                  palette: sfgPaletteColor,
                                  series: <CircularSeries>[
                                    DoughnutSeries<_ChartData, String>(
                                      onPointTap:
                                          (ChartPointDetails details) {},
                                      dataLabelSettings:
                                          vehicleStatusGraphLableSettings,
                                      dataSource: vehicleStatusCountdata,
                                      xValueMapper: (_ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                    )
                                  ],
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
                                groupList.addAll(
                                    value.getDeviceModelListResponse.data!);
                                for (var element in groupList) {
                                  devicesList.addAll(element.items!);
                                }
                                setDevicesStatusCounterss(devicesList);
                                saveDefaultFuelAverageForVehicle(
                                    vehiclesNamesIdMap);
                                print('Vehicle map length is ' +
                                    vehiclesNamesIdMap.length.toString());
                                vehicleStatusCountdata.clear();
                                vehicleStatusCountdata.add(_ChartData(
                                    'Running', runningCount.toInt()));
                                vehicleStatusCountdata.add(_ChartData(
                                    'Stopped', stoppedCount.toInt()));
                                vehicleStatusCountdata
                                    .add(_ChartData('Idle', idleCount.toInt()));
                                vehicleStatusCountdata.add(
                                    _ChartData('Offline', oflineCount.toInt()));
                                vehicleStatusCountdata.add(
                                    _ChartData('No Data', noDataCount.toInt()));
                                vehicleStatusCountdata.add(_ChartData(
                                    'Expired', expiredCount.toInt()));
                                return SfCircularChart(
                                  margin: const EdgeInsets.all(0),
                                  //  title: ChartTitle(text: 'Vehicle Status'),
                                  tooltipBehavior: _tooltip,
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: Text(
                                        devicesList.length.toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                            fontSize: 40),
                                      ),
                                    )
                                  ],
                                  legend: legendProperties,
                                  palette: sfgPaletteColor,
                                  series: <CircularSeries>[
                                    DoughnutSeries<_ChartData, String>(
                                      onPointTap: (ChartPointDetails details) {
                                        print(details.pointIndex);
                                        print(details.seriesIndex);

                                        navBarIndex = 1;

                                        Navigator.pushReplacementNamed(
                                            context, RoutesName.home);
                                      },
                                      dataLabelSettings:
                                          vehicleStatusGraphLableSettings,
                                      dataSource: vehicleStatusCountdata,
                                      xValueMapper: (_ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                    )
                                  ],
                                );
                              default:
                                return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  shape: AppColors.cardBorderShape,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Alerts (Today)',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.eventsScreen,
                                      arguments: EventsInitialData(
                                          deviceID: '',
                                          eventType: '',
                                          fromDate: '',
                                          toDate: '',
                                          pageNumber: ''));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 245, 207, 93),
                                        Color.fromARGB(255, 244, 183, 2),
                                      ],
                                    ),
                                    color: Colors.amber,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        AppColors.StatusDshboardBarborderRadius,
                                  ),
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          VerticalDivider(
                                            width: 4,
                                          ),
                                          Icon(
                                            Icons.notifications_active_outlined,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          VerticalDivider(width: 4),
                                          Text(
                                            'Total Alerts',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 15,
                                            child: ChangeNotifierProvider.value(
                                              value: eventViewModel,
                                              // create: (BuildContext context) =>
                                              //     eventViewModel,
                                              child: Consumer<EventViewModel>(
                                                builder:
                                                    (context, value, child) {
                                                  switch (value
                                                      .eventsAlertsResponse
                                                      .status) {
                                                    case Status.LOADING:
                                                      return const CircleAvatar(
                                                          child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ));
                                                    case Status.ERROR:
                                                      return const CircleAvatar(
                                                          child: Padding(
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Text('n/a',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ));
                                                    case Status.COMPLETED:
                                                      return CircleAvatar(
                                                        child: Text(
                                                          value
                                                              .eventsAlertsResponse
                                                              .data!
                                                              .items!
                                                              .total
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      );

                                                    default:
                                                      Text(value
                                                          .eventsAlertsResponse
                                                          .data!
                                                          .items!
                                                          .total
                                                          .toString());
                                                  }

                                                  return Container();
                                                },
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(width: 8),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 4, top: 8, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.eventsScreen,
                                      arguments: EventsInitialData(
                                          deviceID: '',
                                          eventType: 'zone_out',
                                          fromDate: '',
                                          toDate: '',
                                          pageNumber: ''));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 142, 101, 255),
                                        Colors.deepPurple,
                                      ],
                                    ),
                                    color: Colors.amber,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        AppColors.StatusDshboardBarborderRadius,
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.fence_outlined,
                                              color: Colors.white,
                                              size: 28,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Geofence',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ])),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value: eventViewModelGeoFence,
                                                // create: (BuildContext context) =>
                                                //     eventViewModelGeoFence,
                                                child: Consumer<EventViewModel>(
                                                  builder:
                                                      (context, value, child) {
                                                    switch (value
                                                        .eventsAlertsResponse
                                                        .status) {
                                                      case Status.LOADING:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ));
                                                      case Status.ERROR:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text('n/a',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ));
                                                      case Status.COMPLETED:
                                                        return CircleAvatar(
                                                          child: Text(
                                                            value
                                                                .eventsAlertsResponse
                                                                .data!
                                                                .items!
                                                                .total
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );

                                                      default:
                                                        Text(value
                                                            .eventsAlertsResponse
                                                            .data!
                                                            .items!
                                                            .total
                                                            .toString());
                                                    }

                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          ])),
                                    ],
                                  ),
                                  // width: MediaQuery.of(context).size.width * 0.45,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 8, top: 8, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.eventsScreen,
                                      arguments: EventsInitialData(
                                          deviceID: '',
                                          eventType: 'overspeed',
                                          fromDate: '',
                                          toDate: '',
                                          pageNumber: ''));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 142, 101, 255),
                                        Colors.deepPurple,
                                      ],
                                    ),
                                    color: Colors.blue,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        AppColors.StatusDshboardBarborderRadius,
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.speed,
                                              color: Colors.white,
                                              size: 28,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Overspeed',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ])),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value: eventViewModelOverSpeed,
                                                // create: (BuildContext context) =>
                                                //     eventViewModelOverSpeed,
                                                child: Consumer<EventViewModel>(
                                                  builder:
                                                      (context, value, child) {
                                                    switch (value
                                                        .eventsAlertsResponse
                                                        .status) {
                                                      case Status.LOADING:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ));
                                                      case Status.ERROR:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text('n/a',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ));
                                                      case Status.COMPLETED:
                                                        return CircleAvatar(
                                                          child: Text(
                                                            value
                                                                .eventsAlertsResponse
                                                                .data!
                                                                .items!
                                                                .total
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );

                                                      default:
                                                        Text(value
                                                            .eventsAlertsResponse
                                                            .data!
                                                            .items!
                                                            .total
                                                            .toString());
                                                    }

                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 4, top: 8, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.eventsScreen,
                                      arguments: EventsInitialData(
                                          deviceID: '',
                                          eventType: 'idle_duration',
                                          fromDate: '',
                                          toDate: '',
                                          pageNumber: ''));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 102, 198, 242),
                                        Colors.blueAccent,
                                      ],
                                    ),
                                    color: Colors.amber,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        AppColors.StatusDshboardBarborderRadius,
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.pause,
                                              color: Colors.white,
                                              size: 28,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Excess Idle',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ])),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value:
                                                    eventViewModelIdleDurations,
                                                // create: (BuildContext context) =>
                                                //     eventViewModelIdleDurations,
                                                child: Consumer<EventViewModel>(
                                                  builder:
                                                      (context, value, child) {
                                                    switch (value
                                                        .eventsAlertsResponse
                                                        .status) {
                                                      case Status.LOADING:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ));
                                                      case Status.ERROR:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text('n/a',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ));
                                                      case Status.COMPLETED:
                                                        return CircleAvatar(
                                                          child: Text(
                                                            value
                                                                .eventsAlertsResponse
                                                                .data!
                                                                .items!
                                                                .total
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );

                                                      default:
                                                        Text(value
                                                            .eventsAlertsResponse
                                                            .data!
                                                            .items!
                                                            .total
                                                            .toString());
                                                    }

                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          ])),
                                    ],
                                  ),
                                  // width: MediaQuery.of(context).size.width * 0.45,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 8, top: 8, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.eventsScreen,
                                      arguments: EventsInitialData(
                                          deviceID: '',
                                          eventType: 'distance',
                                          fromDate: '',
                                          toDate: '',
                                          pageNumber: ''));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 102, 198, 242),
                                        Colors.blueAccent,
                                      ],
                                    ),
                                    color: Colors.blue,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        AppColors.StatusDshboardBarborderRadius,
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.drive_eta,
                                              color: Colors.white,
                                              size: 28,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Excess Driving',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ])),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value:
                                                    eventViewModelExcessDrive,
                                                // create: (BuildContext context) =>
                                                //     eventViewModelOverSpeed,
                                                child: Consumer<EventViewModel>(
                                                  builder:
                                                      (context, value, child) {
                                                    switch (value
                                                        .eventsAlertsResponse
                                                        .status) {
                                                      case Status.LOADING:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ));
                                                      case Status.ERROR:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text('n/a',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ));
                                                      case Status.COMPLETED:
                                                        return CircleAvatar(
                                                          child: Text(
                                                            value
                                                                .eventsAlertsResponse
                                                                .data!
                                                                .items!
                                                                .total
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );

                                                      default:
                                                        Text(value
                                                            .eventsAlertsResponse
                                                            .data!
                                                            .items!
                                                            .total
                                                            .toString());
                                                    }

                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 4, top: 8, bottom: 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.eventsScreen,
                                      arguments: EventsInitialData(
                                          deviceID: '',
                                          eventType: 'custom',
                                          fromDate: '',
                                          toDate: '',
                                          pageNumber: ''));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 249, 100, 100),
                                        Colors.red,
                                      ],
                                    ),
                                    color: Colors.amber,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        AppColors.StatusDshboardBarborderRadius,
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.key,
                                              color: Colors.white,
                                              size: 28,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Ignition \n on/off',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ])),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value: eventViewModelCustom,
                                                // create: (BuildContext context) =>
                                                //     eventViewModelCustom,
                                                child: Consumer<EventViewModel>(
                                                  builder:
                                                      (context, value, child) {
                                                    switch (value
                                                        .eventsAlertsResponse
                                                        .status) {
                                                      case Status.LOADING:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ));
                                                      case Status.ERROR:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text('n/a',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ));
                                                      case Status.COMPLETED:
                                                        return CircleAvatar(
                                                          child: Text(
                                                            value
                                                                .eventsAlertsResponse
                                                                .data!
                                                                .items!
                                                                .total
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );

                                                      default:
                                                        Text(value
                                                            .eventsAlertsResponse
                                                            .data!
                                                            .items!
                                                            .total
                                                            .toString());
                                                    }

                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          ])),
                                    ],
                                  ),
                                  // width: MediaQuery.of(context).size.width * 0.45,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 8, top: 4, bottom: 4),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.eventsScreen,
                                      arguments: EventsInitialData(
                                          deviceID: '',
                                          eventType: 'stop_duration',
                                          fromDate: '',
                                          toDate: '',
                                          pageNumber: ''));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 249, 100, 100),
                                        Colors.red,
                                      ],
                                    ),
                                    color: Colors.blue,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        AppColors.StatusDshboardBarborderRadius,
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.local_parking_outlined,
                                              color: Colors.white,
                                              size: 28,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Parked',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ])),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child:
                                                  ChangeNotifierProvider.value(
                                                value:
                                                    eventViewModelStopDuration,
                                                // create: (BuildContext context) =>
                                                //     eventViewModelStopDuration,
                                                child: Consumer<EventViewModel>(
                                                  builder:
                                                      (context, value, child) {
                                                    switch (value
                                                        .eventsAlertsResponse
                                                        .status) {
                                                      case Status.LOADING:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ));
                                                      case Status.ERROR:
                                                        return const CircleAvatar(
                                                            child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Text('n/a',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ));
                                                      case Status.COMPLETED:
                                                        return CircleAvatar(
                                                          child: Text(
                                                            value
                                                                .eventsAlertsResponse
                                                                .data!
                                                                .items!
                                                                .total
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );

                                                      default:
                                                        Text(value
                                                            .eventsAlertsResponse
                                                            .data!
                                                            .items!
                                                            .total
                                                            .toString());
                                                    }

                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          ])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
            // Card(
            //       shape: AppColors.cardBorderShape,
            //       margin:
            //           const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 10, horizontal: 10),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             _controller.value.isInitialized
            //                 ? Center(
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(10.0),
            //                       child: SizedBox(
            //                         width:
            //                             MediaQuery.of(context).size.width * .85,
            //                         child: AspectRatio(
            //                           aspectRatio:
            //                               _controller.value.aspectRatio,
            //                           child: VideoPlayer(_controller),
            //                         ),
            //                       ),
            //                     ),
            //                   )
            //                 : const CircularProgressIndicator(),
            //           ],
            //         ),
            //       ),
            //     ),      const SizedBox(height: 10),
            
                Row(
                  children: [
                    Card(
                      shape: AppColors.cardBorderShape,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: const [
                                  Text(
                                    '!انتباہ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(height: 5),
                                  Text(
                                      'ٹریکر ڈیوائس موٹر انشورنس کے متبادل نہیں ہے اور نا ہی چوری کو روکنے کا آلہ ہے، کمپنی گاڑی چوری کی صورت میں زمہ دار نہیں ہوگی۔',
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName.vehiclereportlist);
                              },
                              child: Card(
                                shape: AppColors.cardBorderShape,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Reports',
                                        style: dashBoardHeadingStyle),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/Combo_Chart_96px.png'),
                                          height: 45,
                                          width: 45),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName.vehiclehistorylist);
                              },
                              child: Card(
                                shape: AppColors.cardBorderShape,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('History',
                                        style: dashBoardHeadingStyle),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/Time_Machine_96px.png'),
                                          height: 45,
                                          width: 45),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: InkWell(
                              onTap: () {
                                navBarIndex = 2;

                                Navigator.pushReplacementNamed(
                                    context, RoutesName.home);
                              },
                              child: Card(
                                shape: AppColors.cardBorderShape,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Vehicles',
                                        style: dashBoardHeadingStyle),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/Traffic_Jam_96px.png'),
                                          height: 45,
                                          width: 45),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName.viewVehicleFuelList);
                              },
                              child: Card(
                                shape: AppColors.cardBorderShape,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Fuel', style: dashBoardHeadingStyle),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/Gas_Station_96px.png'),
                                          height: 45,
                                          width: 45),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // Card(
                //   shape: AppColors.cardBorderShape,
                //   margin:
                //       const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       _controller.value.isInitialized
                //           ? Padding(
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 10, horizontal: 10),
                //               child: Center(
                //                 child: ClipRRect(
                //                   borderRadius: BorderRadius.circular(10.0),
                //                   child: SizedBox(
                //                     width:
                //                         MediaQuery.of(context).size.width * .85,
                //                     child: AspectRatio(
                //                       aspectRatio:
                //                           _controller.value.aspectRatio,
                //                       child: const Image(
                //                           fit: BoxFit.fill,
                //                           image: NetworkImage(
                //                               'http://103.31.82.31/images/ad.gif')),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             )
                //           : const CircularProgressIndicator(),
                //     ],
                //   ),
                // ),

                Container(
  margin: const EdgeInsets.symmetric(vertical: 10), // 👈 vertical spacing for both together
  child: Column(
    children: [
      InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesName.viewExpenseScreen,
            arguments: {'vehicleId': ''},
          );
        },
        child: Card(
          shape: AppColors.cardBorderShape,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      maxRadius: 16,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.attach_money_outlined),
                    ),
                    VerticalDivider(width: 6),
                    Text(
                      'Vehicle Expenses',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ChangeNotifierProvider.value(
                      value: expenseRecordViewModel,
                      child: Consumer<ExpenseRecordViewModel>(
                        builder: (context, viewModel, _) {
                          double totalAmount =
                              viewModel.calculateTotalAmount();
                          return Text('Rs.$totalAmount');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10), // space *between* the cards
      InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesName.viewMaintenanceSchedule,
          );
        },
        child: Card(
          shape: AppColors.cardBorderShape,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 16,
                      backgroundColor: Colors.red[800],
                      child: const Icon(Icons.car_repair),
                    ),
                    const VerticalDivider(width: 6),
                    const Text(
                      'Upcoming Maintenance',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 16,
                      child: ChangeNotifierProvider.value(
                        value: vehicleMaintenanceViewModel,
                        child: Consumer<VehicleMaintenanceViewModel>(
                          builder: (context, viewModel, _) {
                            return Text(viewModel.maintenanceList.length.toString());
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        RoutesName.addVehicleMaintenanceScreen,
                      ),
                      child: const CircleAvatar(
                        maxRadius: 16,
                        child: Text('+'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),

                // InkWell(
                //   onTap: () {
                //     Navigator.pushNamed(context, RoutesName.viewExpenseScreen,
                //         arguments: {'vehicleId': ''});
                //   },
                //   child: Card(
                //     shape: AppColors.cardBorderShape,
                //     margin: const EdgeInsets.symmetric(
                //       horizontal: 15,
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(
                //             children: const [
                //               CircleAvatar(
                //                   maxRadius: 16,
                //                   backgroundColor: Colors.blueAccent,
                //                   child: Icon(
                //                     Icons.attach_money_outlined,
                //                   )),
                //               VerticalDivider(
                //                 width: 6,
                //               ),
                //               Text(
                //                 'Vehicle Expenses',
                //                 style: TextStyle(
                //                     fontSize: 13,
                //                     color: Colors.black54,
                //                     fontWeight: FontWeight.bold),
                //               )
                //             ],
                //           ),
                //           Row(
                //             children: [
                //               ChangeNotifierProvider.value(
                //                 value: expenseRecordViewModel,
                //                 child: Consumer<ExpenseRecordViewModel>(
                //                   builder: (context, viewModel, _) {
                //                     double totalAmount =
                //                         viewModel.calculateTotalAmount();
                //                     return Text('Rs.$totalAmount');
                //                   },
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // InkWell(
                //   onTap: () {
                //     Navigator.pushNamed(
                //       context,
                //       RoutesName.viewMaintenanceSchedule,
                //     );
                //   },
                //   child: Card(
                //     shape: AppColors.cardBorderShape,
                //     margin: const EdgeInsets.symmetric(
                //       horizontal: 15,
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(
                //             children: [
                //               CircleAvatar(
                //                 maxRadius: 16,
                //                 backgroundColor: Colors.red[800],
                //                 child: const Icon(
                //                   Icons.car_repair,
                //                 ),
                //               ),
                //               const VerticalDivider(
                //                 width: 6,
                //               ),
                //               const Text(
                //                 'Upcoming Maintenance',
                //                 style: TextStyle(
                //                     fontSize: 13,
                //                     color: Colors.black54,
                //                     fontWeight: FontWeight.bold),
                //               )
                //             ],
                //           ),
                //           Row(
                //             children: [
                //               Row(
                //                 children: [
                //                   CircleAvatar(
                //                     maxRadius: 16,
                //                     child: ChangeNotifierProvider.value(
                //                       value: vehicleMaintenanceViewModel,
                //                       child:
                //                           Consumer<VehicleMaintenanceViewModel>(
                //                         builder: (context, viewModel, _) {
                //                           return Text(viewModel
                //                               .maintenanceList.length
                //                               .toString());
                //                         },
                //                       ),
                //                     ),
                //                   ),
                //                   const SizedBox(width: 3),
                //                   InkWell(
                //                       onTap: () => Navigator.pushNamed(
                //                           context,
                //                           RoutesName
                //                               .addVehicleMaintenanceScreen),
                //                       child: const CircleAvatar(
                //                           maxRadius: 16, child: Text('+'))),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
