import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:ems/GeoFence/boundary_check.dart';
import 'package:ems/Models/Location%20.dart';

class ScheduledUpdate {
  static void update(String userEmail) async {
    CollectionReference locationStore =
        FirebaseFirestore.instance.collection("Locations");
    Location _currentLocation = Location();
    Boundary _boundary = Boundary();
    var cron = Cron();
    // ignore: prefer_typing_uninitialized_variables
    var locationDocId;

    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      print('*************************************************');
      print('every 1 minutes  ' + DateTime.now().toString());

      _currentLocation.fetchCurrentLocation();
      _currentLocation.onRegion =
          _boundary.checkBoundary(_currentLocation.currentLocation);

      _currentLocation.timeStamp = DateTime.now();
      _currentLocation.userEmail = userEmail;
      print('*************************************************');
      print(userEmail);
      print(_currentLocation.onRegion);
      print(_currentLocation.latitude);
      print(_currentLocation.currentLocation);
      print('*************************************************');
      try {
        await locationStore
            .doc(userEmail)
            .set(_currentLocation.locationMap, SetOptions(merge: true));
        print('successfully stored!');
      } on Exception catch (e) {
        print('exception: ' + e.toString());
      }
    });
  }
}
