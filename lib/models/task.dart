class Task {
  //final Profile user;
  final String user;
  final String title;
  final String content;
  final String dueDate;
  final String fullDescription;
  final String time;
  final String requirements;
  //final Profile[] applicants;

  const Task(
      {required this.user,
      required this.title,
      required this.content,
      required this.dueDate,
      required this.fullDescription,
      required this.time,
      required this.requirements});
}
