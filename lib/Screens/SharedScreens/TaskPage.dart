import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/createNewTask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class TaskPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  String receiverEmail;
  String name;
  String receiverDepartement;
  String receiverPosistion;
  int progress;

  // ignore: use_key_in_widget_constructors
  TaskPage(
    this.userInfo,
    this.receiverEmail,
    this.name,
    this.receiverDepartement,
    this.receiverPosistion,
    this.progress,
  );

  @override
  // ignore: no_logic_in_create_state
  _TaskPageState createState() => _TaskPageState(
      receiverEmail, name, receiverDepartement, receiverPosistion, progress);
}

class _TaskPageState extends State<TaskPage> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;

  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  String receiverEmail;
  String name;
  String receiverDepartment;
  String receiverPosistion;
  final int _progress;

  _TaskPageState(this.receiverEmail, this.name, this.receiverDepartment,
      this.receiverPosistion, this._progress);

  late String subManagerEmail;
  var taskDocId;

  @override
  void initState() {
    _fetchTaskDocId().then((value) {
      setState(() {
        taskDocId = value;
      });
    });
    super.initState();
  }

  Future _fetchTaskDocId() async {
    late var email;
    var taskDocId;

    if (widget.userInfo.get('position') == 'General-Manager' &&
        receiverPosistion == 'Employee') {
      await FirebaseFirestore.instance
          .collection('Users')
          .where('position', isEqualTo: 'Sub-Manager')
          .where('department', isEqualTo: widget.userInfo.get('department'))
          .get()
          .then((value) {
        email = value.docs.single.data();
        email = email['email'];
      });
      await tasks
          .where("Users", isEqualTo: {receiverEmail: null, email: null})
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
            taskDocId = querySnapshot.docs.single.id;
          });
    } else {
      await tasks
          .where("Users",
              isEqualTo: {loginUserEmail: null, receiverEmail: null})
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              taskDocId = querySnapshot.docs.single.id;
            } else {
              await tasks.add({
                'Users': {loginUserEmail: null, receiverEmail: null}
              }).then((value) => {
                    taskDocId = value.id,
                  });
            }
          });
    }
    return taskDocId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
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
                name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          _progress == 0
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black12,
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => CreateTask(
                                          widget.userInfo,
                                          receiverEmail,
                                          taskDocId,
                                          receiverDepartment,
                                        )),
                              );
                            },
                            color: Colors.white,
                            icon: const Icon(
                              Icons.add_task,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const Text(
                            'Add New Task',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 0),
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
      required int status}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetail(taskDocId, receiverEmail,
                description, title, time, documentId, status, _progress),
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
