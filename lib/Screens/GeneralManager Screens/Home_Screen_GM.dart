import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/GeoFence/googleMap.dart';
import 'package:ems/Screens/SharedScreens/ChatHomepage.dart';
import 'package:ems/Screens/GeneralManager%20Screens/EmployeeInfo_Screen.dart';
import 'package:ems/Screens/SharedScreens/TaskHomePage.dart';
import 'package:ems/Screens/Signin%20and%20Signout%20Screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class HomeScreenGM extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;

  HomeScreenGM({required this.userInfo, Key? key}) : super(key: key);

  @override
  _HomeScreenGMState createState() => _HomeScreenGMState();
}

class _HomeScreenGMState extends State<HomeScreenGM> {
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

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
                        onPressed: () async {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(Icons.logout),
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
                      //fiance
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EmployeeInfo()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /*  SvgPicture.network(
                              'https://www.svgrepo.com/show/125846/graduate.svg',
                              height: 128,
                            ), */
                              SvgPicture.asset(
                                'assets/images/finance.svg',
                                height: 80,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Finance',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Card 2
                      ),
                      // TO DO list progress
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EmployeeInfo()));
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
                          // _showNotification();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const EmployeeInfo()));
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
                              builder: (context) => TaskHomePage()));
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
                              builder: (context) => EmployeeInfo()));
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
                              builder: (context) => ChatHomePage()));
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
                      // Card 8  Employee info
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EmployeeInfo()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/info.svg',
                                height: 64,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Employee Info',
                                  style: cardTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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