import 'package:ems/Widget/EmsColor.dart';
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
  final LatLng point1 = const LatLng(9.039871, 38.762031);
  final LatLng point2 = const LatLng(9.039651, 38.761204);
  final LatLng point3 = const LatLng(9.040687, 38.760914);
  final LatLng point4 = const LatLng(9.040948, 38.761777);

  final Set<Polyline> _polyLine = {};
  final Set<Marker> _marker = {};

  late Position currentPosition;
  var geoLocator = Geolocator();
  LatLng currentLocation = const LatLng(9.039871, 38.762031);

  void _getCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    CameraPosition newCameraPosition = CameraPosition(target: latLng, zoom: 20);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    setState(() {
      currentLocation = latLng;
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(9.039871, 38.762031), // location of AAiT
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    _drawPolyLine();
    _markCurrentPosition();
    // var points = <LatLng>[point1, point2, point3, point4, point1];
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        mapType: MapType.normal,
        polylines: _polyLine,
        markers: _marker,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        backgroundColor: EmsColor.backgroundColor,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  void _markCurrentPosition() {
    _marker.add(Marker(
        markerId: const MarkerId("origin"),
        position: currentLocation,
        icon: BitmapDescriptor.defaultMarker));
  }

  void _drawPolyLine() {
    List<LatLng> point = [point1, point2, point3, point4, point1];
    _polyLine.add(Polyline(
        polylineId: const PolylineId('value'),
        points: point,
        visible: true,
        color: const Color.fromARGB(255, 223, 58, 3),
        width: 5));
  }
}
