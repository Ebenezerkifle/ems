import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Attendance/Attendance.dart';
import 'package:ems/GeoFence/googleMap.dart';
import 'package:ems/Screens/GeneralManager%20Screens/employeeprogress.dart';
import 'package:ems/Screens/GeneralManager%20Screens/todoListProgress.dart';
import 'package:ems/Screens/SharedScreens/ChatHomepage.dart';
import 'package:ems/Screens/SharedScreens/TaskHomePage.dart';
import 'package:ems/Screens/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenSM extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  const HomeScreenSM({required this.userInfo, Key? key}) : super(key: key);

  @override
  _HomeScreenSMState createState() => _HomeScreenSMState();
}

class _HomeScreenSMState extends State<HomeScreenSM> {
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var setting = InitializationSettings(android: androidInitialize);
    localNotification.initialize(setting);
    _fetchNotification();
    super.initState();
  }

  Future _showNotification(QueryDocumentSnapshot<Object?> element) async {
    var androidDetails = const AndroidNotificationDetails(
        "channelId", "channelName",
        channelDescription: "This is the description of the notification",
        importance: Importance.high);
    var generalNotificationDetail =
        NotificationDetails(android: androidDetails);
    await localNotification.show(0, element.get('title'), element.get('body'),
        generalNotificationDetail);
  }

  _fetchNotification() {
    CollectionReference notification =
        FirebaseFirestore.instance.collection('Notification');
    notification
        .where('receiver', isEqualTo: widget.userInfo.get('email'))
        .get()
        .then(
      (QuerySnapshot snapshot) {
        //_showNotification();
        snapshot.docs.forEach((element) {
          _showNotification(element);
        });
        FlutterRingtonePlayer.playNotification();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // to get size
    var size = MediaQuery.of(context).size;
    //style
    var cardTextStyle = const TextStyle(
      fontFamily: 'Montserat Regular',
      fontSize: 16,
      color: Color.fromRGBO(63, 63, 63, 1),
    );

    return Scaffold(
      key: scaffoldKey,
      endDrawer: NavigationDrawerWidget(widget.userInfo),
      body: Stack(children: <Widget>[
        Container(
            height: size.height * .3,
            decoration: const BoxDecoration(
              color: Colors.indigo,
            )),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_960_720.png'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            '${widget.userInfo.get('firstname') ?? ''}' +
                                ' ' +
                                '${widget.userInfo.get('middlename') ?? ''}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat Medium',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          Text(
                            '${widget.userInfo.get('position') ?? ''}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                                fontFamily: 'Montserrat Regular'),
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40)),
                      IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    primary: false,
                    crossAxisCount: 2,
                    children: <Widget>[
                      // TO DO list progress
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TodoListProgress(widget.userInfo)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/todo.svg',
                                height: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Todo List Progress',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Card 3
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EmployeeProgress(userInfo: widget.userInfo)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/emp-progress.svg',
                                height: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Employee Progress',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Card 4
                      ),
                      // Tasks
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TaskHomePage(widget.userInfo)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/tasks.svg',
                                height: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Tasks',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Card 5
                      ),
                      //my attendance
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CalendarPage()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/calendar.svg',
                                height: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'My Attendance',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Card 6
                      ),
                      //Location
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GoogleMap()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/location.svg',
                                height: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Location',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Card 7 chatroom
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChatHomePage(widget.userInfo)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/chat.svg',
                                height: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Chat',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
