import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  late String title;
  late String body;
  late String senderEmail;
  late String receiverEmail;
  late DateTime timeStamp;
  late bool seen;
  CollectionReference notification =
      FirebaseFirestore.instance.collection('Notification');

  NotificationModel(
      {required this.title,
      required this.body,
      required this.senderEmail,
      required this.receiverEmail,
      required this.timeStamp,
      required this.seen});

  sendNotification() {
    notification.add({
      'title': title,
      'body': body,
      'sender': senderEmail,
      'receiver': receiverEmail,
      'timeStamp': timeStamp,
      'seen': seen,
    });
  }
}
