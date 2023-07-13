import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

//Firebase
import 'package:NUSLiving/authentication/authentication.dart';
import 'package:NUSLiving/authentication/authentication_exceptions.dart';

//widgets
import 'package:NUSLiving/utilities/constants.dart';
import 'package:NUSLiving/screens/loginScreens/signup.dart';
import 'package:NUSLiving/screens/loginScreens/forgotpassword.dart';
import 'package:NUSLiving/screens/home.dart';
import 'package:NUSLiving/models/task.dart';
import 'package:NUSLiving/screens/user_screens/createAnAccount.dart';
import 'package:NUSLiving/utilities/myFunctions.dart';

class Login extends StatefulWidget {
  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<Login> {
  String _notifText = '';
  bool _notifTextVisibility = false;
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _authService = AuthenticationService();

  @override
  void dispose() {
    _emailText.dispose();
    _passwordText.dispose();
    super.dispose();
  }

  Widget _email() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: TextFormField(
            controller: _emailText,
            validator: (String? validator) {
              if (validator!.isEmpty) return '              *Empty Field';
              if (!EmailValidator.validate(validator)) {
                return '              *Enter a Valid Email Address';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 16.0),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
              helperText: ' ',
            ),
          ),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: TextFormField(
            controller: _passwordText,
            validator: (String? validator) {
              if (validator!.isEmpty) return '              *Empty Field';
              return null;
            },
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 16.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
              helperText: ' ',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => forgotpassword(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(right: 0.0),
        ),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  void forgotpassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: const Color.fromARGB(255, 00, 130, 128),
        ),
        onPressed: () => login(),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void login() async {
    setState(() {
      _notifTextVisibility = false;
    });
    if (_form.currentState!.validate() == true) {
      //Validate that form to check for empty fields and valid email
      final authResult = await _authService.login(
        email: _emailText.text.trim(),
        password: _passwordText.text,
      );
      if (authResult.status == AuthStatus.emailNotVerified) {
        setState(() {
          //Display notif that email address is not verified
          _notifText =
              'Email Address is not verified. We have re-sent a verification link to your email address.';
          _notifTextVisibility = true;
        });
        //Resend email verification to user's email address
        _authService.resendVerificationEmail(
          email: _emailText.text.trim(),
          password: _passwordText.text,
        );
      } else if (authResult.status != AuthStatus.successful) {
        setState(() {
          //Display notif if Login fails
          _notifText = 'Failed to Login. Incorrect Email Address or Password.';
          _notifTextVisibility = true;
        });
      } else {
        //Login successful, go to Home page
        bool userPresent = await MyFunctions.getUserPresent(authResult.uid);
        if (userPresent) {
          var tasks = await MyFunctions.getUserTasks(authResult.uid);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                uid: authResult.uid,
                tasks: tasks,
              ),
            ),
          );
        } else {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAnAccountScreen(
                uid: authResult.uid,
              ),
            ),
          );
        }
      }
    }
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => {
        signup(),
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account?  ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signup() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignUp())); //Go to SignUp page
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text('NUSLiving',
                          style: TextStyle(
                            color: Color.fromARGB(255, 00, 130, 128),
                            fontFamily: 'OpenSans',
                            fontSize: 32.0,
                            fontWeight: FontWeight.normal,
                          )),
                      Form(
                        key: _form,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 30.0,
                            ),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color.fromARGB(255, 54, 117, 136),
                                fontFamily: 'OpenSans',
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 1.0),
                            _email(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _password(),
                            const SizedBox(
                              height: 1.0,
                            ),
                            _buildForgotPasswordBtn(),
                            _buildLoginBtn(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _notifTextVisibility
                                ? SizedBox(
                                    height: 100,
                                    child: Visibility(
                                      visible: _notifTextVisibility,
                                      child: Text(
                                        _notifText,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(height: 100)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      _buildSignupBtn(),
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
