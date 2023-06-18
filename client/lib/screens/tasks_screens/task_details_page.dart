import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key, required this.task});
  final Task task;

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "/Users/zhengyu/Desktop/NUSLiving/client/assets/images/nus_logo_full-vertical.png",
              width: 35,
            ),
            const SizedBox(width: 20),
            Text(
              'NUS Living',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task.title,
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                              // color: Colors.white,
                              color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star_border,
                          size: 30,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          task.dueDate.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Full Description',
                    style: Theme.of(context).textTheme.bodyLarge),
                const Divider(),
                Text(task.fullDescription,
                    style: Theme.of(context).textTheme.bodySmall!
                    // .copyWith(color: Colors.white),
                    ),
                const SizedBox(height: 20),
                Text('Requirements',
                    style: Theme.of(context).textTheme.bodyLarge),
                const Divider(),
                Text(task.requirements,
                    style: Theme.of(context).textTheme.bodySmall!
                    // .copyWith(color: Colors.white),
                    ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Posted by ${task.author}',
                  style: Theme.of(context).textTheme.bodySmall!,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(10, 20),
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
          child: Text('Apply',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}
