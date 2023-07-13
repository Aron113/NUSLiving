import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';
import 'package:NUSLiving/models/user.dart';

final formatter = DateFormat.yMd();

class Task {
  //final Profile user;
  final String id;
  final String author;
  final String title;
  final String briefDescription;
  final String dueDate;
  final String fullDescription;
  final String requirements;
  final List<String> applicants;

  const Task({
    required this.id,
    required this.author,
    required this.title,
    required this.briefDescription,
    required this.dueDate,
    required this.fullDescription,
    required this.requirements,
    required this.applicants,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    List<String> _applicants = [];
    for (dynamic user in json['applicants']) {
      _applicants.add(user);
    }
    return Task(
      id: json['_id'],
      author: json['author'][0],
      title: json['title'],
      briefDescription: json['briefDescription'],
      dueDate: formatter.format(DateTime.parse(json['dueDate'])),
      fullDescription: json['fullDescription'],
      requirements: json['requirements'],
      applicants: _applicants,
    );
  }
}
