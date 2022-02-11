import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;
  // String firstName;
  // String lastName;
  @override
  Widget build(BuildContext context) {
    setState(() {
      var user = FirebaseFirestore.instance;
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat Room"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where('email',
                  isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
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
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              ChatWith(data['email'], data['firstName'])));
                    },
                    child: ListTile(
                      title: Text(data['firstName']),
                      subtitle: Text(data['email']),
                    ));
              }).toList(),
            );
          },
        ));
  }
}

class ChatWith extends StatefulWidget {
  String firstName;
  String receiverEmail;
  ChatWith(this.receiverEmail, this.firstName, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _ChatWithState createState() => _ChatWithState(receiverEmail, firstName);
}

class _ChatWithState extends State<ChatWith> {
  String receiverEmail;
  String firstName;
  _ChatWithState(this.receiverEmail, this.firstName);

  var loginUser = FirebaseAuth.instance.currentUser;
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore sendMessage = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(firstName),
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
                      "receiver": receiverEmail.trim(),
                      "timeStamp": DateTime.now(),
                    });
                    messageController.clear();
                  }
                },
                icon: const Icon(Icons.send))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Messages").snapshots(),
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
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Column(
                      crossAxisAlignment: loginUser!.email == data['user']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 270,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            color: Colors.blue.withOpacity(0.5),
                            child: Text(data['msg']))
                      ]),
                  // leading: const Icon(Icons.list),
                  //trailing: Text(dateTime.toString()),
                  onTap: () {},
                  //subtitle: Text(messageList[index]['user']),
                );
              }).toList(),
            );
          },
        ));
  }
}
