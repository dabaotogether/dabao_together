import 'package:dabao_together/Screens/Enter_OTP.dart';
import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:dabao_together/components/rounded_button.dart';
import 'package:dabao_together/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class ScreenArguments {
  final String verificationID;
  final String phoneNumber;

  ScreenArguments(this.verificationID, this.phoneNumber);
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  // final _credential =
  bool showSpinner = false;
  String userName;
  String phoneNumber;

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
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 300.0,
                  child: Image.asset('images/dabao_together_logo_only.png'),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              // obscureText: true,
              controller: _phoneController,
              textAlign: TextAlign.center,
              onChanged: (value) {
                phoneNumber = '+65' + value;
              },

              keyboardType: TextInputType.phone,
              decoration: kTextFieldDecoration.copyWith(
                  prefixText: '+65', hintText: 'Enter your SG phone number'),
            ),
            RoundedButton(
              title: 'Register/Login',
              colour: Colors.black87,
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  _auth.verifyPhoneNumber(
                    phoneNumber: phoneNumber,
                    timeout: Duration(seconds: 60),
                    verificationCompleted:
                        (AuthCredential authCredential) async {
                      _auth
                          .signInWithCredential(authCredential)
                          .then((UserCredential result) {
                        print('verification completed');
                        Navigator.pushNamed(context, HomeNavScreen.id);
                      }).catchError((e) {
                        Flushbar(
                          title: "Hey",
                          message:
                              "Please make sure the SG phone number is valid and try again.",
                          duration: Duration(seconds: 1),
                        )..show(context);
                        print(e);
                      });
                    },
                    verificationFailed: (FirebaseAuthException authException) {
                      Flushbar(
                        title: "Hey",
                        message:
                            "Please make sure the 8-digit SG phone number is valid and try again.",
                        duration: Duration(seconds: 2),
                      )..show(context);
                      print(authException.message);
                    },
                    codeSent: (String verificationId,
                        [int forceResendingToken]) async {
                      await Navigator.pushNamed(
                        context,
                        PinCodeVerificationScreen.id,
                        arguments: ScreenArguments(verificationId, phoneNumber),
                      );
                      //show dialog to take input from the user
                      // showDialog(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (context) => AlertDialog(
                      //           title: Text("Enter SMS Code"),
                      //           content: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: <Widget>[
                      //               TextField(
                      //                 controller: _codeController,
                      //               ),
                      //             ],
                      //           ),
                      //           actions: <Widget>[
                      //             FlatButton(
                      //               child: Text("Done"),
                      //               textColor: Colors.white,
                      //               color: Colors.redAccent,
                      //               onPressed: () {
                      //                 auth_PhoneNumber(
                      //                     verificationId, context);
                      //               },
                      //             )
                      //           ],
                      //         ));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      verificationId = verificationId;
                      print(verificationId);
                      print("Timeout");
                    },
                  );
                  // if (newUser != null) {
                  // Navigator.pushNamed(context, ChatScreen.id);
                  // }

                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
