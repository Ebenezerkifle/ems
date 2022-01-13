import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore sendMessage = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Messages"),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: "Enter Message...",
                ),
              )),
              IconButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      sendMessage.collection("Messages").doc().set({
                        "msg": messageController.text.trim(),
                        "user": loginUser!.email?.trim(),
                      });
                      messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}
