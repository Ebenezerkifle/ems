import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

final _speech = SpeechToText();

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  String receiverEmail;
  String name;
  var chatDocId;

  // ignore: use_key_in_widget_constructors
  ChatPage(this.receiverEmail, this.name, this.chatDocId);

  @override
  _ChatPageState createState() =>
      // ignore: no_logic_in_create_state
      _ChatPageState(receiverEmail, name, chatDocId);
}

class _ChatPageState extends State<ChatPage> {
  var loginUserEmail = FirebaseAuth.instance.currentUser?.email;
  TextEditingController messageController = TextEditingController();

  var loginUser = FirebaseAuth.instance.currentUser;

  CollectionReference chats = FirebaseFirestore.instance.collection("Chats");
  CollectionReference notifications =
      FirebaseFirestore.instance.collection("Notifications");

  String receiverEmail;
  String name;
  // ignore: prefer_typing_uninitialized_variables
  var chatDocId;

  _ChatPageState(this.receiverEmail, this.name, this.chatDocId);

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String message = 'This is test!';
  bool isListening = false;

  @override
  void initState() {
    print('-------------------------------');
    print(chatDocId);
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
      backgroundColor: const Color.fromARGB(255, 24, 30, 68),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topChat(),
                _bodyChat(),
                const SizedBox(
                  height: 120,
                )
              ],
            ),
            _formChat(),
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
            stream: chats
                .doc(chatDocId.toString())
                .collection("Messages")
                .orderBy('timeStamp')
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
              return ListView(
                padding: const EdgeInsets.only(top: 35),
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  int sender = 0; //by default we assume sender is current user.
                  if (data['user'].toString() == receiverEmail) {
                    sender = 1;
                  }
                  return _itemChat(
                    chat: sender,
                    message: data['msg']!,
                    time: '08.00',
                  );
                }).toList(),
              );
            },
          )),
    );
  }

  // 0 = Send
  // 1 = Recieved
  Widget _itemChat({int? chat, message, time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        chat == 0
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : Container(),
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

  Widget _formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            color: Colors.white,
            child: Row(
              children: [
                AvatarGlow(
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
                      _speechToText.isListening ? Icons.mic : Icons.mic_off,
                      color: Colors.blue,
                    ),
                    color: Colors.blueAccent,
                  ),
                ),
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

  _sendMessage() {
    if (messageController.text.isNotEmpty) {
      chats.doc(chatDocId).collection('Messages').add({
        "msg": messageController.text.trim(),
        "user": loginUser?.email?.trim(),
        "receiver": receiverEmail.trim(),
        "timeStamp": DateTime.now(),
      });

      NotificationModel notificationModel = NotificationModel(
          title: 'Message',
          body: messageController.text.trim(),
          senderEmail: loginUserEmail.toString(),
          receiverEmail: receiverEmail,
          timeStamp: DateTime.now(),
          seen: false);
      notificationModel.sendNotification();
      messageController.clear();
    }
  }
}
