import 'package:NUSLiving/screens/tasks_screens/tasks.dart';
import 'package:NUSLiving/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';

//change to display my tasks
class MyTasks extends StatefulWidget {
  const MyTasks({super.key, required this.uid, required this.allTasks, required this.type});

  final List<Task> allTasks;
  final String uid;
  final String type;
  

  @override
  State<MyTasks> createState() {
    return _MyTasks();
  }
}

class _MyTasks extends State<MyTasks> {
  late Future<List<Task>> _favourites;

  @override
  void initState() {
    // TODO: implement initState
    _favourites = MyFunctions.getFavouriteTasks(widget.uid);
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: _favourites,
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.hasData) {
          var tasks = snapshot.data!.toList();
          var ids = [];
          for (Task task in tasks) {
            ids.add(task.id);
          }
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
                  for (Task task in widget.allTasks.take(2)) TaskItem(uid: widget.uid, task: task, isFavourite: ids.contains(widget.uid),)
                ],
              ),
            );
        } else { //
          return Container();
        }
      }
    );
  }
}