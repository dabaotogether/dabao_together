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
          appBar: AppBar(title: Text('Ping Us')),
          drawer: AppDrawer(
            username: _auth.currentUser.displayName == null
                ? 'Error'
                : _auth.currentUser.displayName,
            selectedIndex: 4,
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
                          'If you have any enquries/feedback, please feel free to drop an email to heyoz@dabaotogether.com or drop by our Dabao Together Facebook page to talk to us. (Do not send us pigeon mail as our windows are usually close. Real windows, not Microsoft.)',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                      )),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.all(20),
                child: SelectableText.rich(
                  TextSpan(
                      text:
                          'We would really appreciate your feedback but do bear with us if we are taking a long time to respond as this is our part-time project. Thanks!',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                      )),
                  textAlign: TextAlign.justify,
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
