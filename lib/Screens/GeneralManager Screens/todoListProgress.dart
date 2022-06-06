import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TodoListProgress extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  const TodoListProgress(this.userInfo, {Key? key}) : super(key: key);

  @override
  _TodoListProgressState createState() => _TodoListProgressState();
}

class _TodoListProgressState extends State<TodoListProgress> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;

  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  List statusList = ['Undone', 'On Progress', 'Done'];
  List statusNum = [-1, 0, 1];
  late String _status;
  late int _statusNum;
  List taskList = [];
  List documentIdList = [];

  @override
  void initState() {
    setState(() {
      _status = statusList[0];
      _statusNum = statusNum[0];
    });
    _fetchTasksLists().then((value) {
      setState(() {
        documentIdList = value;
      });
    });
    super.initState();
  }

  Future _fetchTasksLists() async {
    List taskList = [];
    await tasks.get().then((q) {
      q.docs.forEach((element) {
        taskList.add(element.id);
      });
    });
    return taskList;
  }

  // Future _tasksFromDocument(var docId) async {
  //   List tasksList = [];
  //   await tasks
  //       .doc(docId)
  //       .collection('Tasks')
  //       .where('status', isEqualTo: _statusNum)
  //       .get()
  //       .then((QuerySnapshot) {
  //     QuerySnapshot.docs.forEach((element) {
  //       taskList.add(element.data());
  //     });
  //   });
  //   return tasksList;
  // }

  // Future _tasksForSubManager(var docId) async {
  //   List tasksList = [];
  //   await tasks
  //       .doc(docId)
  //       .collection('Tasks')
  //       .where('position', isEqualTo: 'Employee')
  //       .where('department', isEqualTo: widget.userInfo.get('department'))
  //       .where('status', isEqualTo: _statusNum)
  //       .get()
  //       .then((QuerySnapshot) {
  //     QuerySnapshot.docs.forEach((element) {
  //       taskList.add(element.data());
  //     });
  //   });
  //   return tasksList;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 30, 68),
      body: SafeArea(
        child: Column(
          children: [
            _topChat(),
            _bodyChat(),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  Widget _topChat() {
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
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black38,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _statusNum = statusNum[0];
                      _status = statusList[0];
                    });
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.not_interested_outlined,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black38,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _statusNum = statusNum[1];
                      _status = statusList[1];
                    });
                  },
                  icon: const Icon(
                    Icons.run_circle_outlined,
                    size: 25,
                    color: Colors.yellow,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black38,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _statusNum = statusNum[2];
                      _status = statusList[2];
                    });
                  },
                  icon: const Icon(
                    Icons.done_all_outlined,
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

  Widget _bodyChat() {
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
              reverse: true,
              itemCount: documentIdList.length,
              itemBuilder: (BuildContext contex, int index) {
                Stream<QuerySnapshot<Map<String, dynamic>>> query = tasks
                    .doc(documentIdList[index])
                    .collection('Tasks')
                    .where('status', isEqualTo: _statusNum)
                    .snapshots();
                Stream<QuerySnapshot<Map<String, dynamic>>> querySM = tasks
                    .doc(documentIdList[index])
                    .collection('Tasks')
                    .where('department',
                        isEqualTo: widget.userInfo.get('department'))
                    .where('status', isEqualTo: _statusNum)
                    .snapshots();
                return StreamBuilder(
                  stream: widget.userInfo.get('position') == 'General-Manager'
                      ? query
                      : querySM,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: 0,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // return const CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 35),
                        physics: const BouncingScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          if (data.isNotEmpty) {
                            return _tasksItem(
                              title: data['title'],
                              description: data['description'],
                              time: data['timeStamp'],
                              documentId: document.id,
                              status: data['status'],
                            );
                          } else {
                            return const SizedBox();
                          }
                        }).toList(),
                      );
                    } else {
                      return const SizedBox(
                        height: 0,
                      );
                    }
                  },
                );
              })),
    );
  }

  Widget _tasksItem(
      {required String title,
      required description,
      var time,
      var documentId,
      required int status}) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TaskDetail(
        //         taskDocId, receiverEmail, description, title, time, documentId),
        //   ),
        // );
      },
      child: Card(
        color: status == -1
            ? Colors.redAccent
            : status == 0
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
          child: Container(
            height: 40,
            width: double.infinity,
            color: status == -1
                ? Colors.redAccent
                : status == 0
                    ? Colors.yellowAccent
                    : Colors.greenAccent,
            margin: const EdgeInsets.symmetric(vertical: 20),
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
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
