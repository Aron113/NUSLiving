

import 'package:NUSLiving/screens/tasks_screens/tasks.dart';
import 'package:NUSLiving/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:NUSLiving/models/task.dart';

//change to display my tasks
class MyTasks extends StatefulWidget {
  const MyTasks({super.key, required this.allTasks});

  final List<Task> allTasks;

  @override
  State<MyTasks> createState() {
    return _MyTasks();
  }
}

class _MyTasks extends State<MyTasks> {
  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Column(
        // clipBehavior: Clip.none,
        children: [
          Text(
            'My Tasks',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
          ),
          const SizedBox(height: 10),
          for (Task task in widget.allTasks.take(2)) TaskItem(task: task)
        ],
      ),
    );
  }
}
