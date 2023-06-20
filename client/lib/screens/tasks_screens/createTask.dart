import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:NUSLiving/screens/home.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, required this.uid});

  final String uid;

  @override
  State<CreateTaskScreen> createState() {
    return _CreateTaskScreen();
  }
}

class _CreateTaskScreen extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _briefDescription = '';
  var _dueDate = '';
  var _fullDescription = '';
  var _requirements = '';

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var user = await MyFunctions.getUser(widget.uid);
      var res = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/v1/tasks/create/${widget.uid}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "title": _title,
          "author": [user.id],
          "briefDescription": _briefDescription,
          "dueDate": _dueDate,
          "fullDescription": _fullDescription,
          "requirements": _requirements,
        }),
      );

      if (res.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  Home(myTasks: const [], uid: widget.uid),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sucessfully submitted')),
          );
        }
        _formKey.currentState!.reset();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
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
              "/Users/assets/images/nus_logo_full-vertical.png/Desktop/NUSLiving/client/assets/images/nus_logo_full-vertical.png",
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
                    Text(
                      'Title',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                          child: const Text('Submit'),
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
