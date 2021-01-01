import 'package:dabao_together/Screens/Add_Request.dart';
import 'package:dabao_together/Screens/ChatAppBar.dart';
import 'package:dabao_together/Screens/ChatHome.dart';
import 'package:dabao_together/Screens/Enter_OTP.dart';
import 'package:dabao_together/Screens/GoogleMapScreen.dart';
import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:dabao_together/Screens/Main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Screens/ChatScreen.dart';
import 'Screens/Contact_Us.dart';
import 'Screens/Edit_Request.dart';
import 'Screens/Enter_Username.dart';
import 'Screens/Home.dart';
import 'Screens/Login.dart';
import 'Screens/My_Past_Requests.dart';
import 'Screens/My_Requests.dart';
import 'Screens/Register.dart';
import 'Screens/TncScreen.dart';
import 'Screens/Welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuProvider(),
      child: MaterialApp(
          title: 'Dabao Together',
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
          initialRoute: WelcomeScreen.id,
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            MainActivityContainer.id: (context) => MainActivityContainer(),
            EnterUserName.id: (context) => EnterUserName(),
            PinCodeVerificationScreen.id: (context) =>
                PinCodeVerificationScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            AddRequest.id: (context) => AddRequest(),
            EditRequest.id: (context) => EditRequest(),
            Chat.id: (context) => Chat(),
            ChatHomeScreen.id: (context) => ChatHomeScreen(),
            // ChatScreen.id: (context) => ChatScreen(),
            ChatAppBarScreen.id: (context) => ChatAppBarScreen(),
            MyRequestsScreen.id: (context) => MyRequestsScreen(),
            MyPastRequestsScreen.id: (context) => MyPastRequestsScreen(),
            HomeNavScreen.id: (context) => HomeNavScreen(),
            TncScreen.id: (context) => TncScreen(),
            GoogleMapScreen.id: (context) => GoogleMapScreen(),
            ContactUsScreen.id: (context) => ContactUsScreen(),
            // Chat.id: (context) => Chat(),
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
