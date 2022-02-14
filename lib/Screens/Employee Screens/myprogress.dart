import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProgress extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  const MyProgress(this.userInfo, {Key? key}) : super(key: key);

  @override
  _MyProgressState createState() => _MyProgressState();
}

class _MyProgressState extends State<MyProgress> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;

  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  List statusList = ['Undone', 'On Progress', 'Done'];
  List statusNum = [-1, 0, 1];
  late String _status;
  late int _statusNum;
  List taskList = [];
  var taskDocId;

  @override
  void initState() {
    setState(() {
      _status = statusList[0];
      _statusNum = statusNum[0];
    });
    _fetchTaskDocId().then((value) {
      setState(() {
        taskDocId = value;
      });
    });
    super.initState();
  }

  Future _fetchTaskDocId() async {
    var taskDocId;
    var email;
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
        .where("Users", isEqualTo: {loginUserEmail: null, email: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
          taskDocId = querySnapshot.docs.single.id;
        });
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
            _progressReport()
            // _bodyChat(),
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
              const Text(
                "Todo List Accomplishment",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressReport() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.83,
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      // width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            child: Card(color: Colors.green, elevation: 5),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            child: Card(color: Colors.green, elevation: 5),
          ),
        ],
      ),
    );
  }

  Widget _bodyChat() {
    Stream<QuerySnapshot<Map<String, dynamic>>> query =
        tasks.doc(taskDocId).collection('Tasks').snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> querySM = tasks
        .doc(taskDocId)
        .collection('Tasks')
        .where('department', isEqualTo: widget.userInfo.get('department'))
        .where('status', isEqualTo: _statusNum)
        .snapshots();
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        color: Colors.white,
      ),
      child: StreamBuilder(
        stream: widget.userInfo.get('position') == 'General-Manager'
            ? query
            : querySM,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
      ),
    ));
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
