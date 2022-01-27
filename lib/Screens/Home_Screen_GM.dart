import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/ChatHomepage.dart';
import 'package:ems/Screens/EmployeeInfo_Screen.dart';
import 'package:ems/Screens/MapScreen.dart';
import 'package:ems/Screens/TaskHomePage.dart';
import 'package:ems/Screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenGM extends StatefulWidget {
  const HomeScreenGM({Key? key}) : super(key: key);

  @override
  _HomeScreenGMState createState() => _HomeScreenGMState();
}

class _HomeScreenGMState extends State<HomeScreenGM> {
  var currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference logedUser =
      FirebaseFirestore.instance.collection('Users');
  var currentUserName;

  @override
  void initState() {
    _fetchLogedUser().then((value) => currentUserName = value);
    super.initState();
  }

  Future _fetchLogedUser() async {
    var name;
    await logedUser
        .where('email', isEqualTo: currentUserEmail)
        .get()
        .then((QuerySnapshot snapshot) {
      var result = snapshot.docs.first;
      name = result.get('firstName') + " " + result.get('middleName');
    });
    return name;
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
            )
            // image: DecorationImage(
            //     alignment: Alignment.topCenter,
            //     image: AssetImage('assets/images/mobile_1.png'),
            //     fit: BoxFit.fill)),
            ),
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
                            '${currentUserName ?? ''}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat Medium',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          const Text(
                            '14806798',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Montserrat Regular'),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            //preferences.remove('email');
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          icon: const Icon(Icons.logout)),
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
                      //Card 1
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EmployeeInfo()));
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EmployeeInfo()));
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
                              builder: (context) => const EmployeeInfo()));
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EmployeeInfo()));
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MyLocation()));
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
                              builder: (context) => const EmployeeInfo()));
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
