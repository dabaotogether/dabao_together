import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/Contact_Us.dart';
import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:dabao_together/Screens/My_Past_Requests.dart';
import 'package:dabao_together/Screens/Welcome.dart';
import 'package:dabao_together/Screens/Who_Are_We.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

bool isSwitched = true;

class AppDrawer extends StatefulWidget {
  final String username;
  final int selectedIndex;

  AppDrawer({Key key, @required this.username, @required this.selectedIndex})
      : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _setToggleNotification();
  }

  void _setToggleNotification() async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid);

    await docRef.get().then((data) {
      if (data.exists) {
        if (data.data()['notification_enabled'] != null) {
          print('hereR?');
          print(data.data()['notification_enabled']);
          isSwitched = data.data()['notification_enabled'];
          print(isSwitched);
        }
      }
    });
  }

  // String username;
  // int selectedIndex;
  // print (widget.username);

  // _AppDrawerState(username, selectedIndex);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 250,
        child: Drawer(
          child: Container(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: Container(
                //     width: 100,
                //     height: 100,
                //     // alignment: Alignment.centerLeft,
                //     decoration: BoxDecoration(
                //       color: Colors.black,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Image.asset('images/avatar.png'),
                //   ),
                // ),
                Center(
                  child: DrawerHeader(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          // alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset('images/avatar.png'),
                        ),
                        Text(
                          'Heyoz! ' + widget.username,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // Theme.of(context).primaryColorDark,
                        Colors.black87,
                        Colors.black,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        selected: widget.selectedIndex == 1,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.local_activity_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Jio Jio Page',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeNavScreen.id,
                            (_) => false,
                          );
                        },
                      ),
                      ListTile(
                        selected: widget.selectedIndex == 2,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.history_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Jio History',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            MyPastRequestsScreen.id,
                            (_) => false,
                          );
                        },
                      ),
                      ListTile(
                        selected: widget.selectedIndex == 3,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Who are we?',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, WhoAreWeScreen.id, (_) => false);
                        },
                      ),
                      ListTile(
                        selected: widget.selectedIndex == 4,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Ping Us',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer

                          Navigator.pushNamedAndRemoveUntil(
                              context, ContactUsScreen.id, (_) => false);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Toggle Notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .snapshots(),
                          initialData: null,
                          builder: (ctx, snap) {
                            return Switch(
                              value: snap.data == null
                                  ? false
                                  : snap.data["notification_enabled"],
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshSnap = await transaction
                                      .get(FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid));
                                  await transaction.update(freshSnap.reference,
                                      {"notification_enabled": value});
                                  if (!value) {
                                    Flushbar(
                                      title: "Heyo",
                                      message:
                                          "As the notification is turned off, do check the in-app messages regularly or indicate your phone number in the post.",
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }
                                });
                              },
                              inactiveTrackColor: Colors.redAccent,
                              activeTrackColor: Colors.greenAccent,
                              activeColor: Colors.white,
                            );
                          },
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          // Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 30, bottom: 30),
                        child: OutlineButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Logout',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                          onPressed: () async {
                            await _auth.signOut().whenComplete(() {
                              // NotificationsManager newManager =
                              //     NotificationsManager(context);
                              // newManager.unregisterNotification();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, WelcomeScreen.id, (_) => false);
                            });
                          },
                          textColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
