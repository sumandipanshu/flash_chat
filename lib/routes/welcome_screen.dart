import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/login_screen.dart';
import 'package:flash_chat/routes/registration_screen.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      logoImage,
                    ),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 500),
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Hero(
                tag: 'login',
                child: RoundedButton(
                  text: 'Log In',
                  color: kPrimaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Hero(
                tag: 'register',
                child: RoundedButton(
                  text: 'Register',
                  color: kSecondaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
