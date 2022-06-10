import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  late LatLng currentLocation;
  late double longitude;
  late double latitude;
  late String userEmail;
  late var timeStamp;
  late bool onRegion;

  Location();

  Future fetchCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    currentLocation = latLng;
    latitude = currentLocation.latitude.toDouble();
    longitude = currentLocation.longitude.toDouble();

    return latLng;
  }

  late Map<String, dynamic> locationMap = {
    'longitude': longitude,
    'latitude': latitude,
    'userEmail': userEmail,
    'timeStamp': timeStamp,
    'onRegion': onRegion,
  };
}
