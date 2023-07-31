import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:NUSLiving/main.dart';
import 'package:NUSLiving/screens/tasks_screens/tasks.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './mock.dart';

void main() async {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Tasks', (tester) async {

    await tester.pumpWidget(const TasksScreen(currentTasks:[], uid:'111'));
    final titleFinder = find.text('Tasks');

    expect(titleFinder, findsWidgets);

  });
}

