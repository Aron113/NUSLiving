import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/screens/loginScreens/verifyemail.dart';
import 'package:flutter_application_1/utilities/constants.dart';
import 'package:flutter_application_1/screens/loginScreens/login.dart';
import 'package:flutter_application_1/screens/loginScreens/forgotpassword.dart';

class SignUp extends StatefulWidget {
    @override
    SignUpScreen createState() => SignUpScreen();
}

class SignUpScreen extends State<SignUp> {
  final TextEditingController _nameText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final TextEditingController _repeatpasswordText = TextEditingController();
  final GlobalKey<FormState> _passwordForm = GlobalKey<FormState>();

  Widget _name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: TextFormField(
            controller: _nameText,
            validator: (String? validator) {
              if (validator!.isEmpty) return '              *Empty Field';
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
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your Name',
              hintStyle: kHintTextStyle,
              helperText: ' '
            ),
          ),
        ),
      ],
    );
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
              if (validator != null) {
                if (!EmailValidator.validate(validator)) {
                  return '              *Enter a Valid Email Address';
                }
              }
              /*if (validator != null) {
                if (Check that email has not been registered) {
                  return '              *Email Address has already been registered';
                }
              }*/
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
              if (validator.length < 8 ) return '              *Password needs to be at least 8 characters';
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
              helperText: ' '
            ),
          ),
        ),
      ],
    );
  }

  Widget _repeatpassword () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: TextFormField(
            controller: _repeatpasswordText,
            validator: (String? validator) {
              if (validator!.isEmpty) return '              *Empty Field';
              if (validator.compareTo(_passwordText.text) != 0) return '              *The passwords do not match';
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
              hintText: 'Re-enter your Password',
              hintStyle: kHintTextStyle,
              helperText: ' '
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
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
                {print('SignUp Button Pressed'),
                register(),
                },
        child: Text(
          'REGISTER',
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

  void register() {
    //check all the stuff first
    if(_passwordForm.currentState != null) {
       _passwordForm.currentState!.validate();
    }
    if (_passwordForm.currentState!.validate() == true) {
      //Can proceed to create account in backend
      //pass variable of successful account creation and to login again, sth like 'Account creation successful'
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  VerifyEmail(emailtext:_emailText.text)));
    }
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: () => {
            signin()
            },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
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

  void signin() {
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
                      SizedBox(height: 30.0,),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.0),
                      Form(
                        key: _passwordForm,
                        child: Column(children: <Widget>[
                          _name(),
                          SizedBox(height: 10.0,),
                          _email(),
                          SizedBox(height: 10.0,),
                          _password(),
                          SizedBox(height: 10.0,),
                          _repeatpassword(),
                          _buildRegisterBtn(),
                        ]
                      )
                      ),
                      _buildSignInBtn()
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
