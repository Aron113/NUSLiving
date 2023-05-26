import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NUSLiving/utilities/constants.dart';
import 'package:NUSLiving/screens/loginScreens/login.dart';


class Home extends StatefulWidget {
    @override
    HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {

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
