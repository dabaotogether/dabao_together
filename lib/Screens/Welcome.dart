import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:dabao_together/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'register.dart';

final _auth = FirebaseAuth.instance;

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('images/dabao_together_logo_only.png'),
                height: 250.0,
                padding: EdgeInsets.only(bottom: 20),
              ),
            ),
            Center(
              child: TyperAnimatedTextKit(
                // duration: Duration(milliseconds: 8000),
                text: ["Dabao Together", "Ai Mai?"],
                textStyle: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            // RoundedButton(
            //   title: 'Log In',
            //   colour: Colors.black87,
            //   onPressed: () {
            //     Navigator.pushNamed(context, LoginScreen.id);
            //   },
            // ),
            RoundedButton(
              title: 'Let\'s Go',
              colour: Colors.black87,
              onPressed: () {
                if (_auth.currentUser != null) {
                  if (_auth.currentUser.displayName != null) {
                    // Navigator.pushNamed(context, MainActivityContainer.id);
                    Navigator.pushNamed(context, HomeNavScreen.id);
                  } else {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  }
                } else {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
