import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GoogleMap extends StatefulWidget {
  const GoogleMap({Key? key}) : super(key: key);

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  late LatLng latLng;
  final LatLng point1 = LatLng(9.0410975, 38.7632006);
  final LatLng point2 = LatLng(9.0410976, 38.7632006);
  final LatLng point3 = LatLng(9.0410976, 38.7632006);
  final LatLng point4 = LatLng(9.0410976, 38.7632006);

  @override
  void initState() {
    _getCurrentLocation().then((value) {
      setState(() {
        latLng = value;
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
    return latLng;
  }

  @override
  Widget build(BuildContext context) {
    var points = <LatLng>[point1, point2, point3, point4];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My location"),
        backgroundColor: Colors.indigo,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _getCurrentLocation(),
        },
        child: const Icon(Icons.my_location),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: latLng,
          zoom: 10.0,
          interactiveFlags: InteractiveFlag.all,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/leuliance/cks5wzgmr4njz18qqhza1ttbn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGV1bGlhbmNlIiwiYSI6ImNrOWx0NjZtNjA0MmczZW53dzJoNjEyNG8ifQ.nLWEIxguUOiIOn8cirrfOQ",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoibGV1bGlhbmNlIiwiYSI6ImNrOWx0NjZtNjA0MmczZW53dzJoNjEyNG8ifQ.nLWEIxguUOiIOn8cirrfOQ',
                'id': 'mapbox.mapbox-streets-v8'
              }),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 60.0,
                height: 60.0,
                point: LatLng(9.0410975, 38.7632006),
                builder: (ctx) => GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.fmd_good_sharp,
                    color: Colors.green[600],
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
              color: Colors.red,
            )
          ])
        ],
      ),
    );
  }
}
