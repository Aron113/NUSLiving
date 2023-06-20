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

class Home extends StatefulWidget {
  const Home({super.key, required this.uid, required this.myTasks});
  final String uid;
  final List<Task> myTasks;

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(uid: widget.uid),
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
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            const HomeBanner(),
            MyTasks(allTasks: widget.myTasks),
          ],
        ),
      ),
    );
  }
}
