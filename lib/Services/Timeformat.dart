import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class TimeFormate {
  static String myDateFormat(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }
}
