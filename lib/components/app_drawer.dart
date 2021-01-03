import 'package:dabao_together/Screens/Contact_Us.dart';
import 'package:dabao_together/Screens/Main.dart';
import 'package:dabao_together/Screens/My_Past_Requests.dart';
import 'package:dabao_together/Screens/Welcome.dart';
import 'package:dabao_together/components/NotificationsManager.dart';
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
                          Icons.local_activity_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Main',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.pushNamed(
                              context, MainActivityContainer.id);
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
                          Navigator.pushNamed(context, MyPastRequestsScreen.id);
                        },
                      ),
                      ListTile(
                        selected: widget.selectedIndex == 3,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Dabao Hacks',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        selected: widget.selectedIndex == 4,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'About Us',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        selected: widget.selectedIndex == 5,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.contact_mail_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Contact Us',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.pushNamed(context, ContactUsScreen.id);
                        },
                      ),
                      ListTile(
                        selected: widget.selectedIndex == 6,
                        selectedTileColor: Colors.grey[800],
                        leading: Icon(
                          Icons.notifications_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Toggle Notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              if (!isSwitched) {
                                NotificationsManager newManager =
                                    NotificationsManager(context);
                                newManager.unregisterNotification();
                                Flushbar(
                                  title: "Heyo",
                                  message:
                                      "As the notification is turned off, do check the in-app messages regularly or indicate your phone number in the post.",
                                  duration: Duration(seconds: 3),
                                )..show(context);
                              } else {
                                NotificationsManager newManager =
                                    NotificationsManager(context);
                                newManager.configLocalNotification();
                                newManager.registerNotification();
                              }
                            });
                          },
                          inactiveTrackColor: Colors.redAccent,
                          activeTrackColor: Colors.greenAccent,
                          activeColor: Colors.white,
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
                              NotificationsManager newManager =
                                  NotificationsManager(context);
                              newManager.unregisterNotification();
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
