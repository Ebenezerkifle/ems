import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatHomePage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  const ChatHomePage(this.userInfo, {Key? key}) : super(key: key);
  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  var loginUserEmail = FirebaseAuth.instance.currentUser?.email;
  CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

  var scaffoldKey = GlobalKey<ScaffoldState>();
  late String _titleTop;
  late int _assign;

  @override
  void initState() {
    setState(() {
      if (widget.userInfo.get('position') == 'General-Manager') {
        _assign = 1;
        _titleTop = 'Chat with \nyour Subordinates';
      } else {
        _assign = 0;
        _titleTop = 'Chat with \nyour Manager';
      }
    });
    super.initState();
  }

  void setTopTitle() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      //endDrawer: NavigationDrawerWidget(),
      backgroundColor: const Color.fromARGB(255, 24, 30, 68),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_titleTop',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                width: 50,
              ),
              _topbuttons(),
            ],
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

  Widget _topbuttons() {
    if (widget.userInfo.get('position') == 'Sub-Manager') {
      return Row(
        children: [
          Container(
            height: _assign == 1 ? 50 : 40,
            width: _assign == 1 ? 50 : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black26,
            ),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _titleTop = 'Chat with \nyour subordinate';
                    _assign = 1;
                  });
                },
                color: Colors.white,
                icon: const Icon(Icons.arrow_downward_outlined)),
          ),
          const SizedBox(width: 10),
          Container(
            height: _assign == 0 ? 50 : 40,
            width: _assign == 0 ? 50 : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black26,
            ),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _titleTop = 'Chat with \nyour Manager';
                    _assign = 0;
                  });
                },
                color: Colors.white,
                icon: const Icon(Icons.arrow_upward_outlined)),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> query;
    if (widget.userInfo.get('position') == 'General-Manager') {
      query = FirebaseFirestore.instance
          .collection("Users")
          .where('position', isNotEqualTo: 'General-Manager')
          .snapshots();
    } else if (widget.userInfo.get('position') == 'Employee') {
      query = FirebaseFirestore.instance
          .collection("Users")
          .where('position', isEqualTo: 'Sub-Manager')
          .where('department', isEqualTo: widget.userInfo.get('department'))
          .snapshots();
    } else if (widget.userInfo.get('position') == 'Sub-Manager' &&
        _assign == 1) {
      query = FirebaseFirestore.instance
          .collection("Users")
          .where('position', isEqualTo: 'Employee')
          .where('department', isEqualTo: widget.userInfo.get('department'))
          .snapshots();
    } else {
      query = FirebaseFirestore.instance
          .collection("Users")
          .where('position', isEqualTo: 'General-Manager')
          .snapshots();
    }

    return query;
  }

  Widget _body() {
    Stream<QuerySnapshot<Map<String, dynamic>>> query = fetchUsers();
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
              stream: widget.userInfo.get('position') == 'General-Manager'
                  ? query
                  : widget.userInfo.get('position') == 'Employee'
                      ? query
                      : _assign == 0
                          ? query
                          : query,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  Fluttertoast.showToast(msg: "Error occured");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitChasingDots(
                    color: Color.fromARGB(255, 24, 30, 68),
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
                    return ChatRoomBuilder(avatar, name, time, receiverEmail);
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
  ChatRoomBuilder(this.avatar, this.name, this.time, this.receiverEmail,
      {Key? key})
      : super(key: key);

  @override
  _ChatRoomBuilderState createState() =>
      _ChatRoomBuilderState(avatar, name, time, receiverEmail);
}

class _ChatRoomBuilderState extends State<ChatRoomBuilder> {
  String avatar;
  String name;
  String time;
  String receiverEmail;

  _ChatRoomBuilderState(this.avatar, this.name, this.time, this.receiverEmail);

  var loginUserEmail = FirebaseAuth.instance.currentUser?.email;
  CollectionReference chats = FirebaseFirestore.instance.collection('Chats');
  var chatDocId;

  @override
  void initState() {
    _fetchChatDocId().then((value) {
      setState(() {
        chatDocId = value;
        print('----------------------------------------');
        print("chatDocId: " + chatDocId);
      });
    });
    super.initState();
  }

  Future _fetchChatDocId() async {
    var chatDocId;
    await chats
        .where("Users", isEqualTo: {loginUserEmail: null, receiverEmail: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            chatDocId = querySnapshot.docs.single.id;
          } else {
            await chats.add({
              'Users': {loginUserEmail: null, receiverEmail: null}
            }).then((value) => {
                  chatDocId = value.id,
                });
          }
        });
    return chatDocId;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(receiverEmail, name, chatDocId),
            ),
          );
        },
        child: Stack(children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 20),
            elevation: 2,
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (chatDocId != null)
                                  ? LastMessage(chatDocId: chatDocId)
                                  : Container(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: _fetchNotification(
                                    loginUserEmail.toString(), receiverEmail),
                              ),
                            ]),
                      ]),
                ),
                //   ],
                // ),
              ],
            ),
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
            return const Center(
              child: Text('....'),
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
