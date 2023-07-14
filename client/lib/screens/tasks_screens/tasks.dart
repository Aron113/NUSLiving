import 'package:NUSLiving/screens/tasks_screens/createTask.dart';
import 'package:NUSLiving/screens/user_screens/createAnAccount.dart';
import 'package:NUSLiving/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.currentTasks, required this.uid});

  final List<Task> currentTasks;
  final String uid;

  @override
  State<TasksScreen> createState() => _TaskPageScreen();
}

class _TaskPageScreen extends State<TasksScreen> {
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

          return Scaffold(
              appBar: AppBar(title: const Text('Tasks')),
              backgroundColor: Colors.white,
              // backgroundColor: Theme.of(context).colorScheme.background,
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (Task task in widget.currentTasks)
                          TaskItem(
                            uid: widget.uid,
                            task: task,
                            isFavourite: ids.contains(task.id),
                          ),
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
              ));
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Loading'),
            ),
          );
        }
      },
    );
  }
}
