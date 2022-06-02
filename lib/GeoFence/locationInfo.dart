import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/GeoFence/googleMap.dart';
import 'package:ems/Screens/SharedScreens/MapScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmployeeLocationInfo extends StatefulWidget {
  const EmployeeLocationInfo({Key? key}) : super(key: key);

  @override
  State<EmployeeLocationInfo> createState() => _EmployeeLocationInfoState();
}

class _EmployeeLocationInfoState extends State<EmployeeLocationInfo> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        //endDrawer: NavigationDrawerWidget(),
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Column(
            children: [
              _top(),
              _body(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GoogleMap()))
          },
          child: const Icon(Icons.my_location),
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
            child: Expanded(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '3',
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
                      ),
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
                            '6',
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
                ]))));
  }
}
