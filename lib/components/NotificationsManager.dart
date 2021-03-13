import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/ChatScreen.dart';
import 'package:dabao_together/Screens/Welcome.dart';
import 'package:dabao_together/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;

class NotificationsManager {
  BuildContext context;
  NotificationsManager(this.context);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String pushNotificationId;
  String pushNotificationUsername;
  String pushNotificationVendor;
  String currentUserId;
  String currentUserName;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        currentUserId = user.uid;
        currentUserName = user.displayName;
      }
    } catch (e) {
      print(e);
    }
  }

  void registerNotification() {
    getCurrentUser();
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');

      if (Platform.isIOS){
pushNotificationId = message['idFrom'];
        pushNotificationUsername = message['userFrom'];
        pushNotificationVendor = message['vendor'];
        }
      else{
        pushNotificationId = message['data']['idFrom'];
        pushNotificationUsername = message['data']['userFrom'];
        pushNotificationVendor = message['data']['vendor'];
      }


      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['notification']);

      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      if (_auth.currentUser != null) {
        _navigateToChatScreen(message);
      } else {
        _navigateToWelcomeScreen();
      }
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      if (_auth.currentUser != null) {
        _navigateToChatScreen(message);
      } else {
        _navigateToWelcomeScreen();
      }

      return;
    });

    // firebaseMessaging.getToken().then((token) {
    //   FirebaseFirestore.instance
    //       .collection('usgers')
    //       .doc(currentUserId)
    //       .update({'pushToken': token});
    // }).catchError((err) {
    //   Fluttertoast.showToast(msg: err.message.toString());
    // });
  }

  void _navigateToChatScreen(Map<String, dynamic> message) async {
    // Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    // await Navigator.of(context).push(PageRouteBuilder(
    //     opaque: false, pageBuilder: (context, _, __) => NewPage();
    if (Platform.isIOS){
      pushNotificationId = message['idFrom'];
      pushNotificationUsername = message['userFrom'];
      pushNotificationVendor = message['vendor'];
    }
    else{
      pushNotificationId = message['data']['idFrom'];
      pushNotificationUsername = message['data']['userFrom'];
      pushNotificationVendor = message['data']['vendor'];
    }
    navigatorKey.currentState.pushNamed(
      Chat.id,
      arguments: <String, String>{
        'requestorName': pushNotificationUsername,
        'requestorId': pushNotificationId,
        'vendor': pushNotificationVendor,
      },
    );
  }

  void _navigateToWelcomeScreen() async {
    navigatorKey.currentState
        .pushNamedAndRemoveUntil(WelcomeScreen.id, (_) => false);
  }

  void configLocalNotification() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      if (pushNotificationId != null) {
        if (_auth.currentUser != null) {
          navigatorKey.currentState.pushNamed(
            Chat.id,
            arguments: <String, String>{
              'requestorName': pushNotificationUsername,
              'requestorId': pushNotificationId,
              'vendor': pushNotificationVendor,
            },
          );
        } else {
          navigatorKey.currentState.pushNamed(
            WelcomeScreen.id,
          );
        }
      }
    }

    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  void showNotification(message) async {

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        // Platform.isAndroid ? 'com.dabaotogether' : 'com.duytq.flutterchatdemo',
        'com.dabaotogether',
        'Dabao Together',
        'Dabao Together',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high,
        icon: "notification_icon");
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  void removeAllNotificationsFromTray() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void unregisterNotification() {
    // firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
  }

  Future<bool> onBackPress() {
    // openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: themeColor,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }
}
