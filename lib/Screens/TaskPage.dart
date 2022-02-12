// ignore: file_names
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class TaskPage extends StatefulWidget {
  String receiverEmail;
  String name;

  // ignore: use_key_in_widget_constructors
  TaskPage(this.receiverEmail, this.name);

  @override
  _TaskPageState createState() =>
      // ignore: no_logic_in_create_state
      _TaskPageState(receiverEmail, name);
}

class _TaskPageState extends State<TaskPage> {
  var loginUser = FirebaseAuth.instance.currentUser!.email;

  CollectionReference chats = FirebaseFirestore.instance.collection("Chats");

  String receiverEmail;
  String name;

  _TaskPageState(this.receiverEmail, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            _topChat(),
            //_bodyChat(),
            const SizedBox(
              height: 5,
            )
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: IconButton(
                  onPressed: () {
                    _createnewTask(context);
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.add_task,
                    color: Colors.white,
                    size: 25,
                  ),
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
                  Icons.message,
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
      // child: StreamBuilder<QuerySnapshot>(

      //   builder:
      //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       Fluttertoast.showToast(msg: "Error occured");
      //     }
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return ListView(
      //       padding: const EdgeInsets.only(top: 35),
      //       physics: const BouncingScrollPhysics(),
      //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //         Map<String, dynamic> data =
      //             document.data()! as Map<String, dynamic>;
      //         int sender = 0; //by default we assume sender is current user.
      //         if (data['user'].toString() == receiverEmail) {
      //           sender = 1;
      //         }
      //         return _itemChat(
      //           avatar: 'assets/images/5.jpg',
      //           chat: sender,
      //           message: data['msg']!,
      //           time: '18.00',
      //         );
      //       }).toList(),
      //     );
      //   },
      // )),
    ));
  }

  // 0 = Send
  // 1 = Recieved
  Widget _itemChat({int? chat, String? avatar, message, time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        avatar != null
            ? Avatar(
                image: avatar,
                size: 50,
              )
            : Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              ),
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

  void _createnewTask(context) {
    String title;
    String description;
    showDialog(
        context: context,
        builder: (BuildContext builder) {
          return Material(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: Text("New Task",
                          style: TextStyle(
                              fontSize: 40.0, color: Colors.blueAccent))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  TextFormField(
                    // validator: (value) => value!.length < 6
                    //     ? "Enter 6+ chars for password"
                    //     : null,
                    onChanged: (value) => {setState(() => title = value)},
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  TextFormField(
                    // validator: (value) => value!.length < 6
                    //     ? "Enter 6+ chars for password"
                    //     : null,
                    onChanged: (value) => {setState(() => description = value)},
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Description...",
                    ),
                  ),
                ],
              ),
            ),
          ));
        });
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
