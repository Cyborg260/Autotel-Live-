import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoFenceOnMapScreen extends StatefulWidget {
  const GeoFenceOnMapScreen({super.key});

  @override
  State<GeoFenceOnMapScreen> createState() => _GeoFenceOnMapScreenState();
}

class _GeoFenceOnMapScreenState extends State<GeoFenceOnMapScreen> {
  final List<Marker> _markers = [];
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(34.00, 45.99))),
    );
  }
}
