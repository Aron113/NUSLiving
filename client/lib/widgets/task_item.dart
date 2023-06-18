import 'package:flutter/material.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:flutter/material.dart';
import 'package:NUSLiving/screens/tasks_screens/task_details_page.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.onPrimary,
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 1.5,
              ),
            ]),
        child: InkWell(
          onTap: () async {
            final navigator = Navigator.of(context);
            navigator.push(
              MaterialPageRoute(
                builder: (_) => TaskDetailsPage(task: task),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        // color: Colors.white,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.star_border,
                        size: 25,
                      ),
                      Text(
                        task.dueDate.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(task.briefDescription,
                  style: Theme.of(context).textTheme.bodySmall!),
            ],
          ),
        ),
      ),
    );
  }
}
