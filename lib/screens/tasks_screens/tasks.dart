import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../data/tasks.dart';
import '../../widgets/task_item.dart';

const currentTasks = tasks;

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TaskPageScreen();
}

class _TaskPageScreen extends State<TasksPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      backgroundColor: Colors.white,
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Column(
          children: [
            for (Task task in currentTasks) TaskItem(task: task),
          ],
        ),
      ),
    );
  }
}
