//Setting dummies values
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_marker_animation/core/anilocation_task_description.dart';
import 'package:google_map_marker_animation/core/ripple_marker.dart';
import 'package:google_map_marker_animation/widgets/animarker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kStartPosition = LatLng(24.944715555556, 67.0951);
late double currentZoom;
final kSantoDomingo = CameraPosition(target: kStartPosition, zoom: currentZoom);
const kMarkerId = MarkerId('MarkerId1');
const kDuration = Duration(seconds: 5);
const kLocations = [
  // LatLng(25.000184, 67.069116),
  // LatLng(25.00025, 67.0699),
  // LatLng(25.0003, 67.071352),
  // LatLng(25.0004, 67.073012),
  // LatLng(25.00045, 67.074096),
  // LatLng(25.000516, 67.075348)
  // LatLng(24.853134, 67.193184),
  // LatLng(24.853532, 67.1956),
  // LatLng(24.8537, 67.196584),
  // LatLng(24.853532, 67.196704),
  // LatLng(24.853332, 67.196688),
  // LatLng(24.8517, 67.196928),
  LatLng(24.944715555556, 67.0951),
  LatLng(24.944885555556, 67.095277777778),
  LatLng(24.945010555556, 67.095467777778),
  LatLng(24.945165555556, 67.095645),
  LatLng(24.945290555556, 67.095845555556),
  LatLng(24.94547, 67.095790555556)
];
// LatLng(24.853134, 67.193184), LatLng(24.853532, 67.1956), LatLng(24.8537, 67.196584), LatLng(24.853532, 67.196704), LatLng(24.853332, 67.196688), LatLng(24.8517, 67.196928)

class SimpleMarkerAnimationExample extends StatefulWidget {
  const SimpleMarkerAnimationExample({super.key});

  @override
  SimpleMarkerAnimationExampleState createState() =>
      SimpleMarkerAnimationExampleState();
}

class SimpleMarkerAnimationExampleState
    extends State<SimpleMarkerAnimationExample> {
  final animationMarkers = <MarkerId, Marker>{};
  final animationController = Completer<GoogleMapController>();
  final stream = Stream.periodic(kDuration, (count) => kLocations[count])
      .take(kLocations.length);

  int locationCounter = 0;
  setLocationCounter() {
    locationCounter = locationCounter + 1;
  }

  currentMapStatus(CameraPosition position) {
    currentZoom = position.zoom;
  }

  @override
  void initState() {
    // stream.forEach((value) {
    //   newLocationUpdate(value);
    //   print(value);
    // });
    newLocationUpdate(LatLng(24.944715555556, 67.0951));
    currentZoom = 17;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Markers Animation Example',
      home: Scaffold(
        body: Animarker(
          shouldAnimateCamera: true,
          zoom: currentZoom,
          curve: Curves.easeIn,
          onStopover: (latLng) {
            print('i have finished to move ' + latLng.latitude.toString());
            return Future.value();
          },
          onMarkerAnimationListener: (p0) {
            //   print('Now animating');
          },
          duration: const Duration(seconds: 1),
          mapId: animationController.future
              .then<int>((value) => value.mapId), //Grab Google Map Id
          markers: animationMarkers.values.toSet(),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kSantoDomingo,
            onCameraMove: currentMapStatus,
            onMapCreated: (gController) => animationController.complete(
                gController), //Complete the future GoogleMapController
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            newLocationUpdate(kLocations[locationCounter]);
            // locationCounter = locationCounter + 1;
          },
          child: Icon(Icons.abc),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }

  void newLocationUpdate(LatLng latLng) {
    var marker = Marker(
      markerId: kMarkerId,
      position: latLng,
    );
    locationCounter = locationCounter + 1;
    if (locationCounter == kLocations.length) {
      locationCounter = 0;
    }
    setState(() {
      animationMarkers[kMarkerId] = marker;
      //  print('Marker length is ' + animationMarkers.toString());
      //print('Marker id is ' + kMarkerId.toString());
    });
  }
}
