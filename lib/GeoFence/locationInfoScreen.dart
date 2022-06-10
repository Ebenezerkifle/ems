import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/GeoFence/boundary_check.dart';
import 'package:ems/GeoFence/googleMap.dart';
import 'package:ems/Models/Location%20.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmployeeLocationInfo extends StatefulWidget {
  const EmployeeLocationInfo({Key? key}) : super(key: key);

  @override
  State<EmployeeLocationInfo> createState() => _EmployeeLocationInfoState();
}

class _EmployeeLocationInfoState extends State<EmployeeLocationInfo> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference locationFireStore =
      FirebaseFirestore.instance.collection("Locations");

  Boundary boundary = Boundary();
  Location location = Location();
  late LatLng latLng;
  bool region = false;
  List locationDocList = [];
  List locationDocIdList = [];
  int numOfEmployeesOnWorkingArea = 0;
  int numOfEmployeesOutOfWorkingArea = 0;

  @override
  void initState() {
    _fetchLocationDocumentList().then((value) {
      setState(() {
        locationDocIdList = value;
      });
    });
    super.initState();
  }

  Future _fetchLocationDocumentList() async {
    List list = [];
    print('*********************');

    try {
      print('fetching');
      await FirebaseFirestore.instance.collection('Locations').get().then((q) {
        for (var element in q.docs) {
          print(element.id);
          list.add(element.id);
        }
        print(list.length);
        print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
      });
    } on Exception catch (e) {
      print('Exception: ' + e.toString());
    }
    return list;
  }

  Future _trackLocationInformation() async {
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(locationDocList.length);
    print('fetching the locations');
    for (int i = 0; i < locationDocList.length; i++) {
      await locationFireStore
          .doc(locationDocIdList[i])
          .collection('Location')
          .orderBy('timeStamp')
          .get()
          .then((event) {
        if (event.docs.isNotEmpty) {
          Map<String, dynamic> documentData =
              event.docs.first.data as Map<String, dynamic>;
          bool onRegion = documentData['onRegion'];
          print('==================================');
          print(onRegion);
          print('==================================');

          if (onRegion) {
            numOfEmployeesOnWorkingArea++;
          } else {
            numOfEmployeesOutOfWorkingArea++;
          }
        }
      }).catchError((e) => print("error fetching data: $e"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        //endDrawer: NavigationDrawerWidget(),
        backgroundColor: const Color.fromARGB(255, 24, 30, 68),
        body: SafeArea(
          child: Column(
            children: [
              _top(),
              _body(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 24, 30, 68),
          focusColor: Colors.white,
          onPressed: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const GoogleMapInforamtion()))
          },
          child: const Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ));
  }

  Widget _top() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Employee Location",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _body() {
    //_trackLocationInformation();
    var cardTextStyle = const TextStyle(
      fontFamily: 'Montserat Regular',
      fontWeight: FontWeight.bold,
      fontSize: 60,
      color: Colors.green,
      // color: Color.fromRGBO(63, 63, 63, 1),
      //height: 64
    );
    var outOfFenceTextStyle = const TextStyle(
      fontFamily: 'Montserat Regular',
      fontWeight: FontWeight.bold,
      fontSize: 60,
      color: Colors.red,
      // color: Color.fromRGBO(63, 63, 63, 1),
      //height: 64
    );
    var timeTextStyle = const TextStyle(
      fontFamily: 'Montserat Regular',
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: Colors.blueAccent,
      // color: Color.fromRGBO(63, 63, 63, 1),
      //height: 64
    );

    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            color: Colors.white,
          ),
          child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              primary: false,
              crossAxisCount: 2,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         TodoListProgress(widget.userInfo)));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 6,
                    child: StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '$numOfEmployeesOutOfWorkingArea',
                                style: outOfFenceTextStyle,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Employees are out of working area!',
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "last updated, 12:00",
                                      style: timeTextStyle,
                                    ),
                                    const Padding(padding: EdgeInsets.all(2.0)),
                                  ])
                            ],
                          );
                        }),
                  ),
                  // Card 3
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         TodoListProgress(widget.userInfo)));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '$numOfEmployeesOnWorkingArea',
                          style: cardTextStyle,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Employees are on their working area!',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "last updated, 12:00",
                                style: timeTextStyle,
                              ),
                              const Padding(padding: EdgeInsets.all(2.0)),
                            ])
                      ],
                    ),
                  ),
                  // Card 3
                ),
              ])),
    );
  }
}
