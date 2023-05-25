import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/utilities/constants.dart';
import 'package:flutter_application_1/screens/loginScreens/signup.dart';
import 'package:flutter_application_1/screens/loginScreens/forgotpassword.dart';
import 'package:flutter_application_1/screens/home.dart';

//Firebase
import 'package:flutter_application_1/authentication/authentication.dart';
import 'package:flutter_application_1/authentication/authenticationexceptions.dart';

class Login extends StatefulWidget {
    @override
    LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<Login> {
  String _notifText = '';
  bool _notifTextVisibility = false;
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final GlobalKey<FormState> _Form = GlobalKey<FormState>();
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
              return null;
            },
              keyboardType: TextInputType.emailAddress,
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

    Widget _password() {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
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
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 16.0),
              prefixIcon: Icon(
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
        onPressed: () => {print('Forgot Password Button Pressed'),
                          forgotpassword(),
                         },
        style: TextButton.styleFrom(
                    padding: EdgeInsets.only(right: 0.0),),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  void forgotpassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  ForgotPassword()));
  }

    Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
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
                {print('Login Button Pressed'),
                 login(),
                },
            
        child: Text(
          'LOGIN',
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

  void login() async {
    setState(() {
      _notifTextVisibility = false;
    });
    if (_Form.currentState!.validate() == true) { //Validate that form to check for empty fields and valid email 
      final _status = await _authService.login(
        email: _emailText.text.trim(),
        password: _passwordText.text,
      );
      if (_status == AuthStatus.emailNotVerified) {
        setState(() { //Display notif that email address is not verified
          _notifText = 'Email Address is not verified. We have re-sent a verification link to your email address.';
          _notifTextVisibility = true;
        });
        //Resend email verification to user's email address
        _authService.resendVerificationEmail(
          email: _emailText.text.trim(),
          password: _passwordText.text, 
        );
      }
      else if (_status != AuthStatus.successful) {
        setState(() { //Display notif if Login fails
            _notifText = 'Failed to Login. Incorrect Email Address or Password.';
            _notifTextVisibility = true;
        }); 
      } else {
          //Login successful, go to Home page
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  Home()));
      }
    }
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => {
            print('Sign Up Button Pressed'),
            signup(),
            },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
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

  void signup() {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignUp())); //Go to SignUp page
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
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 1.0),
                                      _email(),
                                      SizedBox(height: 10.0,),
                                      _password(),
                                      SizedBox(height: 1.0,),
                                      _buildForgotPasswordBtn(),
                                      _buildLoginBtn(),
                                      SizedBox(height: 10.0,),
                                      Container(height: 80,
                                        child: Visibility(child: Text('${_notifText}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle (
                                                    color: Color.fromARGB(255, 221, 221, 221),
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.normal,
                                                )
                                              ,),
                                          visible: _notifTextVisibility,
                                          ),
                                      ),
                                    ]
                                   ),
                      ),
                      SizedBox(height: 90.0,),
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