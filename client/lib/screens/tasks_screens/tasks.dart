import 'package:NUSLiving/screens/tasks_screens/createTask.dart';
import 'package:NUSLiving/screens/user_screens/createAnAccount.dart';
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../widgets/task_item.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.currentTasks, required this.uid});

  final List<Task> currentTasks;
  final String uid;

  @override
  State<TasksScreen> createState() => _TaskPageScreen();
}

class _TaskPageScreen extends State<TasksScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      backgroundColor: Colors.white,
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                for (Task task in widget.currentTasks) TaskItem(task: task),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (__) => CreateTaskScreen(uid: widget.uid)),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
