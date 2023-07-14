import 'package:flutter/material.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:NUSLiving/models/user.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';
import 'package:NUSLiving/screens/tasks_screens/editTask.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:NUSLiving/screens/user_screens/visitingProfile.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage(
      {super.key,
      required this.uid,
      required this.task,
      required this.author,
      required this.isFavourite,
      required this.isApplied});
  final Task task;
  final String uid;
  final User author;
  final bool isFavourite;
  final bool isApplied;
  @override
  State<TaskDetailsPage> createState() {
    return _TaskDetailsPage();
  }
}

class _TaskDetailsPage extends State<TaskDetailsPage> {
  late bool isFavourite;
  late bool isApplied;
  late List<String> applicants;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFavourite = widget.isFavourite;
    isApplied = widget.isApplied;
    applicants = widget.task.applicants;
  }

  @override
  Widget build(context) {
    void addFavourite() async {
      var res = await http.patch(Uri.parse(
          'http://10.0.2.2:3000/api/v1/user/favourites/${widget.uid}/${widget.task.id}/add'));
      if (res.statusCode == 200) {
        setState(() {
          isFavourite = true;
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
          'http://10.0.2.2:3000/api/v1/user/favourites/${widget.uid}/${widget.task.id}/delete'));
      if (res.statusCode == 200) {
        setState(() {
          isFavourite = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
    }

    void apply() async {
      var res = await http.patch(Uri.parse(
          'http://10.0.2.2:3000/api/v1/user/applied/${widget.uid}/${widget.task.id}/add'));
      if (res.statusCode == 200) {
        setState(() {
          isApplied = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
    }

    void unapply() async {
      var res = await http.patch(Uri.parse(
          'http://10.0.2.2:3000/api/v1/user/applied/${widget.uid}/${widget.task.id}/delete'));
      if (res.statusCode == 200) {
        setState(() {
          isApplied = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
    }

    void showApplicants() async {
      var navigator = Navigator.of(context);
      var _applicants = [];
      for (String userid in widget.task.applicants) {
        User user = await MyFunctions.getUserById(userid);
        _applicants.add(user);
      }
      showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Applicants'),
            content: SizedBox(
              height: 200,
              width: 200,
              child: SingleChildScrollView(
                  child: (Column(
                children: [
                  SizedBox(height: 20),
                  for (User user in _applicants)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  VisitingProfileScreen(user: user)));
                        },
                        child: Text(
                          user.username,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ))
                ],
              ))),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                isDefaultAction: false,
                isDestructiveAction: false,
                child: const Text('Cancel'),
              )
            ],
          );
        },
      );
    }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          widget.task.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  // color: Colors.white,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Full Description',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const Divider(),
                    Text(widget.task.fullDescription,
                        style: Theme.of(context).textTheme.bodySmall!
                        // .copyWith(color: Colors.white),
                        ),
                    const SizedBox(height: 20),
                    Text('Requirements',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const Divider(),
                    Text(widget.task.requirements,
                        style: Theme.of(context).textTheme.bodySmall!
                        // .copyWith(color: Colors.white),
                        ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Posted by ${widget.author.username}',
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  ],
                ),
              ),
            ),
            widget.uid == widget.author.uid
                ? ElevatedButton(
                    onPressed: showApplicants,
                    child: Text(
                      'View Appplicants',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondary),
                  )
                : SizedBox(
                    height: 10,
                  )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0),
        ),
        child: widget.uid != widget.author.uid
            ? isApplied
                ? ElevatedButton(
                    onPressed: unapply,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(10, 20),
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: Text('Unapply',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)),
                  )
                : ElevatedButton(
                    onPressed: apply,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(10, 20),
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: Text('Apply',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)),
                  )
            : ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            EditTaskScren(uid: widget.uid, task: widget.task)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(10, 20),
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: Text('Edit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white)),
              ),
      ),
    );
  }
}
