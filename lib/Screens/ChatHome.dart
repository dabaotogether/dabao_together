import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/ChatScreen.dart';
import 'package:dabao_together/components/NotificationsManager.dart';
import 'package:dabao_together/components/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Color primaryColor = Colors.black87;
final Color greyColor = Colors.black26;
final Color greyColor2 = Colors.black12;
final Color themeColor = Colors.black87;
final _auth = FirebaseAuth.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;

class ChatHomeScreen extends StatefulWidget {
  // final String currentUserId;
  static const String id = 'chat_home';
  ChatHomeScreen({Key key}) : super(key: key);

  @override
  State createState() => ChatHomeScreenState();
}

class ChatHomeScreenState extends State<ChatHomeScreen> {
  ChatHomeScreenState({Key key});

  // final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String currentUserId;
  String currentUserName;
  bool isLoading = false;
  int _selectedIndex = 2;
  String pushNotificationId;
  String pushNotificationUsername;
  String pushNotificationVendor;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    NotificationsManager newManager = NotificationsManager(context);
    newManager.configLocalNotification();
    newManager.registerNotification();
    // registerNotification();
    // configLocalNotification();
  }

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
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      pushNotificationId = message['data']['idFrom'];
      pushNotificationUsername = message['data']['userFrom'];
      pushNotificationVendor = message['data']['vendor'];
      print('idFrom: $pushNotificationId');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
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
    await flutterLocalNotificationsPlugin.cancelAll();
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
    print('payload : $payload');
    // print('payload : $payload');
    if (payload != null) {
      debugPrint('notification payload: $payload');
      Navigator.pushNamed(
        context,
        Chat.id,
        arguments: <String, String>{
          'requestorName': pushNotificationUsername,
          'requestorId': pushNotificationId,
          'vendor': pushNotificationVendor,
        },
      );
    }

    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dabao_together' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'Chat History (Most recent 15)',
        ),
      ),
      drawer: AppDrawer(
        username: currentUserName,
        selectedIndex: 1,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.emoji_people_rounded),
      //       label: 'Find Kakis',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_activity_rounded),
      //       label: 'My Requests',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat_rounded),
      //       label: 'Chats',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream:
                    // FirebaseFirestore.instance.collection('users').snapshots(),
                    firestoreInstance
                        .collection('users')
                        .doc(currentUserId)
                        .collection('active_chat')
                        .where('deleted', isEqualTo: 0)
                        .limit(15)
                        .orderBy('created_time', descending: true)
                        // .limit(2)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      margin: EdgeInsets.all(15.0),
                      child: Center(
                        child: TyperAnimatedTextKit(
                          isRepeatingAnimation: false,
                          // duration: Duration(milliseconds: 8000),
                          text: [
                            "No chat history. Please continue to jio! Thanks!"
                          ],
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      // itemBuilder: (context, index) =>
                      //     buildItem(context, snapshot.data.documents[index]),
                      // itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ),
        // onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    String peerId = document.id;
    String peerName = document.get('username');
    String vendor = 'NA';

    try {
      if (document.get('vendor') != null) {
        vendor = document.get('vendor');
      }
    } catch (e) {
      vendor = 'NA';
      print('HERE HOR');
      print(e);
    }

    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: Icon(
                Icons.account_circle,
                size: 50.0,
                color: greyColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '$peerName',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Material(
                elevation: 5.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                child: MaterialButton(
                  onPressed: () {
                    firestoreInstance
                        .collection('users')
                        .doc(currentUserId)
                        .collection('active_chat')
                        .doc(peerId)
                        .update({
                      'deleted': 1,
                    }).then((_) {
                      Flushbar(
                        title: "Hey " + _auth.currentUser.displayName,
                        message: "The chat history with " +
                            peerName +
                            " has been deleted!",
                        duration: Duration(seconds: 3),
                      )..show(context);
                      print('update request to firestore done!');
                    });
                  },
                  // minWidth: 80.0,
                  height: 25.0,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            Chat.id,
            arguments: <String, String>{
              'requestorName': peerName,
              'requestorId': peerId,
              'vendor': vendor,
            },
          );
        },
        onLongPress: () {},
        color: Colors.black87,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}
