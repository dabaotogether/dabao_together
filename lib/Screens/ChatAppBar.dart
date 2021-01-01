import 'package:dabao_together/components/Page_Structure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import 'Menu_Page.dart';

User loggedInUser;

class ChatAppBarScreen extends StatefulWidget {
  static const String id = 'chatappbar_screen';

  static List<MenuItem> mainMenu = [
    MenuItem('Find Kakis', Icons.emoji_people_rounded, 0),
    MenuItem('My Current Jios', Icons.local_activity_rounded, 1),
    MenuItem('Chats', Icons.chat_rounded, 2),
    MenuItem('My Jios Last Time', Icons.history_rounded, 3),
    MenuItem('Dabao Hacks', Icons.lightbulb_outline_rounded, 4),
    MenuItem('Contact Us', Icons.contact_mail_rounded, 5),
    MenuItem('About us', Icons.info_outline_rounded, 6),
    MenuItem('Notifications', Icons.notifications_rounded, 7),
  ];

  @override
  _ChatAppBarScreenState createState() => new _ChatAppBarScreenState();
}

class _ChatAppBarScreenState extends State<ChatAppBarScreen> {
  final _drawerController = ZoomDrawerController();
  final _auth = FirebaseAuth.instance;
  String userName = '';
  String displayName;
  int _currentPage = 2;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        displayName = user.displayName;
        print(displayName);
        if (loggedInUser != null) {
          setState(() {
            userName = loggedInUser.displayName;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      showShadow: true,
      controller: _drawerController,
      menuScreen: MenuScreen(
        ChatAppBarScreen.mainMenu,
        callback: _updatePage,
        current: _currentPage,
      ),
      mainScreen: MainScreen(),
      borderRadius: 24.0,
//      showShadow: true,
      angle: 0.0,
      slideWidth:
          MediaQuery.of(context).size.width * (ZoomDrawer.isRTL() ? .45 : 0.65),
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.fastOutSlowIn,
    );
  }

  void _updatePage(index) {
    Provider.of<MenuProviderChat>(context, listen: false)
        .updateCurrentPage(index);
    _drawerController.toggle();
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final rtl = ZoomDrawer.isRTL();
    return ValueListenableBuilder<DrawerState>(
      valueListenable: ZoomDrawer.of(context).stateNotifier,
      builder: (context, state, child) {
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: PageStructure(title: 'Chat History'),
        onPanUpdate: (details) {
          if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
            ZoomDrawer.of(context).toggle();
          }
        },
      ),
    );
  }
}

class MenuProviderChat extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}
