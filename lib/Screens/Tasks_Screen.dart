import 'package:ems/Services/Database_Services.dart';
import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List taskList = [];

  @override
  void initState() {
    super.initState();
    fetchDatabaseLists();
  }

  fetchDatabaseLists() async {
    dynamic result = await DatabaseServices().getUsersInfo();
    if (result == null) {
      print("unable to fetch the data!");
    } else {
      result = taskList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tasks"),
        ),
        body: ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const Icon(Icons.list),
                trailing: const Text(
                  "GFG",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                onTap: () {},
                title: Text(
                    taskList[index]['firstName'] + taskList[index]['lastName']),
                subtitle: Text(taskList[index]['email']),
              );
            }));
  }
}
