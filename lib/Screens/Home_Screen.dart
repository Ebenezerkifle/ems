import 'package:ems/Screens/Chat_Screen.dart';
import 'package:ems/Screens/EmployeeInfo_Screen.dart';
import 'package:ems/Screens/Tasks_Screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
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
