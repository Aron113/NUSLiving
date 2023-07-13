import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

//models
import '../models/task.dart';
import '../models/user.dart';
//widgets
import 'package:NUSLiving/screens/loginScreens/login.dart';
import 'package:NUSLiving/widgets/my_tasks.dart';
import 'package:NUSLiving/widgets/home_banner.dart';
import 'package:NUSLiving/utilities/navDrawer.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.uid, required this.tasks});
  final String uid;
  List<Task> tasks;

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  var currState = "Created";
  late List<Task> tasks;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tasks = widget.tasks;
  }

  void displayCreated() async {
    var retrievedTasks = await MyFunctions.getUserTasks(widget.uid);
    setState(() {
      tasks = retrievedTasks;
      currState = 'Created';
    });
  }

  void displayFavourites() async {
    var retrievedTasks = await MyFunctions.getFavouriteTasks(widget.uid);
    setState(() {
      tasks = retrievedTasks;
      currState = 'Favourites';
    });
  }

  void displayApplied() async {
    var retrievedTasks = await MyFunctions.getAppliedTasks(widget.uid);
    setState(() {
      tasks = retrievedTasks;
      currState = 'Applied';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(uid: widget.uid),
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
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeBanner(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: currState == 'Created'
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSecondary),
                      onPressed: displayCreated,
                      child: const Text(
                        'Created',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: currState == 'Favourites'
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSecondary),
                      onPressed: displayFavourites,
                      child: const Text(
                        'Favourites',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: currState == 'Applied'
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSecondary),
                      onPressed: displayApplied,
                      child: const Text(
                        'Applied',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  MyTasks(uid: widget.uid, allTasks: tasks, type: currState),
                  const SizedBox(height: 10),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
