import 'package:ems/Models/Employee.dart';

class Chat {
  final String message;
  final Employee sender;
  final Employee receiver;
  final DateTime timeStamp;

  const Chat(this.message, this.sender, this.receiver, this.timeStamp);

  static Chat fromJson(Map<String, dynamic> json) =>
      Chat(json['msg'], json['sender'], json['sender'], json['receiver']);

  Map<String, dynamic> toJson() => {
        'msg': message,
        'sender': sender,
        'receiver': receiver,
        'timeStamp': timeStamp,
      };
}
