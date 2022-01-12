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
          child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("Finance")),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("Todo list progress")),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("Employee progress")),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("Tasks")),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("My Attendance")),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("Location")),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("Chat")),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white60,
                    textStyle: const TextStyle(fontSize: 14.0),
                  ),
                  child: const Text("Employees Info")),
            ],
          )
        ],
      )),
    );
  }
}
