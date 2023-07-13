import 'package:NUSLiving/models/task.dart';
import 'package:flutter/material.dart';
import 'package:NUSLiving/screens/loginScreens/signup.dart';
import 'package:NUSLiving/screens/loginScreens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:NUSLiving/screens/home.dart';
//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:NUSLiving/screens/tasks_screens/tasks.dart';
import 'package:NUSLiving/screens/tasks_screens/task_details_page.dart';
import 'package:NUSLiving/screens/user_screens/createAnAccount.dart';

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
        scaffoldBackgroundColor: const Color.fromARGB(225, 251, 252, 250),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 213, 47, 47),
          onPrimary: const Color.fromARGB(255, 00, 130, 128),
          onSecondary: const Color.fromARGB(255, 54, 117, 136),
          background: Colors.white,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
