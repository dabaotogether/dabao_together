import 'package:dabao_together/components/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance;

class WhoAreWeScreen extends StatelessWidget {
  static const String id = 'who_are_we_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text('Who Are We?')),
          drawer: AppDrawer(
            username: _auth.currentUser.displayName == null
                ? 'Error'
                : _auth.currentUser.displayName,
            selectedIndex: 3,
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(height: 50),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'You might wonder who we are? Or you might not.',
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
                          'Either way, since you are here, we really hope you will enjoy the Dabao Together experience. Please like our Dabao Together Facebook Page and your feedback/suggestions are most welcome. Thank you!',
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
