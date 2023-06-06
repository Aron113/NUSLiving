import 'package:flutter/material.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      // color: Colors.white,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(
                  width: 230,
                ),
                Column(children: [
                  const Icon(
                    Icons.star_border,
                    size: 25,
                  ),
                  Text(
                    task.dueDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ])
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(task.content, style: Theme.of(context).textTheme.bodySmall!
                // .copyWith(color: Colors.white),
                ),
            // may want to restructure to include the user below?
            //   const SizedBox(
            //     height: 7,
            //   ),
            //   Text(
            //     task.user,
            //     style: Theme.of(context).textTheme.bodySmall,
            //   )
          ],
        ),
      ),
    );
  }
}
