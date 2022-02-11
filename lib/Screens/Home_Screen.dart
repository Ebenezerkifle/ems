import 'package:ems/Screens/SharedScreens/Chat_Screen.dart';
import 'package:ems/Screens/GeneralManager%20Screens/EmployeeInfo_Screen.dart';
import 'package:ems/Screens/Signin%20and%20Signout%20Screens/Login_Screen.dart';
import 'package:ems/Screens/Tasks_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  SharedPreferences preferences;
  Home(this.preferences, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _HomeState createState() => _HomeState(preferences);
}

class _HomeState extends State<Home> {
  SharedPreferences preferences;
  _HomeState(this.preferences);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home'), actions: [
          // ignore: void_checks
          IconButton(
              onPressed: () async {
                preferences.remove('email');
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()));
              },
              icon: const Icon(Icons.logout)),
        ]),
        body: SafeArea(
          child: Center(
              child: Column(
            children: [
              const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
              Row(
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("Finance")),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("Todo list progress")),
                ],
              ),
              Row(
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("Employee progress")),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Tasks()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("Tasks")),
                ],
              ),
              Row(
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("My Attendance")),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("Location")),
                ],
              ),
              Row(
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Chat()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("Chat")),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const EmployeeInfo()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        textStyle: const TextStyle(fontSize: 14.0),
                      ),
                      child: const Text("Employees Info")),
                ],
              )
            ],
          )),
        ));
  }
}
