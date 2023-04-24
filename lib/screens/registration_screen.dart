import 'package:flutter/material.dart';
import 'package:have_chat_app/constants.dart';
import 'package:have_chat_app/component/round_button.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool  processingData=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: processingData?Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.cyan,
          ),
        ):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  //TODO height is the = 200 but the use animation to hold the size
                  height: 100.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  KInputDecoration.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: KInputDecoration.copyWith(
                hintText: 'Enter Your Password',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            ResueMatterialButton(
              onPressInput: () async {
                try {
                  final userCreated =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                  if (userCreated != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } catch (e) {
                  print(e);
                }
              },
              colorInput: Colors.blueAccent,
              textLabel: 'Register',
            )
          ],
        ),
      ),
    );
  }
}
