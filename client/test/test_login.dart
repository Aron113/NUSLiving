import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:NUSLiving/main.dart';
import 'package:NUSLiving/screens/loginScreens/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './mock.dart';

void main() async {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Login', (tester) async {

    await tester.pumpWidget(Login());
    final titleFinder = find.text('LOGIN');
    final titleFinder2 = find.text('Sign In');
    
    TextEditingController _emailText = TextEditingController();
    _emailText.text = 'aron.andika11@gmail.com';
    TextEditingController _passwordText = TextEditingController();
    _passwordText.text = '12345678';
    String _notifText = '';
    bool _notifTextVisibility = false;

    expect(titleFinder, findsWidgets);
    expect(titleFinder2, findsWidgets);

  });
}

