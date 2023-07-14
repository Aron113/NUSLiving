import 'package:flutter/material.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:NUSLiving/models/user.dart';
import 'package:NUSLiving/screens/tasks_screens/task_details_page.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';
import 'package:http/http.dart' as http;

class TaskItem extends StatefulWidget {
  final Task task;
  final String uid;
  bool isFavourite;

  TaskItem(
      {super.key,
      required this.uid,
      required this.task,
      required this.isFavourite});

  @override
  State<TaskItem> createState() {
    return _TaskItem();
  }
}

class _TaskItem extends State<TaskItem> {
  late bool isFavourite;

  @override
  void initState() {
    // TODO: implement initState
    isFavourite = widget.isFavourite;
    super.initState();
  }


  @override
  Widget build(context) {
    void addFavourite() async {
      var res = await http.patch(Uri.parse(
          'https://nus-living.vercel.app/api/v1/user/favourites/${widget.uid}/${widget.task.id}/add'));
      if (res.statusCode == 200) {
        setState(() {
          isFavourite = !isFavourite;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
    }

    void removeFavourite() async {
      var res = await http.patch(Uri.parse(
          'https://nus-living.vercel.app/api/v1/user/favourites/${widget.uid}/${widget.task.id}/delete'));
      if (res.statusCode == 200) {
        setState(() {
          isFavourite = !isFavourite;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
    }

    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            User author = await MyFunctions.getUserById(widget.task.author);
            var appliedTasks = await MyFunctions.getAppliedTasks(widget.uid);
            var ids = [];
            for (Task task in appliedTasks) {
              ids.add(task.id);
            }
            navigator.push(
              MaterialPageRoute(
                builder: (_) => TaskDetailsPage(
                  uid: widget.uid,
                  task: widget.task,
                  author: author,
                  isFavourite: isFavourite,
                  isApplied: ids.contains(widget.task.id),
                ),
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
                    widget.task.title,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        // color: Colors.white,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Column(
                    children: [
                      isFavourite
                          ? IconButton(
                              onPressed: removeFavourite,
                              icon: const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ))
                          : IconButton(
                              onPressed: addFavourite,
                              icon: const Icon(Icons.star_border)),
                      Text(
                        widget.task.dueDate.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(widget.task.briefDescription,
                  style: Theme.of(context).textTheme.bodySmall!),
            ],
          ),
        ),
      ),
    );
  }
}
