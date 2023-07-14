import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NUSLiving/utilities/constants.dart';
import 'package:NUSLiving/screens/loginScreens/login.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key, required this.emailtext}) : super(key: key);
  final String emailtext;

  @override
  VerifyEmailScreen createState() => VerifyEmailScreen();
}

class VerifyEmailScreen extends State<VerifyEmail> {
  Widget _backToLoginBtn() {
    return GestureDetector(
      onTap: () => {
        print('Back to Login Button Pressed'),
        backToLogin(),
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Back to ',
              style: TextStyle(
                color: Color.fromARGB(255, 00, 130, 128),
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Color.fromARGB(255, 00, 130, 128),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void backToLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Login())); //Go to Login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 90.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 50.00,
                      ),
                      const Text('NUSLiving',
                          style: TextStyle(
                            color: Color.fromARGB(255, 00, 130, 128),
                            fontFamily: 'OpenSans',
                            fontSize: 32.0,
                            fontWeight: FontWeight.normal,
                          )),
                      const Image(
                        image: AssetImage('assets/images/greentick.gif'),
                        height: 300.00,
                      ),
                      const Text(
                        'Registration Successful',
                        style: TextStyle(
                          color: Color.fromARGB(255, 00, 130, 128),
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                          'Your account was successfully registered. We have sent an email to ${widget.emailtext} to verify your email address. After you have verified your email, simply login to begin using NUSLiving! ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 00, 130, 128),
                            fontFamily: 'OpenSans',
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          )),
                      const SizedBox(height: 80),
                      _backToLoginBtn()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
