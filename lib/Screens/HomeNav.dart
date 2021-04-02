import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/ChatHome.dart';
import 'package:dabao_together/Screens/Main.dart';
import 'package:dabao_together/Screens/My_Requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

// final _firestore = Firestore.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class HomeNavScreen extends StatefulWidget {
  static const String id = 'home_navigation_screen';

  @override
  _HomeNavScreenState createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  bool _isFirstLoad = true;
  void _onItemTapped(int index) {
    if (index == 2) {
      FlutterAppBadger.removeBadge();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  final _showRequestsFormKey = GlobalKey<FormState>();
  TextEditingController postalCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;

    if (args != null) {
      if (args['selectedIndex'] != null && _isFirstLoad) {
        _selectedIndex = int.parse(args['selectedIndex']);
        _isFirstLoad = false;
      }
    }
    return SafeArea(
      child: Scaffold(
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
