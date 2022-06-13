import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Services/Timeformat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Screens/GeneralManager Screens/EmployeeInfo_Screen.dart';

class EmployeesLocationScreen extends StatefulWidget {
  bool onRegion;
  List emailList;
  List timeStamp;
  EmployeesLocationScreen(this.onRegion, this.emailList, this.timeStamp,
      {Key? key})
      : super(key: key);

  @override
  State<EmployeesLocationScreen> createState() =>
      _EmployeesLocationScreenState();
}

class _EmployeesLocationScreenState extends State<EmployeesLocationScreen> {
  CollectionReference locationFireStore =
      FirebaseFirestore.instance.collection("Locations");

  // @override
  // void initState() {
  //   _fetchListOfEmails(widget.onRegion).then((value) {
  //     setState(() {
  //       listOfEmails = value;
  //     });
  //   });
  //   super.initState();
  // }

  // Future _fetchListOfEmails(bool onRegion) async {
  //   List list = [];
  //   print('=====================');
  //   await locationFireStore
  //       // .where('onRegion', isEqualTo: onRegion)
  //       .get()
  //       .then((q) {
  //     for (var element in q.docs) {
  //       list.add(element.get('email'));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          widget.onRegion
              ? const Text(
                  'Employees \non Working Area',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              : const Text(
                  'Employees \nout Working Area',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                        image: 'assets/images/${index + 4}.jpg',
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
    print(widget.emailList);
    return Expanded(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: widget.emailList.length,
              itemBuilder: (BuildContext context, int index) {
                print('----------------------------');
                print(index);
                print(widget.timeStamp);
                print(widget.emailList[index]);
                Stream<QuerySnapshot<Map<String, dynamic>>> query =
                    FirebaseFirestore.instance
                        .collection("Users")
                        .where('email', isEqualTo: widget.emailList[index])
                        .snapshots();
                return StreamBuilder<QuerySnapshot>(
                    stream: query,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        Fluttertoast.showToast(msg: "Error occured");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SpinKitDoubleBounce(
                          color: Color.fromARGB(255, 18, 53, 82),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView(
                          padding: const EdgeInsets.only(top: 35),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            String avatar = 'assets/images/1.jpg';
                            String name =
                                data['firstname'] + " " + data['middlename'];
                            String time = TimeFormate.myDateFormat(
                                    widget.timeStamp[index])
                                .toString();
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
                    });
              },
            )));
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
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TaskPage(widget.userInfo, receiverEmail, name,
        //         department, position, _assign),
        //   ),
        // );
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '$name ',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          ' $time',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color.fromARGB(255, 145, 138, 138),
                              fontWeight: FontWeight.bold),
                        ),
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
                        '$position ',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' $department',
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
