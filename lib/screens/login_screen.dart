import 'package:flutter/material.dart';
import 'package:have_chat_app/component/round_button.dart';
import 'package:have_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool cricularSpiner = false;
  final _auth = FirebaseAuth.instance;
  String emailAddress = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: cricularSpiner
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.greenAccent,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        //TODO change the height on the image logo of the application.
                        height: 200.0,
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
                      emailAddress = value;
                    },
                    decoration:
                        KInputDecoration.copyWith(hintText: 'Enter Your Email'),
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
                        hintText: 'Enter Your Password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  ResueMatterialButton(
                    colorInput: Colors.lightBlueAccent,
                    textLabel: 'Log In',
                    onPressInput: () async {
                      setState(() {
                        cricularSpiner = true;
                      });
                      try {
                        final logedUser =
                            await _auth.signInWithEmailAndPassword(
                                email: emailAddress, password: password);
                        if (logedUser != null) {
                          final emailAddressOfUser=_auth.currentUser?.email;
                          Navigator.pushNamed(context, ChatScreen.id,arguments:emailAddressOfUser);
                          print(' this is the person login in to  from login page${_auth.currentUser?.email}');
                        }
                        setState(() {
                          cricularSpiner = false;
                        });
                      } catch (e) {
                        cricularSpiner = false;
                        print(e);
                      }
                      cricularSpiner = false;
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
