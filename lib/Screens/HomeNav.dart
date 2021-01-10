import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/ChatHome.dart';
import 'package:dabao_together/Screens/Main.dart';
import 'package:dabao_together/Screens/My_Requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

// final _firestore = Firestore.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;
final geo = Geoflutterfire();
final _auth = FirebaseAuth.instance;

class HomeNavScreen extends StatefulWidget {
  static const String id = 'home_navigation_screen';
  // MainActivityContainer({@required this.colour, this.cardChild, this.onPress});
  //
  // final Color colour;
  // final Widget cardChild;
  // final Function onPress;
  @override
  _HomeNavScreenState createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {
  Stream<QuerySnapshot> requestStream;

  @override
  void initState() {
    requestStream = newStream();
    super.initState();
  }

  Stream<QuerySnapshot> newStream() {
    var requestsDoc = firestoreInstance
        .collection('requests')
        .where('expired', isEqualTo: 0)
        .where('user_id', isEqualTo: _auth.currentUser.uid)
        .snapshots();

    return requestsDoc;
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _showRequestsFormKey = GlobalKey<FormState>();
  TextEditingController postalCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String postalCode = '';
    String address = '';
    String geox = '';
    String geoy = '';

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text('My Jios')),
        // drawer: AppDrawer(
        //   username: _auth.currentUser.displayName,
        //   selectedIndex: 1,
        // ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_people_rounded),
              label: 'Find Kakis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity_rounded),
              label: 'My Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: 'Chats',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        body: IndexedStack(
          children: <Widget>[
            MainActivityContainer(),
            MyRequestsScreen(),
            ChatHomeScreen(),
          ],
          index: _selectedIndex,
        ),
      ),
    );
  }
}
