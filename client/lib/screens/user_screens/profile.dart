import 'dart:ffi';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:NUSLiving/screens/home.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  final User user;

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _telegramHandle;
  late int _yearOfStudy;
  late String _house;
  late String _bio;
  late List<String> _interests;
  late List<String> _remainingInterests;
  final List<String> _allInterests = [
    "Floorball",
    "Volleyball",
    "Football",
    "Ulti",
    "Basketball",
    "Dance",
    "Coffee",
    "Cooking",
    "Band",
    "Art",
    "Theatre"
  ];

  @override
  void initState() {
    // TODO: implement initState
    _interests = widget.user.interests;
    _remainingInterests = _allInterests
        .where((element) => !_interests.contains(element))
        .toList();
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var _createdTasks = [];
      var _appliedTasks = [];
      var _favouriteTasks = [];
      for (Task task in widget.user.createdTasks) {
        _createdTasks.add(task.id);
      }
      for (Task task in widget.user.appliedTasks) {
        _createdTasks.add(task.id);
      }
      for (Task task in widget.user.favouriteTasks) {
        _favouriteTasks.add(task.id);
      }
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      var res = await http.patch(
        Uri.parse('http://10.0.2.2:3000/api/v1/user/uid/${widget.user.uid}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "username": _username,
          "uid": widget.user.uid,
          "telegramHandle": _telegramHandle,
          "year": _yearOfStudy,
          "house": _house,
          "createdTasks": _createdTasks,
          "appliedTasks": _appliedTasks,
          "favouriteTasks": _favouriteTasks,
          "bio": _bio,
          "interests": _interests,
        }),
      );
      if (res.statusCode == 200) {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Successfully updated profile'),
        ));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('error : $res.message')),
          );
        }
      }
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
                      'Username',
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
                      initialValue: widget.user.username,
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
                          return 'Must be between 5 and 20 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                    Text(
                      'Telegram Handle',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: widget.user.telegramHandle,
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
                            value.trim().length > 50) {
                          return 'Must be between 1 and 50 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _telegramHandle = value!;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Year of Study',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                value: widget.user.year,
                                padding: const EdgeInsets.all(5),
                                items: [
                                  for (int i = 1; i < 5; i++)
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(
                                        '$i',
                                      ),
                                    ),
                                ],
                                onChanged: (val) {},
                                onSaved: (value) {
                                  _yearOfStudy = value!;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'House',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                value: widget.user.house,
                                padding: const EdgeInsets.all(5),
                                items: [
                                  for (final house in [
                                    "aquila",
                                    "noctua",
                                    "ursa",
                                    "leo",
                                    "draco"
                                  ])
                                    DropdownMenuItem(
                                      value: house,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 5),
                                          Text(house),
                                        ],
                                      ),
                                    ),
                                ],
                                onChanged: (value) {},
                                onSaved: (value) {
                                  _house = value!;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bio',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          minLines: 2,
                          maxLines: 3,
                          initialValue: widget.user.bio,
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
                                value.trim().length > 200) {
                              return 'Must be between 1 and 200 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _bio = value!;
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Interests',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        MultiSelectChipDisplay(
                          chipColor: Colors.green.withOpacity(0.45),
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black),
                          items: _interests
                              .map((e) => MultiSelectItem(e, e))
                              .toList(),
                          onTap: (value) {
                            setState(() {
                              _interests.remove(value);
                              _remainingInterests.add(value);
                            });
                          },
                        ),
                        MultiSelectChipDisplay(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black),
                          items: _remainingInterests
                              .map((e) => MultiSelectItem(e, e))
                              .toList(),
                          onTap: (value) {
                            setState(() {
                              _interests.add(value);
                              _remainingInterests.remove(value);
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Reset'),
                        ),
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
                          child: const Text('Save changes'),
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
