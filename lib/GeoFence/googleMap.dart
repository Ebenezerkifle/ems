import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/GeoFence/boundary_check.dart';
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
  late LatLng latLng;
  final LatLng point1 = LatLng(9.0401445, 38.761665);
  final LatLng point2 = LatLng(9.0401417, 38.7616608);
  final LatLng point3 = LatLng(9.0401224, 38.7616357);
  final LatLng point4 = LatLng(9.0401061, 38.7615946);

  Boundary boundary = Boundary();

  CollectionReference location =
      FirebaseFirestore.instance.collection("Location");

  bool loading = true;

  @override
  void initState() {
    _getCurrentLocation().then((value) {
      setState(() {
        latLng = value;
        loading = false;
      });
    });
    super.initState();
  }

  Future _getCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);

    print("--------------------------------------------------------");
    print(currentPosition.latitude.toString() + " latitude");
    print(currentPosition.longitude.toString() + " longitude");
    print("--------------------------------------------------------");

    // double latitude = currentPosition.latitude.toDouble();
    // double longitude = currentPosition.longitude.toDouble();

    // location.add(
    //     {'latitude': latitude, 'longitude': longitude, 'time': DateTime.now()});

    return latLng;
  }

  @override
  Widget build(BuildContext context) {
    var points = <LatLng>[point1, point2, point3, point4];

    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text("My location"),
              backgroundColor: const Color.fromARGB(255, 24, 30, 68),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                _getCurrentLocation(),
              },
              child: const Icon(Icons.my_location),
            ),
            body: FlutterMap(
              options: MapOptions(
                center: LatLng(9.0401061, 38.7615946),
                zoom: 40.0,
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
                      point: LatLng(9.0401061, 38.7615946),
                      builder: (ctx) => GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.fmd_good_sharp,
                          color: Color.fromARGB(255, 31, 199, 39),
                          size: 20,
                        ),
                      ),
                    ),
                    // Marker(
                    //   width: 60.0,
                    //   height: 60.0,
                    //   point: LatLng(9.0400975, 38.7632006),
                    //   builder: (ctx) => GestureDetector(
                    //     onTap: () {},
                    //     child: Icon(
                    //       Icons.fmd_good_sharp,
                    //       color: Colors.green[600],
                    //       size: 20,
                    //     ),
                    //   ),
                    // ),
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
