import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/loginScreens/signup.dart';
import 'package:flutter_application_1/screens/loginScreens/login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NUSLiving',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 213, 47, 47)),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}


