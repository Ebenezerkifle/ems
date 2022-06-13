import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/GeoFence/EmployeesLocationScreen.dart';
import 'package:ems/GeoFence/MapScreen.dart';
import 'package:ems/GeoFence/boundary_check.dart';
import 'package:ems/Models/Location%20.dart';
import 'package:ems/Services/Timeformat.dart';
import 'package:ems/Widget/EmsColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;

  Boundary boundary = Boundary();
  Location location = Location();
  late LatLng latLng;
  bool region = false;
  List locationDocIdList = [];
  int numOfEmployeesOnWorkingArea = 0;
  int numOfEmployeesOutOfWorkingArea = 0;
  List emailListOfWorkingEmployees = [];
  List emailListOfNotWorkingEmployees = [];
  var recentTimeStamp;
  List timeStampOfNotWorkingList = [];
  List timeStampOfworkingList = [];

  @override
  void initState() {
    _fetchLocationDocumentList();
    super.initState();
  }

  Future _fetchLocationDocumentList() async {
    List list = [];
    print('fetching locatioin info');
    try {
      await locationFireStore.get().then((q) {
        print('loop.................');
        for (var element in q.docs) {
          print(element.id);
          list.add(element);
          bool onRegion = element['onRegion'];
          var timeStamp = element['timeStamp'];
          recentTimeStamp = TimeFormate.myDateFormat(timeStamp);
          if (element['userEmail'] != loginUserEmail) {
            if (onRegion) {
              setState(() {
                emailListOfWorkingEmployees.add(element['userEmail']);
                timeStampOfworkingList.add(element['timeStamp']);
                numOfEmployeesOnWorkingArea++;
              });
            } else {
              setState(() {
                emailListOfNotWorkingEmployees.add(element['userEmail']);
                numOfEmployeesOutOfWorkingArea++;
                timeStampOfNotWorkingList.add(element['timeStamp']);
              });
            }
          }
        }
      });
    } on Exception catch (e) {
      print('Exception: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print('================================');
    print(timeStampOfNotWorkingList);
    print(timeStampOfworkingList);
    print(numOfEmployeesOnWorkingArea);
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
          backgroundColor: EmsColor.backgroundColor,
          focusColor: Colors.white,
          onPressed: () => {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MyLocation()))
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
    var cardTextStyle = TextStyle(
      fontFamily: 'Montserat Regular',
      fontWeight: FontWeight.bold,
      fontSize: 60,
      color: EmsColor.acceptedColor,
      // color: Color.fromRGBO(63, 63, 63, 1),
      //height: 64
    );
    var outOfFenceTextStyle = TextStyle(
      fontFamily: 'Montserat Regular',
      fontWeight: FontWeight.bold,
      fontSize: 60,
      color: EmsColor.unDoneColor,
      // color: Color.fromRGBO(63, 63, 63, 1),
      //height: 64
    );
    var timeTextStyle = TextStyle(
      fontFamily: 'Montserat Regular',
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: Colors.lightBlue.shade500,
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
                    if (numOfEmployeesOutOfWorkingArea > 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EmployeesLocationScreen(
                              false,
                              emailListOfNotWorkingEmployees,
                              timeStampOfNotWorkingList)));
                    }
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '$recentTimeStamp',
                                        style: timeTextStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                    if (numOfEmployeesOnWorkingArea > 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EmployeesLocationScreen(
                              true,
                              emailListOfWorkingEmployees,
                              timeStampOfworkingList)));
                    }
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '$recentTimeStamp',
                                  style: timeTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
