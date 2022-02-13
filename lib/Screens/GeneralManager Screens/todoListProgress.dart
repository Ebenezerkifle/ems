import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/TaskPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoListProgress extends StatefulWidget {
  const TodoListProgress({Key? key}) : super(key: key);

  @override
  _TodoListProgressState createState() => _TodoListProgressState();
}

class _TodoListProgressState extends State<TodoListProgress> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  List status = ['Undone', 'On Progress', 'Done'];
  List statusNum = [-1, 0, 1];
  Future<List<dynamic>> tasksList = [] as Future<List>;
  late String _status;
  late int _statusNum;

  // List<Map<String, dynamic>> taskProgress = [];

  @override
  void initState() {
    setState(() {
      _statusNum = statusNum[0];
      _status = status[0];
    });
    _fetchDocumentId().then((value) {
      tasksList = value as Future<List>;
    });
    super.initState();
  }

  Future<List<dynamic>> _fetchDocumentId() async {
    List tasksList = [];
    print("--------------------------");
    await tasks.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var id = doc.id;
        tasksList = _tasks(id) as List;
      }
    });
    return tasksList;
  }

  Future<List<dynamic>> _tasks(var id) async {
    List tasksList = [];
    tasks
        .doc(id)
        .collection("Tasks")
        .where('status', isEqualTo: _statusNum)
        .orderBy("timeStamp")
        .get()
        .then((QuerySnapshot query) {
      for (var element in query.docs) {
        tasksList.add(element.data());
        print(element.data());
      }
    });
    return tasksList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                _status,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _statusNum = statusNum[0];
                      _status = status[0];
                    });
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.not_started_rounded,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _statusNum = statusNum[1];
                      _status = status[1];
                    });
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.run_circle_outlined,
                    color: Colors.yellow,
                    size: 25,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _statusNum = statusNum[2];
                      _status = status[2];
                    });
                  },
                  icon: const Icon(
                    Icons.done,
                    size: 25,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white,
            ),
            child: ListView.builder(
                shrinkWrap: true,
                //itemCount: tasksList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                  // _tasksItem(
                  //   title: tasksList[index]['title'],
                  //   description: tasksList[index]['description'],
                  //   time: tasksList[index]['timeStamp'],
                  //   status: tasksList[index]['status'],
                  // );
                })));
  }

  Widget _tasksItem(
      {required String title, description, var time, required int status}) {
    return InkWell(
      // onTap: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) => TaskDetail(
      //           taskDocId, receiverEmail, description, title, time, documentId),
      //     ),
      //   );
      // },
      child: Card(
        color: _statusNum == -1
            ? Colors.redAccent
            : _statusNum == 0
                ? Colors.yellowAccent
                : Colors.greenAccent,
        elevation: 5,
        child: Container(
          color: status == -1
              ? Colors.redAccent
              : status == 0
                  ? Colors.yellowAccent
                  : Colors.greenAccent,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          child: Stack(children: [
            Card(
              color: _statusNum == -1
                  ? Colors.redAccent
                  : _statusNum == 0
                      ? Colors.yellowAccent
                      : Colors.greenAccent,
              margin: const EdgeInsets.symmetric(vertical: 20),
              elevation: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                '07:10',
                                //time.toString(),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
