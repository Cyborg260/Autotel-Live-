import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/res/components/app_endpoit.dart';
import 'package:trackerapp/res/helper/map_helper.dart';
import 'package:trackerapp/res/helper/map_marker.dart';
import 'package:trackerapp/res/helper/map_marker_design.dart';
import 'package:trackerapp/utils/utils.dart';
import 'package:trackerapp/view_model/device_view_viewmodel.dart';

class DevicesOnMap extends StatefulWidget {
  const DevicesOnMap({super.key});

  @override
  State<DevicesOnMap> createState() => _DevicesOnMapState();
}

class _DevicesOnMapState extends State<DevicesOnMap> {
  Set<Marker> markers = {};
  DeviceViewViewModel deviceViewViewModel3 = DeviceViewViewModel();
  Utils myUtils = Utils();
  MapType currentMapType = MapType.normal;
  bool enableTraffic = false;
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController myController;

  late double currentZoomLevel;

  final List<Marker?> my_Markers = [];

  final Set<Marker> _markers = Set();

  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;

  Fluster<MapMarker>? _clusterManager;
  double _currentZoom = 15;

  bool _isMapLoading = false;
  bool _areMarkersLoading = true;

  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';
  final Color _clusterColor = Colors.blue;
  final Color _clusterTextColor = Colors.white;

  @override
  void initState() {
    super.initState();
    deviceViewViewModel3.getDeviceMarkerListFromApi(context);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _completer.complete(controller);
    myController = controller;
    setState(() {
      _isMapLoading = false;
    });
  }

  Future<void> animateCamera(double zoomLevel) async {
    CameraPosition myCameraPosition = CameraPosition(
        target: const LatLng(30.219696, 66.982138), zoom: zoomLevel);

    myController.animateCamera(
      CameraUpdate.newCameraPosition(myCameraPosition),
    );
  }

  void _initMarkers(List<Marker> markerList) async {
    final List<MapMarker> markers = [];

    for (Marker marker in markerList) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(
              AppUrl.baseImgURL + marker.infoWindow.snippet.toString());
      BitmapDescriptor markerImageWithTitle =
          await MapMarkerMaker.getMarkerIcon(
              AppUrl.baseImgURL + marker.infoWindow.snippet.toString(),
              marker.infoWindow.title.toString(),
              Colors.red,
              marker.rotation,
              true);

      markers.add(
        MapMarker(
          id: marker.markerId.toString(),
          position: marker.position,
          icon: markerImageWithTitle,
          rotation: marker.rotation,
          onTap: () => marker.onTap!.call(),
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    setState(() {
      _markers
        ..clear()
        ..addAll(updatedMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ChangeNotifierProvider<DeviceViewViewModel>(
              create: (BuildContext context) => deviceViewViewModel3,
              child: Consumer<DeviceViewViewModel>(
                builder: (context, value, child) {
                  switch (value.getDeviceListMarkers.status!) {
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
                      my_Markers.clear();
                      my_Markers.addAll(value.getDeviceListMarkers.data!);

                      _initMarkers(my_Markers.cast<Marker>().toList());
                      return Expanded(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: GoogleMap(
                                initialCameraPosition: const CameraPosition(
                                    target: LatLng(30.229696, 66.982138),
                                    zoom: 6),
                                onMapCreated: _onMapCreated,
                                mapType: currentMapType,
                                compassEnabled: false,
                                trafficEnabled: enableTraffic,
                                mapToolbarEnabled: true,
                                zoomControlsEnabled: true,
                                onCameraMove: (position) =>
                                    _updateMarkers(position.zoom),
                                markers: _markers,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(220, 255, 255, 255),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: GFSearchBar(
                                searchList: my_Markers,
                                searchQueryBuilder: (query, list) {
                                  return list
                                      .where((item) => item!.infoWindow.title
                                          .toString()
                                          .toLowerCase()
                                          .contains(query.toLowerCase()))
                                      .toList();
                                },
                                overlaySearchListHeight:
                                    MediaQuery.of(context).size.height * 0.60,
                                noItemsFoundWidget: const ListTile(
                                    title: Text(
                                        'No Vehicle found...Please search again')),
                                overlaySearchListItemBuilder: (item) {
                                  return ListTile(
                                    title:
                                        Text(item!.infoWindow.title.toString()),
                                    trailing: const Icon(Icons.arrow_forward),
                                    leading: const Icon(Icons.directions_car),
                                  );
                                },
                                searchBoxInputDecoration: const InputDecoration(
                                  hintText: 'Search vehicle...',
                                  iconColor: Colors.amber,
                                  prefixIcon: Icon(
                                    Icons.search,
                                  ),
                                ),
                                onItemSelected: (item) => item!.onTap!.call(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 150,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FloatingActionButton(
                                        mini: true,
                                        backgroundColor: AppColors.buttonColor,
                                        onPressed: () {
                                          setState(() {
                                            currentMapType =
                                                currentMapType == MapType.normal
                                                    ? MapType.hybrid
                                                    : MapType.normal;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.map,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FloatingActionButton(
                                        backgroundColor: enableTraffic == false
                                            ? AppColors.buttonColor
                                            : Colors.green,
                                        mini: true,
                                        child: const Icon(
                                          Icons.traffic,
                                          color: Colors.black54,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            enableTraffic = !enableTraffic;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
