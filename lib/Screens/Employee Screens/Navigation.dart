import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/Employee%20Screens/Home_Screen_EM.dart';
import 'package:ems/Screens/SharedScreens/ChatHomepage.dart';
import 'package:ems/Screens/SharedScreens/TaskHomePage.dart';
import 'package:flutter/material.dart';

class NavigationEM extends StatefulWidget {
  QueryDocumentSnapshot<Object?> userInfo;
  NavigationEM({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  _NavigationEMState createState() => _NavigationEMState();
}

class _NavigationEMState extends State<NavigationEM> {
  //static get userInfo => userInfo;

  int currentIndex = 0;

  List<Widget>? navigation;
  @override
  void initState() {
    navigation = [
      HomeScreenEM(userInfo: widget.userInfo),
      ChatHomePage(widget.userInfo),
      TaskHomePage(widget.userInfo)
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigation?[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        // currentIndex: Navigation[currentIndex],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: "Tasks",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Chat",
              backgroundColor: Colors.black),
        ],
      ),
    );
  }
}
