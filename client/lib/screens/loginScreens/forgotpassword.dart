import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:NUSLiving/utilities/constants.dart';
import 'package:NUSLiving/screens//loginScreens/login.dart';

//Firebase
import 'package:NUSLiving/authentication/authentication.dart';
import 'package:NUSLiving/authentication/authentication_exceptions.dart';

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordScreen createState() => ForgotPasswordScreen();
}

class ForgotPasswordScreen extends State<ForgotPassword> {
  final TextEditingController _emailText = TextEditingController();
  final GlobalKey<FormState> _Form = GlobalKey<FormState>();
  bool _passwordResetEmailNotifVisibility = false;
  String _validEmailText = '';
  bool _emailnotregisteredNotif = false;
  final _authService = AuthenticationService();

  @override
  void dispose() {
    _emailText.dispose();
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
        SizedBox(height: 10.0),
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
              if (_emailnotregisteredNotif) {
                return '              *Email is not registered';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 16.0),
              prefixIcon: Icon(
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

  Widget _resetpasswordbutton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: const Color.fromARGB(255, 00, 130, 128),
        ),
        onPressed: () => {
          print('Reset Password Button Pressed'),
          resetPassword(),
        },
        child: const Text(
          'RESET PASSWORD',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void resetPassword() async {
    _emailnotregisteredNotif = false;
    _passwordResetEmailNotifVisibility = false;
    if (_Form.currentState!.validate() == true) {
      //Send password reset email
      final _status = await _authService.resetPassword(email: _emailText.text);
      if (_status == AuthStatus.successful) {
        setState(() {
          //Show password reset email pop up
          _validEmailText = _emailText.text;
          _passwordResetEmailNotifVisibility = true;
        });
      } else {
        //Email is not registered
        _emailnotregisteredNotif = true;
      }
    }
    _Form.currentState!.validate();
    setState(() {});
  }

  Widget _backToLoginBtn() {
    return GestureDetector(
      onTap: () => {
        print('Back to Login Button Pressed'),
        backToLogin(),
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Back to ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white,
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('NUSLiving',
                          style: TextStyle(
                            color: Color.fromARGB(255, 00, 130, 128),
                            fontFamily: 'OpenSans',
                            fontSize: 32.0,
                            fontWeight: FontWeight.normal,
                          )),
                      Form(
                        key: _Form,
                        child: Column(children: <Widget>[
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            'Forgot Your Password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            'Enter your email address below to reset your password',
                            style: TextStyle(
                              color: Color.fromARGB(255, 00, 130, 128),
                              fontFamily: 'OpenSans',
                              fontSize: 11.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          _email(),
                          _resetpasswordbutton(),
                        ]),
                      ),
                      SizedBox(
                        height: 100,
                        child: Visibility(
                          visible: _passwordResetEmailNotifVisibility,
                          child: Text(
                              'An email has been sent to ${_validEmailText} with instructions for resetting your password.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 221, 221, 221),
                                fontFamily: 'OpenSans',
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 155.0,
                      ),
                      _backToLoginBtn(),
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
