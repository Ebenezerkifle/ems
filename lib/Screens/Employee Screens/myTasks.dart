import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/TaskDetail.dart';
import 'package:ems/Screens/SharedScreens/createNewTask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyTasks extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  const MyTasks({required this.userInfo, Key? key}) : super(key: key);

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var receiverEmail;
  var taskDocId;

  late String _titleTop = 'Tasks \nAssigned to you';

  @override
  void initState() {
    setState(() {
      _fetchReceiverEmail().then((value) {
        receiverEmail = value;
      });
    });
    super.initState();
  }

  Future _fetchReceiverEmail() async {
    var email;
    await FirebaseFirestore.instance
        .collection("Users")
        .where('position', isEqualTo: 'Sub-Manager')
        .where('department', isEqualTo: widget.userInfo.get('department'))
        .limit(1)
        .get()
        .then((QuerySnapshot query) {
      email = query.docs.single.data();
      _fetchtaskDocId().then((value) {
        taskDocId = value;
      });
    });
    return email['email'];
  }

  Future _fetchtaskDocId() async {
    var taskDoId;
    await tasks
        .where("Users", isEqualTo: {loginUserEmail: null, receiverEmail: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            taskDoId = querySnapshot.docs.single.id;
          } else {
            await tasks.add({
              'Users': {loginUserEmail: null, receiverEmail: null}
            }).then((value) => {
                  taskDoId = value.id,
                });
          }
        });
    return taskDoId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_titleTop',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    var fileUrl;
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            color: Colors.white,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: tasks
                .doc(taskDocId)
                .collection("Tasks")
                .orderBy("timeStamp")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                Fluttertoast.showToast(msg: "Error occured");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Task yet"),
                );
              }
              return ListView(
                padding: const EdgeInsets.only(top: 35),
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return _tasksItem(
                    title: data['title'],
                    description: data['description'],
                    time: data['timeStamp'],
                    documentId: document.id,
                    status: data['status'],
                    file: data['file'],
                    fileName: data['fileName'],
                    fileUrl: data['fileUrl'],
                  );
                }).toList(),
              );
            },
          )),
    );
  }

  Widget _tasksItem(
      {required String title,
      description,
      var time,
      var documentId,
      required int status,
      required int file,
      required String fileName,
      required String fileUrl}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetail(
                taskDocId,
                receiverEmail,
                description,
                title,
                time,
                documentId,
                status,
                1,
                fileUrl,
                file,
                fileName,
                widget.userInfo),
          ),
        );
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
          child: Stack(children: [
            Card(
              color: status == -1
                  ? Colors.redAccent
                  : status == 0
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
                  //   ],
                  // ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
