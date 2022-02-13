class Task {
  late String title;
  late String description;
  late var timeStamp;
  late String dueDate;
  late String creator;
  late String assignedTo;
  late int status;

  Task({
    required this.title,
    required this.description,
    required this.timeStamp,
    required this.creator,
    required this.assignedTo,
    required this.status,
  });

  late Map<String, dynamic> taskMap = {
    'title': title,
    'description': description,
    'timeStamp': timeStamp,
    'assignedTo': assignedTo,
    'creator': creator,
    'status': status,
  };
}
