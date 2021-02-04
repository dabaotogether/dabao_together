import 'package:dabao_together/Screens/HomeNav.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  static const String id = 'introduction_screen';
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushNamedAndRemoveUntil(context, HomeNavScreen.id, (_) => false);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('images/$assetName', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 50),
    );

    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            title: "A short intro before you start Dabao Together",
            body:
                "To start searching for kakis, you can enter your postal code or post your jio using the bottom right burger button. Use the bottom bar to navigate the various features.",
            image: _buildImage('Main.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Chat up with your Kakis!",
            body:
                "Based on your postal code, we will locate your kakis within 1 km (distance is based on agar-ation). Hit the chat button to message your kakis or click the edit button to edit your jio. You can also look at the exact location on map by clicking on the address link.",
            image: _buildImage('MainWithInfo.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Access the menu page",
            body:
                "To access other features such as toggle notification, click on the menu on the top left.",
            image: _buildImage('Drawer.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            image: _buildImage('dabao_together_new_logo.png'),
            title: "For your kind attention",
            body:
                "It's inevitable that you will encounter some bad experiences such as delay in delivery, wrong order or even scammers. We hope you can stay positive and continue to spread the love!",
            decoration: pageDecoration,
          ),
          PageViewModel(
            image: _buildImage('dabao_together_new_logo.png'),
            title: "Last but not least",
            body:
                "Please share this app in your community and do email us for any feedback. Stay safe and thank you!",
            decoration: pageDecoration,
          ),
          PageViewModel(
            image: _buildImage('dabao_together_new_logo.png'),
            title: "Psst....",
            body:
                "We just want to assure you that this app doesn't track your location and your data will not be useful for any investigation (unlike T****Together app).",
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body:
            const Center(child: Text("This is the screen after Introduction")),
      ),
    );
  }
}
