import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Services/Collection.dart';
import 'package:ems/Services/Timeformat.dart';
import 'package:ems/Widget/EmsColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:super_banners/super_banners.dart';

class TodoListProgress extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> userInfo;
  const TodoListProgress(this.userInfo, {Key? key}) : super(key: key);

  @override
  _TodoListProgressState createState() => _TodoListProgressState();
}

class _TodoListProgressState extends State<TodoListProgress> {
  //var loginUserEmail = widget.userInfo.get('email');

  CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  List statusList = [
    'Undone',
    'On Progress',
    'Approved',
    'Revise',
    'Request For Review'
  ];
  //List statusNum = [0, 1, 2, 3, 4];
  late String _status = statusList[0];
  late int _statusNum = 0;
  List taskList = [];
  List documentIdList = [];
  List<String> collections = [
    TaskCollection.unDone,
    TaskCollection.onProgress,
    TaskCollection.accepted,
    TaskCollection.revise,
    TaskCollection.requestForReview
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EmsColor.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _floatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            _topChat(),
            _bodyChat(),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: EmsColor.backgroundColor,
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.done,
            size: 30,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              _statusNum = 2;
              _status = statusList[2];
            });
          },
          label: statusList[2],
          backgroundColor: EmsColor.acceptedColor,
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.rate_review_sharp,
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onTap: () {
            setState(() {
              _statusNum = 3;
              _status = statusList[3];
            });
          },
          label: statusList[3],
          backgroundColor: EmsColor.reviseColor,
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.reviews,
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onTap: () {
            setState(() {
              _statusNum = 4;
              _status = statusList[4];
            });
          },
          label: statusList[4],
          backgroundColor: EmsColor.requestForReviewColor,
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.run_circle,
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onTap: () {
            setState(() {
              _statusNum = 1;
              _status = statusList[1];
            });
          },
          label: statusList[1],
          backgroundColor: EmsColor.onProgressColor,
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.not_interested_outlined,
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onTap: () {
            setState(() {
              _statusNum = 0;
              _status = statusList[0];
            });
          },
          label: statusList[0],
          backgroundColor: EmsColor.unDoneColor,
        )
      ],
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
                _status,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: Colors.black38,
          //       ),
          //       child: IconButton(
          //         onPressed: () {
          //           setState(() {
          //             _statusNum = statusNum[0];
          //             _status = statusList[0];
          //           });
          //         },
          //         color: Colors.white,
          //         icon: const Icon(
          //           Icons.not_interested_outlined,
          //           color: Colors.red,
          //           size: 25,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     Container(
          //       padding: const EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: Colors.black38,
          //       ),
          //       child: IconButton(
          //         onPressed: () {
          //           setState(() {
          //             _statusNum = statusNum[1];
          //             _status = statusList[1];
          //           });
          //         },
          //         icon: const Icon(
          //           Icons.run_circle_outlined,
          //           size: 25,
          //           color: Colors.yellow,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     Container(
          //       padding: const EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: Colors.black38,
          //       ),
          //       child: IconButton(
          //         onPressed: () {
          //           setState(() {
          //             _statusNum = statusNum[2];
          //             _status = statusList[2];
          //           });
          //         },
          //         icon: const Icon(
          //           Icons.done_all_outlined,
          //           size: 25,
          //           color: Colors.green,
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget _bodyChat() {
    Stream<QuerySnapshot<Map<String, dynamic>>> query = TaskCollection
        .taskStatusCollection
        .doc(collections[_statusNum])
        .collection(collections[_statusNum])
        .orderBy('timeStamp')
        .snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> querySM = TaskCollection
        .taskStatusCollection
        .doc(collections[_statusNum])
        .collection(collections[_statusNum])
        .where('department', isEqualTo: widget.userInfo.get('department'))
        .where('status', isEqualTo: _statusNum)
        .snapshots();
    return Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              color: Colors.white,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.userInfo.get('position') == 'General-Manager'
                  ? query
                  : querySM,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: 0,
                  );
                }
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 35),
                    physics: const BouncingScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      if (data.isNotEmpty) {
                        print('------------------------------------');
                        print(data['title']);
                        print('-------------------------------------');
                        return _tasksItem(
                          title: data['title'],
                          description: data['description'],
                          time: TimeFormate.myDateFormat(data['timeStamp']),
                          documentId: document.id,
                          status: data['status'],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  );
                } else {
                  return const SizedBox(
                    height: 0,
                    child: Center(child: Text('No task')),
                  );
                }
              },
            )));
  }

  Widget _tasksItem(
      {required String title,
      required description,
      var time,
      var documentId,
      required int status}) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TaskDetail(
        //         taskDocId, receiverEmail, description, title, time, documentId),
        //   ),
        // );
      },
      child: Stack(children: [
        Card(
          color: Colors.white,
          elevation: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 40,
              width: double.infinity,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 20),
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
                                title,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  time,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  //time.toString(),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
        CornerBanner(
          bannerColor: _statusNum == 0
              ? EmsColor.unDoneColor
              : _statusNum == 1
                  ? EmsColor.onProgressColor
                  : _statusNum == 2
                      ? EmsColor.acceptedColor
                      : _statusNum == 3
                          ? EmsColor.reviseColor
                          : EmsColor.requestForReviewColor,
          bannerPosition: CornerBannerPosition.topRight,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(statusList[_statusNum],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 5,
                )),
          ),
        ),
      ]),
    );
  }
}
