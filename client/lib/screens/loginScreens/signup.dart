import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NUSLiving/utilities/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:NUSLiving/screens/loginScreens/verifyemail.dart';
import 'package:NUSLiving/screens/loginScreens/login.dart';

//Firebase
import 'package:NUSLiving/authentication/authentication.dart';
import 'package:NUSLiving/authentication/authentication_exceptions.dart';

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
  final _authService = AuthenticationService();
  bool _statusNotifier =
      false; //Used as boolean for 'Email already in use' notif

  @override
  void dispose() {
    _nameText.dispose();
    _emailText.dispose();
    _passwordText.dispose();
    _repeatpasswordText.dispose();
    super.dispose();
  }

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
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 16.0),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter your Name',
                hintStyle: kHintTextStyle,
                helperText: ' '),
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
              if (!EmailValidator.validate(validator)) {
                return '              *Enter a Valid Email Address';
              }
              if (_statusNotifier) {
                return '              *Email Address has already been registered';
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
              contentPadding: EdgeInsets.only(top: 16.0),
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
              if (validator.length < 8)
                return '              *Password needs to be at least 8 characters';
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
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle,
                helperText: ' '),
          ),
        ),
      ],
    );
  }

  Widget _repeatpassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: TextFormField(
            controller: _repeatpasswordText,
            validator: (String? validator) {
              if (validator!.isEmpty) return '              *Empty Field';
              if (validator.compareTo(_passwordText.text) != 0) {
                return '              *The passwords do not match';
              }
              return null;
            },
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 16.0),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Re-enter your Password',
                hintStyle: kHintTextStyle,
                helperText: ' '),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
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
        onPressed: register,
        child: const Text(
          'REGISTER',
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

  void register() async {
    _statusNotifier = false;
    if (_passwordForm.currentState!.validate() == true) {
      //Proceed to create account
      final status = await _authService.createAccount(
        email: _emailText.text.trim(),
        password: _passwordText.text,
        name: _nameText.text,
      );
      if (status == AuthStatus.successful) {
        //pass variable of successful account creation and to login again, sth like 'Account creation successful'
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmail(emailtext: _emailText.text)));
      } else if (status == AuthStatus.emailAlreadyExists) {
        _statusNotifier = true;
      } else {
        //Error not due to email already existing
        _statusNotifier = false;
      }
    }
    _passwordForm.currentState!.validate();
    setState(() {});
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: () => {signin()},
      child: RichText(
        text: const TextSpan(
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
                      const Text('NUSLiving',
                          style: TextStyle(
                            color: Color.fromARGB(255, 00, 130, 128),
                            fontFamily: 'OpenSans',
                            fontSize: 32.0,
                            fontWeight: FontWeight.normal,
                          )),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1.0),
                      Form(
                          key: _passwordForm,
                          child: Column(children: <Widget>[
                            _name(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _email(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _password(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _repeatpassword(),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildRegisterBtn(),
                          ])),
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
