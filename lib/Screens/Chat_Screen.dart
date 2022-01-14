import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Services/Database_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore sendMessage = FirebaseFirestore.instance;

  List messageList = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  fetchMessages() async {
    final CollectionReference employeesInfo =
        FirebaseFirestore.instance.collection("Messages");
    dynamic result = await DatabaseServices().getUsersInfo(employeesInfo);
    if (result == null) {
      Fluttertoast.showToast(msg: "unable to fetch the data");
    } else {
      setState(() {
        messageList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      bottomSheet: Row(
        children: [
          Flexible(
              child: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: "Enter message...",
            ),
          )),
          IconButton(
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  sendMessage.collection("Messages").doc().set({
                    "msg": messageController.text.trim(),
                    "user": loginUser!.email?.trim(),
                    "timeStamp": Timestamp.now().toString().trim(),
                  });

                  messageController.clear();
                }
              },
              icon: const Icon(Icons.send))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: ListView.builder(
                reverse: true,
                itemCount: messageList.length,
                shrinkWrap: true,
                primary: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.list),
                    //trailing: Text(messageList[index]['timeStamp']),
                    onTap: () {},
                    title: Text(messageList[index]['msg']),
                    subtitle: Text(messageList[index]['user']),
                  );
                }),
          )
        ],
      ),
    );
  }
}
