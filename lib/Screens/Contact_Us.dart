import 'package:dabao_together/components/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance;

class ContactUsScreen extends StatelessWidget {
  static const String id = 'contact_us_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text('Contact Us')),
          drawer: AppDrawer(
            username: _auth.currentUser.displayName == null
                ? 'Error'
                : _auth.currentUser.displayName,
            selectedIndex: 5,
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(height: 50),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Drop Us A Mail!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'If you have any enquries or feedback, please feel free to drop an email to ',
                          style: TextStyle(color: Colors.black87)),
                      TextSpan(
                          text: 'heyoz@dabaotogether.com',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL();
                            }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  _launchURL() async {
    Uri emailLaunchUri1 = Uri(
      scheme: 'mailto',
      path: 'heyoz@dabaotogether.com',
      queryParameters: {'subject': 'Feedback'},
    );

    print(emailLaunchUri1.toString());
  }
}
