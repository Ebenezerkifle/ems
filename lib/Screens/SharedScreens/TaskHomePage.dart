import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/TaskPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskHomePage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;

  TaskHomePage(this.userInfo, {Key? key}) : super(key: key);

  @override
  _TaksHomePageState createState() => _TaksHomePageState();
}

class _TaksHomePageState extends State<TaskHomePage> {
  var loginUserEmail = FirebaseAuth.instance.currentUser?.email;
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  var scaffoldKey = GlobalKey<ScaffoldState>();
  late int _assign;
  late String _titleTop;

  @override
  void initState() {
    if (widget.userInfo.get('position') == 'General-Manager') {
      setState(() {
        _titleTop = 'Assign Tasks to \nyour subordinate';
        _assign = 0;
      });
    } else {
      setState(() {
        _titleTop = 'Tasks \nAssigned to you';
        _assign = 1;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromARGB(255, 24, 30, 68),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _titleTop,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(width: 40),
              _topbuttons(),
              const SizedBox(width: 10)
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
            height: _assign == 0 ? 50 : 40,
            width: _assign == 0 ? 50 : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black26,
            ),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _titleTop = 'Assign Tasks to \nyour subordinate';
                    _assign = 0;
                  });
                },
                color: Colors.white,
                icon: const Icon(Icons.arrow_downward_rounded)),
          ),
          const SizedBox(width: 10),
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
                    _titleTop = 'Tasks \nAssigned to you';
                    _assign = 1;
                  });
                },
                color: Colors.white,
                icon: const Icon(Icons.arrow_upward_rounded)),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _body() {
    Stream<QuerySnapshot<Map<String, dynamic>>> queryGM = FirebaseFirestore
        .instance
        .collection("Users")
        .where('position', isEqualTo: 'Sub-Manager')
        .snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> querySM = FirebaseFirestore
        .instance
        .collection("Users")
        .where('position', isEqualTo: 'Employee')
        .where('department', isEqualTo: widget.userInfo.get('department'))
        .snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> querySM2 = FirebaseFirestore
        .instance
        .collection("Users")
        .where('position', isEqualTo: 'General-Manager')
        .snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> queryEM = FirebaseFirestore
        .instance
        .collection("Users")
        .where('position', isEqualTo: 'Sub-Manager')
        .where('department', isEqualTo: widget.userInfo.get('department'))
        .snapshots();
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
                    ? queryGM
                    : widget.userInfo.get('position') == 'Employee'
                        ? queryEM
                        : _assign == 0
                            ? querySM
                            : querySM2,
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
                  if (snapshot.hasData) {
                    return ListView(
                      padding: const EdgeInsets.only(top: 35),
                      physics: const BouncingScrollPhysics(),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String avatar = 'assets/images/1.jpg';
                        String name =
                            data['firstname'] + " " + data['middlename'];
                        String time = '08.10';
                        String receiverEmail = data['email'];
                        String department = data['department'];
                        String position = data['position'];
                        return _itemChats(avatar, name, time, receiverEmail,
                            department, position, context);
                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: Text("There is Nothing to Show!"),
                    );
                  }
                })));
  }

  Widget _itemChats(
      String avatar,
      String name,
      String time,
      String receiverEmail,
      String department,
      String position,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskPage(widget.userInfo, receiverEmail, name,
                department, position, _assign),
          ),
        );
      },
      child: Card(
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
                        '$name',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$time',
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        department,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' $position',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 79, 83, 90),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
