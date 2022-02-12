import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmployeeInfo extends StatefulWidget {
  @override
  _EmployeeInfoState createState() => _EmployeeInfoState();
}

class _EmployeeInfoState extends State<EmployeeInfo> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chat with \nyour subordinate',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Avatar(
                        margin: const EdgeInsets.only(right: 15),
                        image: 'assets/images/${index + 1}.jpg',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .where('email',
                      isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  Fluttertoast.showToast(msg: "Error occured");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitDoubleBounce(
                    color: Colors.blue,
                  );
                }
                return ListView(
                  padding: const EdgeInsets.only(top: 35),
                  physics: const BouncingScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    String avatar = 'assets/images/2.jpg';
                    String name = data['firstname'] + " " + data['middlename'];
                    String time = '08.10';
                    String receiverEmail = data['email'];
                    String position = data['position'];
                    return ChatRoomBuilder(
                        avatar, name, time, receiverEmail, position);
                  }).toList(),
                );
              },
            )));
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

class ChatRoomBuilder extends StatefulWidget {
  String avatar;
  String name;
  String time;
  String receiverEmail;
  String position;
  ChatRoomBuilder(
      this.avatar, this.name, this.time, this.receiverEmail, this.position,
      {Key? key})
      : super(key: key);

  @override
  _ChatRoomBuilderState createState() =>
      _ChatRoomBuilderState(avatar, name, time, receiverEmail, position);
}

class _ChatRoomBuilderState extends State<ChatRoomBuilder> {
  String avatar;
  String name;
  String time;
  String receiverEmail;
  String position;

  _ChatRoomBuilderState(
      this.avatar, this.name, this.time, this.receiverEmail, this.position);

  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(receiverEmail, name, position),
            ),
          );
        },
        child: Stack(children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 20),
            elevation: 0,
            child: Row(
              children: [
                Avatar(
                  margin: const EdgeInsets.only(right: 20),
                  size: 60,
                  image: avatar,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              time,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (position != null)
                            ? LastMessage(chatDocId: position)
                            : Container(),
                      ]),
                ),
                //   ],
                // ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _fetchNotification(loginUserEmail.toString(), receiverEmail),
          ),
        ]));
  }

  Widget _fetchNotification(String loginUserEmail, String receiverEmail) {
    int count = 0;
    CollectionReference notifications =
        FirebaseFirestore.instance.collection("Notifications");
    var query = notifications
        .where('seen', isEqualTo: false)
        .where('receiver', isEqualTo: loginUserEmail)
        .where('title', isEqualTo: 'Message')
        .snapshots();

    return StreamBuilder(
        stream: query,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            count++;
            return Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blueAccent),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      count.toString(),
                      style: const TextStyle(color: Colors.white),
                    )));
          } else {
            return Container();
          }
        });
  }
}

class LastMessage extends StatefulWidget {
  final String chatDocId;
  const LastMessage({required this.chatDocId, Key? key}) : super(key: key);

  @override
  _LastMessageState createState() => _LastMessageState();
}

class _LastMessageState extends State<LastMessage> {
  CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chats
            .doc(widget.chatDocId.trim().toString())
            .collection('Messages')
            .orderBy('timeStamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitDoubleBounce(
              color: Colors.blue,
            );
          }
          if (snapshot.hasData) {
            DocumentSnapshot? last = snapshot.data!.docs.length > 0
                ? snapshot.data!.docs.last
                : null;
            return Text(
              '${last?.get("msg") ?? ""}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return Container();
        });
  }
}
