import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({Key? key}) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  late GoogleMapController _googleMapController;
  late Marker uiControler;

  late Position currentPosition;
  var geoLocator = Geolocator();

  void _getCurrentLocation() async {
    Position currentPosition =
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            as Position;
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    CameraPosition newCameraPosition = CameraPosition(target: latLng, zoom: 15);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));

    print("--------------------------------------------------------");
    print(currentPosition.latitude.toString() + " latitude");
    print(currentPosition.longitude.toString() + " longitude");
    print("--------------------------------------------------------");
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(9.040558, 38.763039), // location of AAiT
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geolocation"),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        mapType: MapType.normal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("*******************************************************");
          getCurrentTag();
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
