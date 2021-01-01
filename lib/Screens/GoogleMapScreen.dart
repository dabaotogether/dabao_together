import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  static const String id = 'google_map_screen';
  @override
  State<GoogleMapScreen> createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    double lat = 0;
    double lon = 0;
    Set<Marker> markerSet = Set<Marker>();

    if (args != null) {
      lat = args['latitude'];
      lon = args['longitude'];
    }
    markerSet.add(Marker(
      position: LatLng(lat, lon),
      markerId: MarkerId('0'),
    ));
    return new Scaffold(
      appBar: AppBar(title: Text('Your Kaki\'s location')),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: markerSet,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lon),
          zoom: 18,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
