import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

late final QueryDocumentSnapshot<Object?> userinfo;

class CreateTask extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  String receiverEmail;
  String taskDocId;
  String department;

  CreateTask(this.userInfo, this.receiverEmail, this.taskDocId, this.department,
      {Key? key})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _CreateTaskState createState() =>
      _CreateTaskState(receiverEmail, taskDocId, department);
}

class _CreateTaskState extends State<CreateTask> {
  String receiverEmail;
  String taskDocId;
  String department;
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  _CreateTaskState(this.receiverEmail, this.taskDocId, this.department);

  TextEditingController titleController = TextEditingController();
  TextEditingController descirptionController = TextEditingController();
  var task1Id;

  File? file;
  UploadTask? uploadTask;
  int upload = -1;
  late TaskInfo task;
  String urlDownload = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 30, 68),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
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
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
            task = TaskInfo(
              title: titleController.text.trim(),
              description: descirptionController.text.trim(),
              timeStamp: timeStamp,
              creator: widget.userInfo.get('email').toString(),
              assignedTo: receiverEmail.trim(),
              status: -1,
              department: department,
            );
            task.fileUrl = urlDownload;
            print('-----------------------------------------------*****');
            print(task.fileUrl);
            tasks.doc(taskDocId).collection('Tasks').add(task.taskMap);

            descirptionController.clear();
            titleController.clear();
            Navigator.of(context).pop();
          }
        },
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color.fromARGB(255, 24, 30, 68),
        child: const Text(
          'Send',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  UploadTask? uploadFile() {
    print('--------------------------------------');
    print(upload);
    if (file != null) {
      setState(() {
        upload = 0;
      });
      print(upload);
      final filename = file?.path.split('/').last;
      final destination = 'files/$filename';
      try {
        final reference = FirebaseStorage.instance.ref().child(destination);
        return reference.putFile(file!);
      } on FirebaseException catch (e) {
        return null;
      }
    }
  }

  Widget buildUploadStatus(UploadTask upLoadTask) =>
      StreamBuilder<TaskSnapshot>(
        stream: upLoadTask.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;
            return Text('$progress',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ));
          } else {
            return Container();
          }
        },
      );

  Widget _attachFileButton() {
    final fileName =
        file != null ? file?.path.split('/').last : "No File selected";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: attachFile,
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color.fromARGB(255, 24, 30, 68),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Attach File:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text('$fileName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
              if (file != null)
                upload == -1
                    ? IconButton(
                        onPressed: () async {
                          uploadTask = uploadFile();

                          if (uploadTask != null) {
                            final snapshot = await uploadTask?.whenComplete(() {
                              setState(() {
                                upload = 1;
                              });
                            });
                            urlDownload =
                                (await snapshot?.ref.getDownloadURL())!;
                            print("------------------------------------------");
                            print('file Url: $urlDownload');
                            print("-----------------------------------------");
                          }
                        },
                        icon: const Icon(Icons.upload),
                        iconSize: 15,
                        color: Colors.white,
                      )
                    : upload == 0
                        ? CircularPercentIndicator(
                            radius: 15.0,
                            lineWidth: 2.0,
                            percent: 1.0,
                            center: buildUploadStatus(uploadTask!),
                            progressColor: Colors.green,
                          )
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.close),
                            iconSize: 15,
                            color: Colors.white,
                          )
            ],
          ),
        ),
      ),
    );
  }

  Future attachFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }
}

class TaskDetail extends StatefulWidget {
  String taskDocId;
  String receiverEmail;
  String description;
  String title;
  int progress;
  var fileUrl;
  var documentId;
  var timeStamp;
  int status;
  TaskDetail(this.taskDocId, this.receiverEmail, this.description, this.title,
      this.timeStamp, this.documentId, this.status, this.progress, this.fileUrl,
      {Key? key})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _TaskDetailState createState() => _TaskDetailState(taskDocId, receiverEmail,
      description, title, timeStamp, documentId, status, progress, fileUrl);
}

class _TaskDetailState extends State<TaskDetail> {
  String taskDocId;
  String receiverEmail;
  String description;
  String title;
  var timeStamp;
  var documentId;
  int _status;
  int _progress;
  var fileUrl;

  _TaskDetailState(
      this.taskDocId,
      this.receiverEmail,
      this.description,
      this.title,
      this.timeStamp,
      this.documentId,
      this._status,
      this._progress,
      this.fileUrl);
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");
  var loginUserEmail = FirebaseAuth.instance.currentUser?.email;

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 30, 68),
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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
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
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(
            width: 100,
          ),
          _progress == 0
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black12,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.done,
                          size: 25,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _status = 1;
                            _taskStatusChange(1);
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
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
                            _status = 0;
                            _taskStatusChange(0);
                          });
                        },
                        icon: const Icon(
                          Icons.run_circle_outlined,
                          size: 25,
                          color: Colors.yellowAccent,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  _taskStatusChange(int status) async {
    tasks.doc(taskDocId).collection('Tasks').doc(documentId).update({
      'status': _status,
    });
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
                color: _status == -1
                    ? Colors.redAccent
                    : _status == 0
                        ? Colors.yellowAccent
                        : Colors.greenAccent,
                padding: const EdgeInsets.all(3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(description),
                    const SizedBox(height: 5),
                    Image.network(fileUrl)
                  ],
                )),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: tasks
                .doc(taskDocId)
                .collection("Messages")
                .where("title", isEqualTo: title)
                .orderBy('timeStamp')
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
                  color: const Color.fromARGB(255, 24, 30, 68),
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
