import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Services/FileServices.dart';
import 'package:ems/Services/Timeformat.dart';
import 'package:ems/Widget/Avatar.dart';
import 'package:ems/Widget/EmsColor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:super_banners/super_banners.dart';

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
  List statusList = [
    'Undone',
    'On Progress',
    'Approved',
    'Revise',
    'Request For Review'
  ];
  PlatformFile? pickedFile;
  File? file;
  String urlDownload = '';
  int _file = 0;
  int _sendButton = 0;
  FileServices fileServices = FileServices();
  TextEditingController messageController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EmsColor.backgroundColor,
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: _progress == 0
          ? Align(
              alignment: const Alignment(0.8, 0.7),
              child: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  backgroundColor: EmsColor.backgroundColor,
                  children: [
                    SpeedDialChild(
                      child: const Icon(
                        Icons.rate_review_sharp,
                        size: 30,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onTap: () {
                        setState(() {
                          _status = 2;
                          _taskStatusChange(2);
                        });
                      },
                      label: "Revise",
                      backgroundColor: EmsColor.reviseColor,
                    ),
                    SpeedDialChild(
                      label: "Approved",
                      // labelStyle: ,
                      child: const Icon(
                        Icons.done,
                        size: 30,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onTap: () {
                        setState(() {
                          _status = 1;
                          _taskStatusChange(1);
                        });
                      },
                      backgroundColor: EmsColor.acceptedColor,
                    ),
                  ]),
            )
          : Align(
              alignment: const Alignment(0.8, 0.7),
              child: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  backgroundColor: EmsColor.backgroundColor,
                  children: [
                    SpeedDialChild(
                      child: const Icon(
                        Icons.reviews,
                        size: 30,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onTap: () {
                        setState(() {
                          _status = 3;
                          _taskStatusChange(3);
                        });
                      },
                      label: "Request For Review",
                      backgroundColor: EmsColor.requestForReviewColor,
                    ),
                    SpeedDialChild(
                      child: const Icon(
                        Icons.run_circle,
                        size: 25,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _status = 0;
                          _taskStatusChange(0);
                        });
                      },
                      label: "On Progress",
                      backgroundColor: EmsColor.onProgressColor,
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

  void _taskStatusChange(int status) async {
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
                      ? EmsColor.unDoneColor
                      : _status == 0
                          ? EmsColor.onProgressColor
                          : _status == 1
                              ? EmsColor.acceptedColor
                              : _status == 2
                                  ? EmsColor.reviseColor
                                  : EmsColor.requestForReviewColor,
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
        const Avatar(
          margin: EdgeInsets.only(right: 20),
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
                      const Avatar(
                        margin: EdgeInsets.only(right: 20),
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
              title: Text('A file is selected',
                  style: TextStyle(color: EmsColor.backgroundColor)),
              content: SizedBox(
                child: Column(
                  children: [
                    Image.file(File(pickedFile!.path!)),
                    Text(
                      fileName!,
                      style: TextStyle(
                        color: EmsColor.backgroundColor,
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
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: EmsColor.backgroundColor,
                          ),
                        )),
                    TextButton(
                      child: Text(
                        'send',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: EmsColor.backgroundColor,
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

  Widget _formTask() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 80,
            padding: const EdgeInsets.only(bottom: 3),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    selectFile();
                  },
                  color: EmsColor.backgroundColor,
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: EmsColor.backgroundColor,
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
                        color: EmsColor.backgroundColor,
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
                            color: EmsColor.backgroundColor,
                          ),
                          color: EmsColor.backgroundColor,
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
