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
  late int fileStatus;
  late String fileName;

  TaskInfo(
      {required this.title,
      required this.description,
      required this.timeStamp,
      required this.creator,
      required this.assignedTo,
      required this.status,
      required this.department,
      required this.fileStatus});

  late Map<String, dynamic> taskMap = {
    'title': title,
    'description': description,
    'timeStamp': timeStamp,
    'assignedTo': assignedTo,
    'creator': creator,
    'status': status,
    'department': department,
    'file': fileStatus,
    'fileUrl': (fileStatus == 1) ? fileUrl : '',
    'fileName': (fileStatus == 1) ? fileName : '',
  };

  late Map<dynamic, String> fetchTask = {
    title: 'title',
    description: 'description'
  };
}
