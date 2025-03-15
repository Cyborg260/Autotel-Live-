import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackerapp/data/response/api_response.dart';
import 'package:trackerapp/models/device_on_map_model.dart';
import 'package:trackerapp/models/devices_model.dart';
import 'package:trackerapp/repository/devices_repository.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';
import 'package:trackerapp/res/helper/map_helper.dart';
import 'package:trackerapp/utils/routes/routes_name.dart';
import 'package:trackerapp/view_model/userlogin_view_model.dart';

class DeviceViewViewModel with ChangeNotifier {
  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  final _devicerepo = GetDevicesRepository();
  ApiResponse<DevicesModel> getDeviceModelResponse = ApiResponse.loading();
  ApiResponse<List<DevicesModel>> getDeviceModelListResponse =
      ApiResponse.loading();
  ApiResponse<List<Marker>> getDeviceListMarkers = ApiResponse.loading();

  List<Marker> markersListfromApi = [];
  List<BitmapDescriptor> iconList = [];
  int iconCounter = 0;
  setGetDevicesResponse(ApiResponse<DevicesModel> response) {
    getDeviceModelResponse = response;
    notifyListeners();
  }

  late String userApiKeyString;
  setGetDevicesListResponse(ApiResponse<List<DevicesModel>> response) {
    getDeviceModelListResponse = response;
    notifyListeners();
  }

  setClusterMarkers() {
    notifyListeners();
  }

  setGetDevicesListMarkers(ApiResponse<List<Marker>> response) {
    getDeviceListMarkers = response;

    notifyListeners();
  }

  // DevicesModel devicesModel = DevicesModel();
  UserLoginViewModel userLoginViewModel = UserLoginViewModel();
  Future<void> getDeviceDataFromApi() async {
    // setGetDevicesResponse(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    userApiKeyString = await userApiKey;
    _devicerepo.getDevicesApi(userApiKeyString).then((value) {
      setGetDevicesResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setGetDevicesResponse(ApiResponse.error(error.toString()));
      print(error.toString());
    });
  }

  Future<void> getDeviceDataListFromApi() async {
    //  setGetDevicesResponse(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    userApiKeyString = await userApiKey;
    _devicerepo.getDevicesListApi(userApiKeyString).then((value) {
      setGetDevicesListResponse(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setGetDevicesListResponse(ApiResponse.error(error.toString()));
      print(error.toString());
    });
  }

  Future<void> getDeviceMarkerListFromApi(BuildContext context) async {
    //setGetDevicesListMarkers(ApiResponse.loading());
    Future<String> userApiKey = userLoginViewModel.getUserApiHashString();
    userApiKeyString = await userApiKey;

    _devicerepo.getDevicesListApi(userApiKeyString).then((value) async {
      markersListfromApi.clear();
      iconList.clear();
      if (iconCounter >= iconList.length) {
        iconCounter = 0;
      }
      for (var group in value) {
        //print('gorup is is ' + value.indexOf(group).toString());
        for (var element in group.items!) {
          //  print('item id is ' + group.items!.indexOf(element).toString());
          // print(element['icon']['path'].toString());

          // MapHelper.getMarkerImageFromUrl(
          //         AppUrl.baseImgURL + element['icon']['path'].toString())
          //     .then((icon) {
          //   markersListfromApi.add(
          //     Marker(
          //       markerId: MarkerId(element['id'].toString()),
          //       rotation: double.parse(element['course'].toString()),
          //       icon: icon,
          //       position: LatLng(double.parse(element['lat'].toString()),
          //           double.parse(element['lng'].toString())),
          //       infoWindow: InfoWindow(
          //         title: element['name'].toString(),
          //         snippet: element['icon']['path'].toString(),
          //       ),
          //       onTap: () {
          //         Navigator.pushNamed(
          //           context,
          //           RoutesName.singledevicemap,
          //           arguments: DeviceOnMapintialData(
          //               groupID: value.indexOf(group),
          //               itemID: group.items!.indexOf(element),
          //               intialLat: double.parse(element['lat'].toString()),
          //               intiallng: double.parse(element['lng'].toString()),
          //               intialdirection:
          //                   double.parse(element['course'].toString()),
          //               deviceId: element['id'],
          //               markerImage: icon),
          //         );
          //       },
          //     ),
          //   );
          // });
          BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            'assets/images/car_icon6.png',
          ).then((icon) {
            markersListfromApi.add(
              Marker(
                markerId: MarkerId(element['id'].toString()),
                rotation: double.parse(element['course'].toString()),
                icon: icon,
                position: LatLng(double.parse(element['lat'].toString()),
                    double.parse(element['lng'].toString())),
                infoWindow: InfoWindow(
                  title: element['name'].toString(),
                  snippet: element['icon']['path'].toString(),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.singledevicemap,
                    arguments: DeviceOnMapintialData(
                        groupID: value.indexOf(group),
                        itemID: group.items!.indexOf(element),
                        intialLat: double.parse(element['lat'].toString()),
                        intiallng: double.parse(element['lng'].toString()),
                        intialdirection:
                            double.parse(element['course'].toString()),
                        deviceId: element['id'],
                        markerImage: icon),
                  );
                },
              ),
            );
          });
        }
      }

      setGetDevicesListMarkers(ApiResponse.complete(markersListfromApi));
    }).onError((error, stackTrace) {
      setGetDevicesListMarkers(ApiResponse.error(error.toString()));
    });
  }
}
