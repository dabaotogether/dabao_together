import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:dabao_together/Screens/IntroScreen.dart';
import 'package:dabao_together/Screens/TncScreen.dart';
import 'package:dabao_together/components/rounded_button.dart';
import 'package:dabao_together/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;

class EnterUserName extends StatefulWidget {
  static const String id = 'enter_username_screen';
  @override
  _EnterUserNameState createState() => _EnterUserNameState();
}

class _EnterUserNameState extends State<EnterUserName> {
  String userName;
  String tokenId;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30),
            Expanded(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 250.0,
                  child: Image.asset('images/dabao_together_logo_only.png'),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Hi there! Glad to have you onboard!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Please enter your display user name'),
              onChanged: (value) {
                userName = value;
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.black87,
              onPressed: () async {
                if (isChecked) {
                  if (userName.length > 2) {
                    commitUsernameAndToken(userName);
                  } else {
                    Flushbar(
                      title: "Hey",
                      message:
                          "Please enter a display name which is at least 3 characters long.",
                      duration: Duration(seconds: 1),
                    )..show(context);
                  }
                } else {
                  Flushbar(
                    title: "Hey",
                    message:
                        "Please read and agree to the terms & conditions and privacy policy! Thanks!",
                    duration: Duration(seconds: 1),
                  )..show(context);
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 50,
                    child: Checkbox(
                      // controlAffinity: ListTileControlAffinity.leading,
                      value: isChecked,
                      onChanged: (bool) {
                        setState(() {
                          isChecked = bool;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'I have read and agreed to the ',
                            style: TextStyle(color: Colors.black87)),
                        TextSpan(
                            text: 'terms & conditions and privacy policy',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, TncScreen.id);
                              }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _firebaseMessaging.getToken().then((token) {
      tokenId = token;
    });
    FirebaseMessaging().onTokenRefresh.listen((newToken) {
      // Save newToken
      updateToken(newToken);
    });
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void updateToken(String newTokenId) async {
    try {
      User user = _auth.currentUser;
      // UserUpdateInfo updateInfo = UserUpdateInfo();
      // updateInfo.displayName = userName;
      // await user.updateProfile(displayName: userName);
      // await user.reload();
      user = _auth.currentUser;

      firestoreInstance.collection("users").doc(user.uid).update({
        "token_id": newTokenId,
      }).then((_) {
        print('saving to firestore done!');
      });
      if (user.displayName != null)
        Navigator.pushNamedAndRemoveUntil(
            context, HomeNavScreen.id, (_) => false);
    } catch (e) {
      print(e);
    }
  }

  void commitUsernameAndToken(String userName) async {
    try {
      User user = _auth.currentUser;
      // UserUpdateInfo updateInfo = UserUpdateInfo();
      // updateInfo.displayName = userName;
      await user.updateProfile(displayName: userName);
      await user.reload();
      user = _auth.currentUser;
      print(user.displayName);

      firestoreInstance.collection("users").doc(user.uid).set({
        "username": user.displayName,
        "user_id": user.uid,
        "token_id": tokenId,
      }).then((_) {
        print('saving to firestore done!');
      });
      if (user.displayName != null)
        Navigator.pushNamedAndRemoveUntil(
            context, IntroScreen.id, (_) => false);
    } catch (e) {
      print(e);
    }
  }
}
