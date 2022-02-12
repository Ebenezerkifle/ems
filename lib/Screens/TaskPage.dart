import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class TaskPage extends StatefulWidget {
  String receiverEmail;
  String name;

  // ignore: use_key_in_widget_constructors
  TaskPage(this.receiverEmail, this.name);

  @override
  _TaskPageState createState() => _TaskPageState(receiverEmail, name);
}

class _TaskPageState extends State<TaskPage> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;

  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  String receiverEmail;
  String name;

  _TaskPageState(this.receiverEmail, this.name);

  var taskDocId;

  @override
  void initState() {
    _fetchChatDocId().then((value) {
      setState(() {
        taskDocId = value;
      });
    });
    super.initState();
  }

  Future _fetchChatDocId() async {
    var taskDocId;
    await tasks
        .where("Users", isEqualTo: {loginUserEmail: null, receiverEmail: null})
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: IconButton(
                  onPressed: () {
                    _createnewTask(context);
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.add_task,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.message,
                  size: 25,
                  color: Colors.white,
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
                    description: data['description']!,
                    time: data['timeStamp'],
                  );
                }).toList(),
              );
            },
          )),
    );
  }

  Widget _tasksItem({required String title, description, time}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TaskDetail(receiverEmail, title, taskDocId, time),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          child: Stack(children: [
            Card(
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

  void _createnewTask(context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descirptionController = TextEditingController();
    String title;
    String description;
    showDialog(
        context: context,
        builder: (BuildContext builder) {
          return Material(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: Text("New Task",
                          style: TextStyle(
                              fontSize: 40.0, color: Colors.blueAccent))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  TextFormField(
                    controller: titleController,
                    onChanged: (value) => {setState(() => title = value)},
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  TextFormField(
                    // validator: (value) => value!.length < 6
                    //     ? "Enter 6+ chars for password"
                    //     : null,
                    controller: descirptionController,
                    onChanged: (value) => {setState(() => description = value)},
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Description...",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: InkWell(
                      onTap: () {
                        if (titleController.text.isNotEmpty &&
                            descirptionController.text.isNotEmpty) {
                          tasks.doc(taskDocId).collection('Tasks').add({
                            "title": titleController.text.trim(),
                            "description": descirptionController.text.trim(),
                            "creator": loginUserEmail?.trim(),
                            "assignedTo": receiverEmail.trim(),
                            "timeStamp": DateTime.now()
                            //"due_date":
                          });
                          descirptionController.clear();
                          titleController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.indigoAccent,
                        child: Text('Send'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}

class TaskDetail extends StatefulWidget {
  String receiverEmail;
  String title;
  String taskDocId;
  String timeStamp;
  TaskDetail(this.receiverEmail, this.title, this.taskDocId, this.timeStamp,
      {Key? key})
      : super(key: key);

  @override
  _TaskDetailState createState() =>
      _TaskDetailState(receiverEmail, title, taskDocId, timeStamp);
}

class _TaskDetailState extends State<TaskDetail> {
  String receiverEmail;
  String title;
  String taskDocId;
  String timeStamp;
  _TaskDetailState(
      this.receiverEmail, this.title, this.taskDocId, this.timeStamp);

  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topTask(),
                _bodyTask(),
                const SizedBox(
                  height: 120,
                )
              ],
            ),
            // _formTask(),
          ],
        ),
      ),
    );
  }

  Widget _topTask() {
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
                title,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.call,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.videocam,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _bodyTask() {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(),
              StreamBuilder<QuerySnapshot>(
                stream: tasks
                    .doc(taskDocId)
                    .collection("Tasks")
                    .doc(taskDocId)
                    .collection(timeStamp)
                    .orderBy('timeStamp')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    Fluttertoast.showToast(msg: "Error occured");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.only(top: 35),
                    physics: const BouncingScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      int sender =
                          0; //by default we assume sender is current user.
                      if (data['user'].toString() == receiverEmail) {
                        sender = 1;
                      }
                      return _taskItems(
                        chat: sender,
                        message: data['msg']!,
                        time: '08.00',
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          )),
    );
  }

  Widget _taskItems({int? chat, String? message, String? time}) {
    return Container();
  }

  Widget _formChat() {
    //var messageController;
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            color: Colors.white,
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    //controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      labelStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.all(20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // _sendMessage();
                  },
                  color: Colors.blueAccent,
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
