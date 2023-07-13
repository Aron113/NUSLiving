import 'package:NUSLiving/models/task.dart';

class User {
  final String id;
  final String username;
  final String uid;
  final String telegramHandle;
  final int year;
  final String house;
  List<Task> createdTasks;
  List<Task> appliedTasks;
  List<Task> favouriteTasks;
  final String bio;
  List<String> interests;

  User(
      {required this.id,
      required this.username,
      required this.uid,
      required this.telegramHandle,
      required this.year,
      required this.house,
      required this.createdTasks,
      required this.appliedTasks,
      required this.favouriteTasks,
      required this.bio,
      required this.interests});

  factory User.fromJson(Map<String, dynamic> json) {
    List<Task> _createdTasks = [];
    List<Task> _appliedTasks = [];
    List<Task> _favouriteTasks = [];
    List<String> _interests = [];
    for (dynamic task in json['createdTasks']) {
      _createdTasks.add(Task.fromJson(task));
    }
    for (dynamic task in json['appliedTasks']) {
      _appliedTasks.add(Task.fromJson(task));
    }
    for (dynamic task in json['favouriteTasks']) {
      _favouriteTasks.add(Task.fromJson(task));
    }
    for (dynamic interest in json['interests']) {
      _interests.add(interest.toString());
    }
    return User(
      id: json['_id'],
      username: json['username'],
      uid: json['uid'],
      telegramHandle: json['telegramHandle'],
      year: json['year'],
      house: json['house'],
      createdTasks: _createdTasks,
      appliedTasks: _appliedTasks,
      favouriteTasks: _favouriteTasks,
      bio: json['bio'],
      interests: _interests,
    );
  }
}
