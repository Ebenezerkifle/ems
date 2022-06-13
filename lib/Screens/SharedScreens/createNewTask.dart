import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/task.dart';
import 'package:ems/Services/FileServices.dart';
import 'package:ems/Widget/EmsColor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

  //File? file;
  UploadTask? uploadTask;
  int upload = -1;
  late TaskInfo task;
  String urlDownload = '';
  File? file;
  int fileAttached = 0;

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
            const SizedBox(
              height: 10,
            ),
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
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: EmsColor.backgroundColor,
          ),
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

              tasks.doc(taskDocId).collection('Tasks').add(task.taskMap);

              descirptionController.clear();
              titleController.clear();
              Navigator.of(context).pop();
            } else {
              //Fluttertoast();
            }
          },
          // padding: const EdgeInsets.all(15),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // color: const Color.fromARGB(255, 24, 30, 68),
          child: const Text(
            'Send',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask upLoadTask) =>
      StreamBuilder<TaskSnapshot>(
        stream: upLoadTask.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            double progress = snap!.bytesTransferred / snap.totalBytes;
            progress = double.parse((progress).toStringAsFixed(2));
            return Text('$progress %',
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

  Future pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    final path = result!.files.single.path;

    // ignore: unnecessary_null_comparison
    if (result == null) return;
    setState(() {
      file = File(path!);
    });
  }

  Widget _attachFileButton() {
    var fileName =
        file != null ? file?.path.split('/').last : "No File selected";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: EmsColor.backgroundColor),
        onPressed: () => {
          if (upload == -1)
            {
              pickFile(),
              setState(() {
                upload = -1;
              }),
            }
        },
        // padding: const EdgeInsets.all(15),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // color: const Color.fromARGB(255, 24, 30, 68),
        child: Container(
          color: EmsColor.backgroundColor,
          height: 50,
          child: Center(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Attach File: ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text('$fileName',
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis)),
                ),
                if (file != null)
                  upload == -1
                      ? IconButton(
                          icon: const Icon(Icons.upload),
                          iconSize: 25,
                          color: Colors.white,
                          onPressed: () async {
                            uploadTask =
                                FileServices.uploadFile(file, fileName);
                            setState(() {
                              upload = 0;
                            });

                            if (uploadTask != null) {
                              final snapshot =
                                  await uploadTask?.whenComplete(() {
                                setState(() {
                                  upload = 1;
                                });
                              });
                              urlDownload =
                                  (await snapshot?.ref.getDownloadURL())!;
                            }
                          },
                        )
                      : upload == 0
                          ? CircularPercentIndicator(
                              radius: 25.0,
                              lineWidth: 3.0,
                              percent: 1.0,
                              center: buildUploadStatus(uploadTask!),
                              progressColor: EmsColor.requestForReviewColor,
                            )
                          : IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.close),
                              iconSize: 25,
                              color: Colors.white,
                            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
