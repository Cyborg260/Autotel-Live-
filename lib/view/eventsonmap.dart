import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/data/response/status.dart';
import 'package:trackerapp/models/event_on_map_model.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:trackerapp/utils/routes/custom_page_route.dart'; // Import the custom page route
import 'package:trackerapp/view_model/osmaddress_view_view_model.dart';

class EventsOnMap extends StatefulWidget {
  final EventOnMapDataModel eventOnMapDataModel;
  EventsOnMap(this.eventOnMapDataModel, {super.key});

  @override
  State<EventsOnMap> createState() => _EventsOnMapState();
}

class _EventsOnMapState extends State<EventsOnMap> {
  final List<Marker> _markers = [];

  final OsmAddressViewModel osmAddressViewModel = OsmAddressViewModel();
  late GoogleMapController _controller;

  @override
  void dispose() {
    _controller.dispose(); // _controller is an instance of GoogleMapController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    osmAddressViewModel.fetchOsmAddress(
        double.parse(widget.eventOnMapDataModel.intialLat.toString()),
        double.parse(widget.eventOnMapDataModel.intiallng.toString()));
    _markers.add(Marker(
      markerId: const MarkerId('1'),
      position: LatLng(
          double.parse(widget.eventOnMapDataModel.intialLat.toString()),
          double.parse(widget.eventOnMapDataModel.intiallng.toString())),
      infoWindow: InfoWindow(title: widget.eventOnMapDataModel.vehiclename),
      icon: BitmapDescriptor.defaultMarker,
    ));
    print(widget.eventOnMapDataModel.vehiclename);

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          print('I am exiting..');
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                minMaxZoomPreference: const MinMaxZoomPreference(1, 21),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      double.parse(
                          widget.eventOnMapDataModel.intialLat.toString()),
                      double.parse(
                          widget.eventOnMapDataModel.intiallng.toString())),
                  zoom: 15,
                ),
                onCameraMove: (position) {},
                markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _controller.showMarkerInfoWindow(const MarkerId('1'));
                },
                padding: const EdgeInsets.only(bottom: 70, right: 7),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(220, 212, 2, 2),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.notifications_active_outlined,
                                size: 40,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(children: [
                                Expanded(
                                  child: Text(
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    widget.eventOnMapDataModel.message
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(children: [
                                Text(
                                  widget.eventOnMapDataModel.eventtime
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                              const SizedBox(
                                height: 5,
                              ),
                              ChangeNotifierProvider<OsmAddressViewModel>(
                                create: (BuildContext addresscontext) =>
                                    osmAddressViewModel,
                                child: Consumer<OsmAddressViewModel>(
                                  builder: (addresscontext, value, child) {
                                    if (value.osmAddressResponse.status ==
                                        null) {
                                      return Container();
                                    }
                                    switch (value.osmAddressResponse.status) {
                                      case Status.LOADING:
                                        return const Text('Loading');
                                      case Status.ERROR:
                                        return const Text(
                                            AppColors.errorMessage);
                                      case Status.COMPLETED:
                                        final displayName = value
                                                .osmAddressResponse
                                                .data
                                                ?.features?[0]
                                                .properties
                                                ?.displayName
                                                ?.toString() ??
                                            'Unknown';
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                displayName,
                                                softWrap: true,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
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
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.eventOnMapDataModel.speed.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'km/h',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            mini: true,
            backgroundColor: AppColors.buttonColor,
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
    );
  }
}

// Navigate to EventsOnMap using FadePageRoute
void navigateToEventsOnMap(
    BuildContext context, EventOnMapDataModel eventOnMapDataModel) {
  Navigator.push(
    context,
    FadePageRoute(page: EventsOnMap(eventOnMapDataModel)),
  );
}
