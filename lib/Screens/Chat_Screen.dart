import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Services/Database_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var loginUser = FirebaseAuth.instance.currentUser;
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore sendMessage = FirebaseFirestore.instance;

  List messageList = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  fetchMessages() async {
    final CollectionReference message =
        FirebaseFirestore.instance.collection("Messages");
    dynamic result = await DatabaseServices().fetchMessage(message);

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
                    "timeStamp": DateTime.now(),
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
                reverse: false,
                itemCount: messageList.length,
                shrinkWrap: true,
                primary: true,
                itemBuilder: (BuildContext context, int index) {
                  // DateTime dateTime = messageList[index]["timeStamp"].toDate();
                  return ListTile(
                    title: Column(
                        crossAxisAlignment:
                            loginUser!.email == messageList[index]['user']
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 250,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              color: Colors.blue.withOpacity(0.5),
                              child: Text(messageList[index]['msg']))
                        ]),
                    // leading: const Icon(Icons.list),
                    //trailing: Text(dateTime.toString()),
                    onTap: () {},
                    //subtitle: Text(messageList[index]['user']),
                  );
                }),
          )
        ],
      ),
    );
  }
}
