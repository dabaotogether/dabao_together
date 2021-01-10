import 'package:dabao_together/components/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                child: SelectableText.rich(
                  TextSpan(
                      text:
                          'If you have any enquries/feedback, please feel free to drop an email to heyoz@dabaotogether.com',
                      style: TextStyle(color: Colors.black87)),
                ),
              ),
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.all(20),
                child: SelectableText.rich(
                  TextSpan(
                      text:
                          'Do forgive us if we took a long time to respond as this is our part-time project. Thanks!',
                      style: TextStyle(color: Colors.black87)),
                ),
              ),
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
  }
}
