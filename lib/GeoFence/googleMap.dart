import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class GoogleMap extends StatefulWidget {
  const GoogleMap({Key? key}) : super(key: key);

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(8.9886, 38.7878),
        zoom: 8.0,
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
              point: LatLng(8.9886, 38.7878),
              builder: (ctx) => GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.fmd_good_sharp,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
            ),
            Marker(
              width: 60.0,
              height: 60.0,
              point: LatLng(8.9886, 38.7878),
              builder: (ctx) => GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.fmd_good_sharp,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
