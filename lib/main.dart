import 'package:dabao_together/Screens/Add_Request.dart';
import 'package:dabao_together/Screens/ChatHome.dart';
import 'package:dabao_together/Screens/Enter_OTP.dart';
import 'package:dabao_together/Screens/GoogleMapScreen.dart';
import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:dabao_together/Screens/Main.dart';
import 'package:dabao_together/Screens/Who_Are_We.dart';
import 'package:dabao_together/components/NotificationsManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Screens/Blocked_Users_List.dart';
import 'Screens/ChatScreen.dart';
import 'Screens/Contact_Us.dart';
import 'Screens/Edit_Request.dart';
import 'Screens/Enter_Username.dart';
import 'Screens/IntroScreen.dart';
import 'Screens/My_Past_Requests.dart';
import 'Screens/My_Requests.dart';
import 'Screens/Register.dart';
import 'Screens/TncScreen.dart';
import 'Screens/Welcome.dart';

final _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    NotificationsManager newManager = NotificationsManager(context);
    newManager.configLocalNotification();
    newManager.registerNotification();
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     FlutterAppBadger.removeBadge();
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dabao Together',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF000000),
          accentColor: Color(0xFF000000),
          colorScheme: ColorScheme.light(primary: const Color(0xFF000000)),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // onGenerateTitle: (context) => tr("app_name"),
        // home: ChangeNotifierProvider(
        //   create: (_) => MenuProvider(),
        //   child: WelcomeScreen(),
        // ),
        // initialRoute: WelcomeScreen.id,
        home: WelcomeScreen(),
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          MainActivityContainer.id: (context) => MainActivityContainer(),
          EnterUserName.id: (context) => EnterUserName(),
          PinCodeVerificationScreen.id: (context) =>
              PinCodeVerificationScreen(),
          AddRequest.id: (context) => AddRequest(),
          EditRequest.id: (context) => EditRequest(),
          Chat.id: (context) => Chat(),
          ChatHomeScreen.id: (context) => ChatHomeScreen(),
          // ChatScreen.id: (context) => ChatScreen(),
          MyRequestsScreen.id: (context) => MyRequestsScreen(),
          MyPastRequestsScreen.id: (context) => MyPastRequestsScreen(),
          HomeNavScreen.id: (context) => HomeNavScreen(),
          TncScreen.id: (context) => TncScreen(),
          GoogleMapScreen.id: (context) => GoogleMapScreen(),
          ContactUsScreen.id: (context) => ContactUsScreen(),
          IntroScreen.id: (context) => IntroScreen(),
          WhoAreWeScreen.id: (context) => WhoAreWeScreen(),
          Blocked_Users_List_Screen.id: (context) =>
              Blocked_Users_List_Screen(),
          // Chat.id: (context) => Chat(),
        });
  }
}
