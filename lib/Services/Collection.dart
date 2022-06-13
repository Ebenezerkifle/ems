import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCollection {
  static String unDone = 'UnDone';
  static String onProgress = 'OnProgress';
  static String accepted = 'Accepted';
  static String requestForReview = 'RequestForReview';
  static String revise = 'Revise';

  static CollectionReference taskStatusCollection =
      FirebaseFirestore.instance.collection('TaskStatus');
}
