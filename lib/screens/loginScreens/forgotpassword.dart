import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:NUSLiving/utilities/constants.dart';
import 'package:NUSLiving/screens//loginScreens/login.dart';

//Firebase
import 'package:NUSLiving/authentication/authentication.dart';
import 'package:NUSLiving/authentication/authenticationexceptions.dart';

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
                backgroundColor: Colors.white,
              ),
              onPressed: () => 
                {print('Reset Password Button Pressed'),
                resetPassword(),
                },
        child: Text(
          'RESET PASSWORD',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
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
      final _status = await _authService.resetPassword(
        email: _emailText.text
        );
      if (_status == AuthStatus.successful) {
        setState(() { //Show password reset email pop up
          _validEmailText = _emailText.text;
          _passwordResetEmailNotifVisibility = true;
        });
      }
      else { //Email is not registered
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
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login())); //Go to Login page
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 90.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage('assets/images/logo.png'), height: 50.00,),
                      Text(
                        'NUSLiving',
                        style: TextStyle(
                          color: Color.fromARGB(255, 204, 227, 236),
                          fontFamily: 'OpenSans',
                          fontSize: 32.0,
                          fontWeight: FontWeight.normal,
                        )
                      ),
                      Form(key: _Form,
                          child: Column(children: <Widget>[
                                      SizedBox(height: 30.0,),
                                      Text(
                                        'Forgot Your Password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        'Enter your email address below to reset your password',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 233, 233, 233),
                                          fontFamily: 'OpenSans',
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(height: 15.0),
                                      _email(),
                                      _resetpasswordbutton(), 
                                    ]
                                   ),
                      ),
                      Container(height: 100,
                        child: Visibility(child: Text('An email has been sent to ${_validEmailText} with instructions for resetting your password.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle (
                                      color: Color.fromARGB(255, 221, 221, 221),
                                      fontFamily: 'OpenSans',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                  )
                                ),
                                  visible: _passwordResetEmailNotifVisibility,
                            ),
                      ),
                      SizedBox(height: 155.0,),
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