import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/ChatScreen.dart';
import 'package:dabao_together/components/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  Stream<QuerySnapshot> requestStream;
  @override
  void initState() {
    super.initState();
    requestStream = newStream();
    getCurrentUser();
    // NotificationsManager newManager = NotificationsManager(context);
    // newManager.configLocalNotification();
    // newManager.registerNotification();
    // registerNotification();
    // configLocalNotification();
  }

  Stream<QuerySnapshot> newStream() {
    try {
      Stream<QuerySnapshot> doc = firestoreInstance
          .collection('users')
          .doc(currentUserId)
          .collection('active_chat')
          .where('deleted', isEqualTo: 0)
          .limit(15)
          .orderBy('created_time', descending: true)
          // .limit(2)
          .snapshots();
      return doc;
    } catch (e) {
      print(e);
      Flushbar(
        title: "Hey",
        message:
            "There is a technical glitch, possibly due to internet connectivity. Please restart the app and try again.",
        duration: Duration(seconds: 3),
      )..show(context);
      return null;
    }
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
      body: Stack(
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

            // TODO: Delete chat function put on hold as unable to revert back if the peer reply
            // Padding(
            //   padding: const EdgeInsets.only(top: 5.0),
            //   child: Material(
            //     elevation: 5.0,
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20.0),
            //     child: MaterialButton(
            //       onPressed: () {
            //         firestoreInstance
            //             .collection('users')
            //             .doc(currentUserId)
            //             .collection('active_chat')
            //             .doc(peerId)
            //             .update({
            //           'deleted': 1,
            //         }).then((_) {
            //           Flushbar(
            //             title: "Hey " + _auth.currentUser.displayName,
            //             message: "The chat history with " +
            //                 peerName +
            //                 " has been deleted!",
            //             duration: Duration(seconds: 3),
            //           )..show(context);
            //           print('update request to firestore done!');
            //         });
            //       },
            //       // minWidth: 80.0,
            //       height: 25.0,
            //       child: Text(
            //         'Delete',
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
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
