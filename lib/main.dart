import 'package:flutter/material.dart';
import 'package:NUSLiving/screens/loginScreens/signup.dart';
import 'package:NUSLiving/screens/loginScreens/login.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
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


