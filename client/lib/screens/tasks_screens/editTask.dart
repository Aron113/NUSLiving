import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:NUSLiving/screens/home.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';
import 'package:intl/intl.dart';
import 'package:NUSLiving/screens/home.dart';
import 'package:flutter/cupertino.dart';

final formatter = DateFormat.yMd();

class EditTaskScren extends StatefulWidget {
  const EditTaskScren({super.key, required this.uid, required this.task});

  final String uid;
  final Task task;

  @override
  State<EditTaskScren> createState() {
    return _EditTaskScren();
  }
}

class _EditTaskScren extends State<EditTaskScren> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _briefDescription = '';
  var _dueDate = '';
  var _fullDescription = '';
  var _requirements = '';
  var _isShown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dueDate = widget.task.dueDate;
  }

  void deleteTask() async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete?'),
          actions: [
            // The "Yes" button
            CupertinoDialogAction(
              onPressed: () async {
                var response = await http.delete(
                  Uri.parse(
                      'https://nus-living.vercel.app/api/v1/tasks/${widget.task.id}'),
                );
                if (response.statusCode != 204) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('error : $response.message')),
                    );
                  }
                } else {
                  var tasks = await MyFunctions.getUserTasks(widget.uid);
                  setState(() {
                    _isShown = false;
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Succesfully deleted task!')),
                      );
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(
                          uid: widget.uid,
                          tasks: tasks,
                        ),
                      ),
                    );
                  });
                }
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: const Text('Confirm'),
            ),
            // The "No" button
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

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      var user = await MyFunctions.getUserByUid(widget.uid);
      var res = await http.patch(
        Uri.parse('https://nus-living.vercel.app/api/v1/tasks/${widget.task.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "title": _title,
          "author": user.id,
          "briefDescription": _briefDescription,
          "dueDate": _dueDate,
          "fullDescription": _fullDescription,
          "requirements": _requirements,
        }),
      );
      if (res.statusCode == 200) {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Successfully updated task'),
        ));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
      var tasks = await MyFunctions.getUserTasks(widget.uid);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            uid: widget.uid,
            tasks: tasks,
          ),
        ),
      );
    }
  }

  void presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, initialDate: now, firstDate: now, lastDate: lastDate);
    if (pickedDate != null) {
      setState(() {
        _dueDate = formatter.format(pickedDate);
      });
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/nus_logo_full-vertical.png",
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
        padding: const EdgeInsets.all(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Title',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: deleteTask,
                          icon: const Icon(
                            Icons.delete,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: widget.task.title,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 4 ||
                            value.trim().length > 50) {
                          return 'Must be between 5 and 30 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                    Text(
                      'Brief Description',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: widget.task.briefDescription,
                      maxLines: 3,
                      maxLength: 120,
                      decoration: const InputDecoration(
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 120) {
                          return 'Must be between 1 and 120 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _briefDescription = value!;
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Full Description',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: widget.task.fullDescription,
                      maxLines: 6,
                      maxLength: 1000,
                      decoration: const InputDecoration(
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 1000) {
                          return 'Must be between 1 and 1000 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _fullDescription = value!;
                      },
                    ),
                    Text(
                      'Requirements',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: widget.task.requirements,
                      maxLines: 5,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 300) {
                          return 'Must be between 1 and 300 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _requirements = value!;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dueDate == ''
                            ? const Text('Select Date')
                            : Text(_dueDate),
                        IconButton(
                            icon: const Icon(Icons.calendar_month),
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                            ),
                            onPressed: presentDatePicker),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: (submitForm),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
