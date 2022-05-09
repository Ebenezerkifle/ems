import 'package:ems/Models/Employee.dart';

class ChatModel {
  final String message;
  final Employee sender;
  final Employee receiver;
  final DateTime timeStamp;

  const ChatModel(this.message, this.sender, this.receiver, this.timeStamp);

  static ChatModel fromJson(Map<String, dynamic> json) =>
      ChatModel(json['msg'], json['sender'], json['sender'], json['receiver']);

  Map<String, dynamic> toJson() => {
        'msg': message,
        'sender': sender,
        'receiver': receiver,
        'timeStamp': timeStamp,
      };
}
