// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/task.dart';
import 'package:ems/Screens/SharedScreens/TaskHomePage.dart';
import 'package:ems/Services/FileServices.dart';
import 'package:ems/Services/Timeformat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:super_banners/super_banners.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

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

            tasks.doc(taskDocId).collection('Tasks').add(task.taskMap);

            descirptionController.clear();
            titleController.clear();
            Navigator.of(context).pop();
          } else {
            //Fluttertoast();
          }
        },
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color.fromARGB(255, 24, 30, 68),
        child: const Text(
          'Send',
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
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
            var progress = snap!.bytesTransferred / snap.totalBytes;
            progress = progress * 100;
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
      child: RaisedButton(
        elevation: 5,
        onPressed: () => {
          pickFile(),
          setState(() {
            upload = -1;
          }),
        },
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
                        icon: const Icon(Icons.upload),
                        iconSize: 15,
                        color: Colors.white,
                        onPressed: () async {
                          uploadTask = FileServices.uploadFile(file, fileName);
                          setState(() {
                            upload = 0;
                          });
                          print('---------------------------');
                          print(uploadTask == null);
                          if (uploadTask != null) {
                            final snapshot = await uploadTask?.whenComplete(() {
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
                            radius: 15.0,
                            lineWidth: 2.0,
                            percent: 1.0,
                            center: buildUploadStatus(uploadTask!),
                            progressColor:
                                const Color.fromARGB(255, 43, 190, 48),
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
  QueryDocumentSnapshot<Object?> userInfo;
  TaskDetail(
      this.taskDocId,
      this.receiverEmail,
      this.description,
      this.title,
      this.timeStamp,
      this.documentId,
      this.status,
      this.progress,
      this.fileUrl,
      this.userInfo,
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

  bool isListening = false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      isListening = true;
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      messageController.text = result.recognizedWords;
    });
  }

  List statusList = [
    'Undone',
    'On Progress',
    'Approved',
    'Revise',
    'Request For Review'
  ];
  String urlDownload = '';
  int _file = 0;
  FileServices fileServices = FileServices();

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 30, 68),
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: _progress == 0
          ? Align(
              alignment: const Alignment(0.8, 0.7),
              child: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  backgroundColor: const Color.fromARGB(255, 24, 30, 68),
                  children: [
                    SpeedDialChild(
                      child: const Icon(
                        Icons.rate_review_sharp,
                        size: 25,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onTap: () {
                        setState(() {
                          _status = 2;
                          _taskStatusChange(2);
                        });
                      },
                      label: "Revise",
                      backgroundColor: const Color.fromARGB(255, 187, 184, 4),
                    ),
                    SpeedDialChild(
                      label: "Approved",
                      // labelStyle: ,
                      child: const Icon(
                        Icons.done,
                        size: 25,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onTap: () {
                        setState(() {
                          _status = 1;
                          _taskStatusChange(1);
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 10, 116, 33),
                    ),
                  ]),
            )
          : Align(
              alignment: const Alignment(0.8, 0.7),
              child: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  backgroundColor: const Color.fromARGB(255, 24, 30, 68),
                  children: [
                    SpeedDialChild(
                      child: const Icon(
                        Icons.reviews,
                        size: 25,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onTap: () {
                        setState(() {
                          _status = 3;
                          _taskStatusChange(3);
                        });
                      },
                      label: "Request For Review",
                      backgroundColor: const Color.fromARGB(255, 17, 79, 173),
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.run_circle,
                          size: 25, color: Color.fromARGB(255, 157, 167, 18)),
                      onTap: () {
                        setState(() {
                          _status = 0;
                          _taskStatusChange(0);
                        });
                      },
                      label: "On Progress",
                      backgroundColor: const Color.fromARGB(255, 17, 79, 173),
                    ),
                  ]),
            ),
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
          const SizedBox(
            width: 5,
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
            maxLines: 1,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(
            width: 50,
          ),
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
    var query = tasks
        .doc(taskDocId)
        .collection("Messages")
        .where("title", isEqualTo: title)
        .orderBy("timeStamp", descending: false)
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
      child: ListView(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        primary: false,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          Card(
            elevation: 8,
            child: Stack(
              children: [
                Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            )),
                        const SizedBox(height: 20),
                        fileUrl == ''
                            ? Container()
                            : InkWell(
                                onTap: () => {
                                  _showtheFile(),
                                },
                                child: _showtheFile(),
                              )
                      ],
                    )),
                PositionedCornerBanner(
                  bannerPosition: CornerBannerPosition.topRight,
                  elevation: 5,
                  bannerColor: _status == -1
                      ? const Color.fromARGB(255, 177, 18, 18)
                      : _status == 0
                          ? const Color.fromARGB(255, 228, 228, 9)
                          : _status == 1
                              ? const Color.fromARGB(255, 35, 122, 38)
                              : _status == 2
                                  ? const Color.fromARGB(255, 58, 91, 199)
                                  : const Color.fromARGB(255, 218, 145, 50),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(statusList[_status + 1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: query,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.only(top: 35),
                  physics: const BouncingScrollPhysics(),
                  primary: true,
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    int sender = 0;
                    //by default we assume sender is current user.

                    if (data['user'].toString() == receiverEmail) {
                      sender = 1;
                    }
                    return _taskItems(
                        chat: sender,
                        message: data['msg']!,
                        time: TimeFormate.myDateFormat(data['timeStamp']),
                        file: data['file']);
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

  Widget _showtheFile() {
    return Row(
      children: [
        Avatar(
          margin: const EdgeInsets.only(right: 20),
          size: 40,
          image: 'assets/images/fileIcon.png',
        ),
        Expanded(
          child: Text(
            fileUrl,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _taskItems({int? chat, String? message, String? time, int? file}) {
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
            child: (file == 1)
                ? Row(
                    children: [
                      Avatar(
                        margin: const EdgeInsets.only(right: 20),
                        size: 40,
                        image: 'assets/images/fileIcon.png',
                      ),
                      Expanded(
                        child: Text(
                          fileUrl,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Text('$message'),
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

  PlatformFile? pickedFile;
  File? file;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    final path = result!.files.single.path;

    // ignore: unnecessary_null_comparison
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      file = File(path!);
    });

    if (pickedFile != null) {
      _showSelectedFileDialogue(context);
    }
  }

  _showSelectedFileDialogue(BuildContext context) {
    final fileName = file?.path.split('/').last;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('A file is selected',
                  style: TextStyle(color: Color.fromARGB(255, 24, 30, 68))),
              content: SizedBox(
                child: Column(
                  children: [
                    Image.file(File(pickedFile!.path!)),
                    Text(
                      fileName!,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 24, 30, 68),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),

                // fit: BoxFit.cover,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'cancle',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 24, 30, 68),
                          ),
                        )),
                    FlatButton(
                      child: const Text(
                        'send',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 24, 30, 68),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        setState(() {
                          _file = 1;
                        });
                        if (file != null) {
                          UploadTask? uploadTask =
                              FileServices.uploadFile(file, fileName);

                          if (uploadTask != null) {
                            print('===============================');
                            print('get file url');
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            urlDownload = (await snapshot.ref.getDownloadURL());
                            fileUrl = urlDownload;

                            print(fileUrl);
                            _sendMessage();
                          }
                        }
                      },
                    ),
                  ],
                )
              ],
            ));
  }

  int _sendButton = 0;
  Widget _formTask() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    selectFile();
                  },
                  color: const Color.fromARGB(255, 24, 30, 68),
                  icon: const Icon(
                    Icons.attach_file_rounded,
                    color: Color.fromARGB(255, 24, 30, 68),
                    size: 28,
                  ),
                ),
                Flexible(
                  child: TextField(
                    onTap: () => {
                      setState(() {
                        _sendButton = 1;
                      }),
                    },
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
                _sendButton == 1
                    ? IconButton(
                        onPressed: () {
                          _sendMessage();
                        },
                        color: const Color.fromARGB(255, 24, 30, 68),
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Color.fromARGB(255, 24, 30, 68),
                          size: 28,
                        ),
                      )
                    : AvatarGlow(
                        animate: isListening,
                        endRadius: 25,
                        glowColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          // onPressed: toggleRecording,
                          onPressed: () {
                            _speechToText.isNotListening
                                ? _startListening()
                                : _stopListening();
                          },
                          icon: Icon(
                            _speechToText.isListening
                                ? Icons.mic
                                : Icons.mic_off,
                            color: const Color.fromARGB(255, 24, 30, 68),
                          ),
                          color: const Color.fromARGB(255, 24, 30, 68),
                        ),
                      ),
              ],
            )),
      ),
    );
  }

  void _sendMessage() {
    print('-----------------------------------');
    print('send message is invoked!');
    print(fileUrl);
    if (messageController.text.isNotEmpty || fileUrl != '') {
      tasks.doc(taskDocId).collection('Messages').add({
        "title": title.trim(),
        "msg": (_file == 1) ? fileUrl.trim() : messageController.text.trim(),
        "user": widget.userInfo.get('email').toString(),
        "receiver": receiverEmail.trim(),
        "timeStamp": DateTime.now(),
        "file": _file,
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
