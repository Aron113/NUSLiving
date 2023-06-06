import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NUSLiving/utilities/constants.dart';
import 'package:NUSLiving/screens/loginScreens/login.dart';
import 'package:NUSLiving/widgets/my_tasks.dart';
import 'package:NUSLiving/data/tasks.dart';
import 'package:NUSLiving/widgets/home_banner.dart';

class Home extends StatefulWidget {
  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              '/Users/zhengyu/Desktop/NUSLiving/assets/images/nus_logo_full-vertical.png',
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
        child: const Column(
          children: [
            HomeBanner(),
            MyTasks(allTasks: tasks),
          ],
        ),
      ),
    );
  }
}
