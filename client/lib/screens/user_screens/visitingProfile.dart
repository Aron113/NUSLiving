import 'package:flutter/material.dart';

import 'dart:ffi';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:NUSLiving/screens/home.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';

class VisitingProfileScreen extends StatelessWidget {
  VisitingProfileScreen({super.key, required this.user});

  final User user;
  @override
  Widget build(context) {
    return Scaffold(
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
        color: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user.username,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary)),
                  Text('House: ${user.house}'),
                ],
              ),
              const SizedBox(height: 10),
              Text('Bio : ${user.bio}',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              Text('Tele Handle : ${user.telegramHandle}',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    Text('Interests : ',
                        style: Theme.of(context).textTheme.bodyLarge),
                    for (String interest in user.interests)
                      Text(interest,
                          style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
