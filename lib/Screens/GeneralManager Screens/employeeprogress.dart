import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/TaskPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmployeeProgress extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  const EmployeeProgress({required this.userInfo, Key? key}) : super(key: key);

  @override
  _EmployeeProgressState createState() => _EmployeeProgressState();
}

class _EmployeeProgressState extends State<EmployeeProgress> {
  var loginUserEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

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
            'Employee \nProgress',
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
    Stream<QuerySnapshot<Map<String, dynamic>>> queryGM = FirebaseFirestore
        .instance
        .collection("Users")
        .where('email', isNotEqualTo: loginUserEmail)
        .snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> querySM = FirebaseFirestore
        .instance
        .collection("Users")
        .where('position', isEqualTo: 'Employee')
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
                    : querySM,
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
            builder: (context) => TaskPage(
                widget.userInfo, receiverEmail, name, department, position, 1),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
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
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        position,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        department,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
