import 'package:google_maps_flutter/google_maps_flutter.dart';

class Boundary {
  final LatLng point1 = const LatLng(9.0401223, 38.7616437);
  final LatLng point2 = const LatLng(9.0401441, 38.7616654);
  final LatLng point3 = const LatLng(9.0401406, 38.7616575);
  final LatLng point4 = const LatLng(9.0401446, 38.7616668);
  late var sortedYIntercepts;

  // Boundary({
  //   required this.point1,
  //   required this.point2,
  //   required this.point3,
  //   required this.point4,
  // });

  Boundary();

  bool CheckTheCurrent_Location(LatLng currentLocation) {
    bool onRegion = false;

    double x1, x2, x3, x4, y1, y2, y3, y4;

    x1 = point1.latitude.toDouble();
    y1 = point1.longitude.toDouble();
    x2 = point2.latitude.toDouble();
    y2 = point2.longitude.toDouble();
    x3 = point3.latitude.toDouble();
    y3 = point3.longitude.toDouble();
    x4 = point4.latitude.toDouble();
    y4 = point4.longitude.toDouble();

    print('---------------------------------------');
    print(x1);
    print(x2);
    print(x3);
    print(x4);

    double m1 = (y2 - y1) / (x2 - x1);
    double b1 = y1 - m1 * x1;

    double m2 = (y3 - y2) / (x3 - x2);
    double b2 = y2 - m2 * x2;

    double m3 = (y4 - y3) / (x4 - x3);
    double b3 = y3 - m3 * x3;

    double m4 = (y1 - y4) / (x1 - x4);
    double b4 = y4 - m4 * x4;

    var interceptArray = [b1, b2, b3, b4];
    var slopeArray = [m1, m2, m3, m4];

    sortYIntercept(interceptArray);

    for (int i = 0; i < 4; i++) {
      bool region =
          checkBoundary(currentLocation, slopeArray[i], interceptArray[i]);
      if (!region) {
        onRegion = false;
        break;
      }
      onRegion = true;
    }
    return onRegion;
  }

  void sortYIntercept(var array) {
    int n = array.length;
    for (int i = 1; i < n; i++) {
      double key = array[i - 1];
      for (int j = i; j < n; j++) {
        if (key < array[j]) {
          double temp = array[j];
          array[i - 1] = temp;
          array[j] = key;
          key = temp;
        }
        if (j == n - 1) {
          array[i - 1] = key;
        }
      }
    }
    sortedYIntercepts = array;
  }

  bool checkBoundary(LatLng point, double slope, double yIntercept) {
    double latitude = point.latitude.toDouble();
    double longitude = point.longitude.toDouble();
    int index = 0;
    bool region;

    for (int i = 0; i < 4; i++) {
      if (yIntercept == sortedYIntercepts[i]) {
        index = i;
        break;
      }
    }
    if (index == 0 || index == 2) {
      region = (longitude <= slope * latitude + yIntercept);
    } else {
      region = (longitude >= slope * latitude + yIntercept);
    }
    print("----------------------------");
    print(region);
    print("----------------------------");
    return region;
  }

  LatLng getPoint1() {
    return point1;
  }
}
