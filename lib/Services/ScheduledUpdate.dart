import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:ems/GeoFence/boundary_check.dart';
import 'package:ems/Models/Location%20.dart';

class ScheduledUpdate {
  static void update(String userEmail) async {
    final CollectionReference locationStore =
        FirebaseFirestore.instance.collection("Locations");
    Location _currentLocation = Location();
    Boundary _boundary = Boundary();
    final cron = Cron();
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
        // await locationStore
        //     .where("Users", isEqualTo: {userEmail: null})
        //     .limit(1)
        //     .get()
        //     .then((QuerySnapshot querySnapshot) async {
        //       if (querySnapshot.docs.isNotEmpty) {
        //         locationDocId = querySnapshot.docs.single.id;
        //       } else {
        //         await locationDocId.add({
        //           'Users': {userEmail: null}
        //         }).then((value) => {
        //               locationDocId = value.id,
        //             });
        //       }
        //     });

        await locationStore
            .doc(userEmail)
            .collection(locationDocId)
            .add(_currentLocation.locationMap);

        // print(locationDocId);

        // await locationStore
        //     .doc(locationDocId)
        //     .collection('Location')
        //     .add(_currentLocation.locationMap);
        print('successfully stored!');
      } on Exception catch (e) {
        print('exception: ' + e.toString());
      }
    });
  }
}
