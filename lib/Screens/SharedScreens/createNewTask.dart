import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateTask extends StatefulWidget {
  String receiverEmail;
  String taskDocId;
  CreateTask(this.receiverEmail, this.taskDocId, {Key? key}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState(
        receiverEmail,
        taskDocId,
      );
}

class _CreateTaskState extends State<CreateTask> {
  String receiverEmail;
  String taskDocId;
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  _CreateTaskState(this.receiverEmail, this.taskDocId);

  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;
  TextEditingController titleController = TextEditingController();
  TextEditingController descirptionController = TextEditingController();
  var task1Id;

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
              const Text(
                'New Task',
                style: TextStyle(
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
        padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        // child: Padding(
        //padding: const EdgeInsets.symmetric(vertical: 1),
        child: ListView(
          padding: const EdgeInsets.only(top: 15),
          physics: const BouncingScrollPhysics(),
          children: [
            // Expanded(
            //padding: const EdgeInsets.symmetric(ver),
            TextField(
              controller: titleController,
              //textAlign: TextAlign.left,
              decoration: const InputDecoration(
                  labelText: "Title",
                  //hintText: "Title",
                  border: OutlineInputBorder()),
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: descirptionController,
              decoration: const InputDecoration(
                  labelText: "Description", border: OutlineInputBorder()),
              maxLines: 14,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            _attachFileButton(),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          if (descirptionController.text.isNotEmpty &&
              titleController.text.isNotEmpty) {
            DateTime timeStamp = DateTime.now();
            tasks.doc(taskDocId).collection('Tasks').add({
              "title": titleController.text.trim(),
              "description": descirptionController.text.trim(),
              "creator": loginUserEmail?.trim(),
              "assignedTo": receiverEmail.trim(),
              "timeStamp": timeStamp,
              //"due_date":
            });
            descirptionController.clear();
            titleController.clear();
            Navigator.of(context).pop();
          }
        },
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.indigo,
        child: const Text(
          'Send',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Widget _attachFileButton() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    width: double.infinity,
    child: RaisedButton(
      elevation: 5,
      onPressed: () async {
        // if (_formKey.currentState!.validate()) {
        //   dynamic result = await _auth.singin(
        //       _emailController.text, _passwordController.text);
        //   if (result == null) {
        //     setState(() => error = "couldn't signin with this credential!");
        //     Fluttertoast.showToast(msg: error);
        //   } else {
        //     setState(() => error = "successfully signed in!");
        //     Fluttertoast.showToast(msg: error);
        //     _navigate();
        //   }
        // }
      },
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.indigo,
      child: const Text(
        'Attach File',
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class TaskDetail extends StatefulWidget {
  String taskDocId;
  String receiverEmail;
  String description;
  String title;
  var timeStamp;
  TaskDetail(this.taskDocId, this.receiverEmail, this.description, this.title,
      this.timeStamp,
      {Key? key})
      : super(key: key);

  @override
  _TaskDetailState createState() =>
      _TaskDetailState(taskDocId, receiverEmail, description, title, timeStamp);
}

class _TaskDetailState extends State<TaskDetail> {
  String taskDocId;
  String receiverEmail;
  String description;
  String title;
  var timeStamp;
  _TaskDetailState(this.taskDocId, this.receiverEmail, this.description,
      this.title, this.timeStamp);
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;

  TextEditingController messageController = TextEditingController();

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
              ],
            ),
            _formTask(),
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
      padding: const EdgeInsets.only(left: 25, right: 25),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        color: Colors.white,
      ),
      child: ListView(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: [
          Card(
            elevation: 5,
            child: Container(
                color: Colors.black12,
                padding: const EdgeInsets.all(3),
                child: Text(description)),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: tasks
                .doc(taskDocId)
                .collection("Messages")
                .where("title", isEqualTo: title)
                //.orderBy('timeStamp')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.only(top: 35),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
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
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    ));
  }

  Widget _taskItems({int? chat, String? message, String? time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
              borderRadius: chat == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
            child: Text('$message'),
          ),
        ),
        chat == 1
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _formTask() {
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
                    controller: messageController,
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
                    _sendMessage();
                  },
                  color: Colors.indigo,
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

  _sendMessage() {
    if (messageController.text.isNotEmpty) {
      tasks.doc(taskDocId).collection('Messages').add({
        "title": title.trim(),
        "msg": messageController.text.trim(),
        "user": loginUserEmail.toString(),
        "receiver": receiverEmail.trim(),
        "timeStamp": DateTime.now(),
      });

      // NotificationModel notificationModel = NotificationModel(
      //     title: 'Message',
      //     body: messageController.text.trim(),
      //     senderEmail: loginUserEmail.toString(),
      //     receiverEmail: receiverEmail,
      //     timeStamp: DateTime.now(),
      //     seen: false);
      // notificationModel.sendNotification();
      messageController.clear();
    }
  }
}
