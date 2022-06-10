import 'package:google_maps_flutter/google_maps_flutter.dart';

class Boundary {
  final LatLng point1 = const LatLng(9.039871, 38.762031);
  final LatLng point2 = const LatLng(9.039651, 38.761204);
  final LatLng point3 = const LatLng(9.040687, 38.760914);
  final LatLng point4 = const LatLng(9.040948, 38.761777);

  // Boundary({
  //   required this.point1,
  //   required this.point2,
  //   required this.point3,
  //   required this.point4,
  // });

  Boundary();

  bool checkBoundary(LatLng currentLocation) {
    bool onRegion = false;

    double x1, x2, x3, x4, y1, y2, y3, y4, xp, yp;

    xp = currentLocation.latitude.toDouble();
    yp = currentLocation.longitude.toDouble();

    x1 = point1.latitude.toDouble();
    y1 = point1.longitude.toDouble();
    x2 = point2.latitude.toDouble();
    y2 = point2.longitude.toDouble();
    x3 = point3.latitude.toDouble();
    y3 = point3.longitude.toDouble();
    x4 = point4.latitude.toDouble();
    y4 = point4.longitude.toDouble();

    double area1 = x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2); //1,2,3
    double area2 = x1 * (y4 - y3) + x4 * (y3 - y1) + x3 * (y1 - y4); // 1,4,3

    double totalArea = (area1.abs() + area2.abs());

    double areaABP = (x1 * (y2 - yp) + x2 * (yp - y1) + xp * (y1 - y2)); //1,2,p
    double areaBCP = (x2 * (y3 - yp) + x3 * (yp - y2) + xp * (y2 - y3)); //2,3,p
    double areaCDP = (x3 * (y4 - yp) + x4 * (yp - y3) + xp * (y3 - y4)); //3,4,p
    double areaDAP = (x4 * (y1 - yp) + x1 * (yp - y4) + xp * (y4 - y1)); //4,1,p

    if ((totalArea).toStringAsFixed(6) ==
        (areaABP.abs() + areaBCP.abs() + areaCDP.abs() + areaDAP.abs())
            .toStringAsFixed(6)) {
      onRegion = true;
    }
    return onRegion;
  }
}
