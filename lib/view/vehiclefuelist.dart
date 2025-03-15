import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/device_history_on_map.dart';
import 'package:trackerapp/models/devices_model.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view/customehistory.dart';
import 'package:trackerapp/view_model/device_history_view_model.dart';
import 'package:trackerapp/view_model/device_view_viewmodel.dart';

class VehicleFuelListScreen extends StatefulWidget {
  const VehicleFuelListScreen({super.key});

  @override
  State<VehicleFuelListScreen> createState() => _VehicleFuelListScreenState();
}

class _VehicleFuelListScreenState extends State<VehicleFuelListScreen> {
  DeviceViewViewModel deviceViewViewModelHistoryList = DeviceViewViewModel();
  DeviceHistoryViewModel deviceHistoryViewModellist = DeviceHistoryViewModel();
  late bool isList;
  late List<DevicesModel> groupList = [];
  late List<dynamic> devicesList = [];
  final List<Map<String, dynamic>> _allVehicles = [];
  bool isVehicleListLoaded = false;
  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundVehicles = [];
  @override
  void initState() {
    deviceViewViewModelHistoryList.getDeviceDataListFromApi();

    _foundVehicles = _allVehicles;
    super.initState();
  }

  Future<void> showDatePickerDialog(
      BuildContext context, String screenRout, int deviceID) {
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
              CustomeHistoryDateTimePicker(deviceID, screenRout),
            ],
          ),
        ),
      ),
    );
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all vehciles
      results = _allVehicles;
    } else {
      results = _allVehicles
          .where((vehcile) => vehcile["name"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI

    _foundVehicles = results;
    deviceHistoryViewModellist.setHistorySearchList();
    isVehicleListLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppColors.appScreenBackgroundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Fuel Report',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search Vehicle',
                    suffixIcon: Icon(Icons.search)),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChangeNotifierProvider<DeviceViewViewModel>(
                    create: (BuildContext context) =>
                        deviceViewViewModelHistoryList,
                    child: Consumer<DeviceViewViewModel>(
                      builder: (context, value, child) {
                        switch (value.getDeviceModelListResponse.status) {
                          case Status.LOADING:
                            return const Center(
                              child: Image(
                                  image:
                                      AssetImage('assets/images/loading.gif'),
                                  width: 100,
                                  height: 100),
                            );
                          case Status.ERROR:
                            return Center(child: Text(AppColors.errorMessage));
                          case Status.COMPLETED:
                            _allVehicles.clear();
                            _foundVehicles.clear();
                            groupList.clear();
                            devicesList.clear();
                            groupList
                                .addAll(value.getDeviceModelListResponse.data!);
                            for (var element in groupList) {
                              devicesList.addAll(element.items!);
                            }
                            for (var device in devicesList) {
                              _allVehicles.add({
                                "id": device['id'],
                                "name": device['name'],
                                "iconPath": device['icon']['path']
                              });
                            }
                            Future.delayed(Duration.zero, () {
                              _runFilter('');
                            });

                            return Container();

                          default:
                            return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            ChangeNotifierProvider<DeviceHistoryViewModel>(
              create: (context) => deviceHistoryViewModellist,
              child: Consumer<DeviceHistoryViewModel>(
                builder: (context, value, child) {
                  return Expanded(
                    child: _foundVehicles.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _foundVehicles.length,
                            itemBuilder: (context, index) => Card(
                              shape: AppColors.cardBorderShape,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 9),
                              child: Column(
                                children: [
                                  // ListTile(
                                  //   trailing: Text(_foundVehicles[index]["name"]),
                                  //   leading: Text(
                                  //     _foundVehicles[index]["id"].toString(),
                                  //     style: const TextStyle(fontSize: 24),
                                  //   ),
                                  //   title: Text(_foundVehicles[index]['name']),
                                  //   subtitle: Text(
                                  //       '${_foundVehicles[index]["age"].toString()} years old'),
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                minRadius: 20,
                                                maxRadius: 25,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Image(
                                                    fit: BoxFit.fitHeight,
                                                    image: NetworkImage(AppUrl
                                                            .baseImgURL +
                                                        _foundVehicles[index]
                                                            ["iconPath"]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const VerticalDivider(
                                                thickness: 40),
                                            Text(
                                              _foundVehicles[index]["name"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: PopupMenuButton(
                                          shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                AppColors.popupmenuborder,
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
                                                  RoutesName
                                                      .viewVehicleFuelReport,
                                                  arguments:
                                                      DeviceHistoryOnMapIntialData(
                                                          deviceTitle:
                                                              _foundVehicles[
                                                                      index]
                                                                  ['name'],
                                                          deviceId:
                                                              _foundVehicles[
                                                                  index]['id'],
                                                          fromDate: fromDate,
                                                          toDate: toDate,
                                                          fromTime: fromTime,
                                                          toTime: toTime),
                                                );
                                                break;

                                              case 1:
                                                toDate = newFormat.format(
                                                    dt.subtract(const Duration(
                                                        days: 1)));
                                                fromDate = newFormat.format(
                                                    dt.subtract(const Duration(
                                                        days: 1)));
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutesName
                                                      .viewVehicleFuelReport,
                                                  arguments:
                                                      DeviceHistoryOnMapIntialData(
                                                          deviceTitle:
                                                              _foundVehicles[
                                                                      index]
                                                                  ['name'],
                                                          deviceId:
                                                              _foundVehicles[
                                                                  index]['id'],
                                                          fromDate: fromDate,
                                                          toDate: toDate,
                                                          fromTime: fromTime,
                                                          toTime: toTime),
                                                );
                                                break;
                                              case 7:
                                                toDate = newFormat.format(dt);
                                                fromDate = newFormat.format(
                                                    dt.subtract(const Duration(
                                                        days: 7)));
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutesName
                                                      .viewVehicleFuelReport,
                                                  arguments:
                                                      DeviceHistoryOnMapIntialData(
                                                          deviceTitle:
                                                              _foundVehicles[
                                                                      index]
                                                                  ['name'],
                                                          deviceId:
                                                              _foundVehicles[
                                                                  index]['id'],
                                                          fromDate: fromDate,
                                                          toDate: toDate,
                                                          fromTime: fromTime,
                                                          toTime: toTime),
                                                );
                                                break;
                                              case 30:
                                                toDate = newFormat.format(dt);
                                                fromDate = newFormat.format(
                                                    dt.subtract(const Duration(
                                                        days: 30)));
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutesName
                                                      .viewVehicleFuelReport,
                                                  arguments:
                                                      DeviceHistoryOnMapIntialData(
                                                          deviceTitle:
                                                              _foundVehicles[
                                                                      index]
                                                                  ['name'],
                                                          deviceId:
                                                              _foundVehicles[
                                                                  index]['id'],
                                                          fromDate: fromDate,
                                                          toDate: toDate,
                                                          fromTime: fromTime,
                                                          toTime: toTime),
                                                );
                                                break;
                                              case 2:
                                                showDatePickerDialog(
                                                    context,
                                                    'playroutonmap',
                                                    _foundVehicles[index]
                                                        ['id']);
                                                break;

                                              default:
                                                toDate = newFormat.format(dt);
                                                fromDate = newFormat.format(dt);
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutesName
                                                      .viewVehicleFuelReport,
                                                  arguments:
                                                      DeviceHistoryOnMapIntialData(
                                                          deviceTitle:
                                                              _foundVehicles[
                                                                      index]
                                                                  ['name'],
                                                          deviceId:
                                                              _foundVehicles[
                                                                  index]['id'],
                                                          fromDate: fromDate,
                                                          toDate: toDate,
                                                          fromTime: fromTime,
                                                          toTime: toTime),
                                                );
                                            }
                                          }),
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : isVehicleListLoaded
                            ? const Text(
                                'No Vehicle found',
                                style: TextStyle(fontSize: 14),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Locading...'),
                              ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
