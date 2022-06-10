import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/Location%20.dart';
import 'package:ems/Services/Loading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GoogleMapInforamtion extends StatefulWidget {
  const GoogleMapInforamtion({Key? key}) : super(key: key);

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapInforamtion> {
  late LatLng myCurrentLocation;
  final LatLng point1 = LatLng(9.039871, 38.762031);
  final LatLng point2 = LatLng(9.039651, 38.761204);
  final LatLng point3 = LatLng(9.040687, 38.760914);
  final LatLng point4 = LatLng(9.040948, 38.761777);

  //final Boundary _boundary = Boundary();
  final Location _location = Location();

  CollectionReference location =
      FirebaseFirestore.instance.collection("Location");

  bool loading = true;

  @override
  void initState() {
    _fetchCurrentLocation().then((value) {
      setState(() {
        myCurrentLocation = value;
        loading = false;
      });
    });
    super.initState();
  }

  Future _fetchCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    return latLng;
  }

  @override
  Widget build(BuildContext context) {
    var points = <LatLng>[point1, point2, point3, point4, point1];

    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text("My location"),
              backgroundColor: const Color.fromARGB(255, 24, 30, 68),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                _location.fetchCurrentLocation(),
              },
              child: const Icon(Icons.my_location),
            ),
            body: FlutterMap(
              options: MapOptions(
                center: point1,
                zoom: 20.0,
                interactiveFlags: InteractiveFlag.all,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/anwarkedir89/cl42gumrk001b15phpmfyiser/tiles/256/%7Bz%7D/%7Bx%7D/%7By%7D@2x?access_token=pk.eyJ1IjoiYW53YXJrZWRpcjg5IiwiYSI6ImNrejZ6a3pyNTBlcHMyd3Ftdmg2eDF5eWcifQ.rj45VUnAEsIYGT02z0eDEw",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoiYW53YXJrZWRpcjg5IiwiYSI6ImNrejZ6a3pyNTBlcHMyd3Ftdmg2eDF5eWcifQ.rj45VUnAEsIYGT02z0eDEw',
                      'id': 'mapbox.satellite'
                    }),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 60.0,
                      height: 60.0,
                      point: myCurrentLocation,
                      builder: (ctx) => GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.fmd_good_sharp,
                          color: Color.fromARGB(255, 31, 199, 39),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                PolylineLayerOptions(polylines: [
                  Polyline(
                    points: points,
                    strokeWidth: 3.0,
                    color: const Color.fromARGB(255, 148, 51, 44),
                  )
                ])
              ],
            ),
          );
  }
}
