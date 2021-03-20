import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:dabao_together/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
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
    // NotificationsManager newManager = NotificationsManager(context);
    // newManager.configLocalNotification();
    // newManager.registerNotification();
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
        padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              title: 'Let\'s Go',
              colour: Colors.black87,
              onPressed: () {
                if (_auth.currentUser != null) {
                  String requestorName = '';
                  String requestorId = '';
                  String requestVendor = '';

                  String phoneNumber = _auth.currentUser.phoneNumber;
                  _auth.currentUser.reload().then((value) {
                    if (_auth.currentUser.displayName != null) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeNavScreen.id, (_) => false);
                    } else {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    }
                  }).catchError((e) {
                    print(e);
                    if (e.toString().contains("user-disabled")) {
                      Flushbar(
                        title: "Hey",
                        message:
                            "Your account $phoneNumber has been disabled. Please contact us at heyoz@dabaotogether.com. Thank you.",
                        duration: Duration(seconds: 2),
                      )..show(context);
                    } else {
                      Flushbar(
                        title: "Hey",
                        message:
                            "There is a technical glitch, possibly due to internet connectivity. Please restart the app and try again.",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                  });
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
