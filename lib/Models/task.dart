class TaskInfo {
  late String title;
  late String description;
  late var timeStamp;
  late String dueDate;
  late String creator;
  late String assignedTo;
  late int status;
  late String department;
  late String fileUrl;

  TaskInfo({
    required this.title,
    required this.description,
    required this.timeStamp,
    required this.creator,
    required this.assignedTo,
    required this.status,
    required this.department,
  });

  late Map<String, dynamic> taskMap = {
    'title': title,
    'description': description,
    'timeStamp': timeStamp,
    'assignedTo': assignedTo,
    'creator': creator,
    'status': status,
    'department': department,
    if (fileUrl != null) 'fileUrl': fileUrl
  };
}
