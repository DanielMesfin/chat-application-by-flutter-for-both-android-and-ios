import 'package:flutter/material.dart';
import 'package:have_chat_app/screens/registration_screen.dart';
import 'package:have_chat_app/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:have_chat_app/component/round_button.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'well_come_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    animation =
        ColorTween(begin: Colors.red, end: Colors.purple).animate(controller);
    controller.forward();
    controller.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  textAlign: TextAlign.end,
                  text: ['Have Chat'],
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ResueMatterialButton(
              onPressInput: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              textLabel: 'Log In',
              colorInput: Colors.lightBlueAccent,
            ),
            ResueMatterialButton(
              onPressInput: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              textLabel: 'Register',
              colorInput: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
