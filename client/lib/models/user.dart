import 'package:NUSLiving/models/task.dart';

enum House {
  aquila,
  noctua,
  draco,
  leo,
  ursa,
}

class User {
  final String username;
  final String password;
  final String telegramHandle;
  final int year;
  final House house;
  List<Task> userTasks;

  User(
      {required this.username,
      required this.password,
      required this.telegramHandle,
      required this.year,
      required this.house})
      : userTasks = List.empty();
}
