import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/home.dart';
import 'package:flash_chat/routes/verification.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome2';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  final _auth = FirebaseAuth.instance;
  var user;

  void getCurrentUser() {
    user = _auth.currentUser;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset(
                  logoImage,
                ),
                height: 200,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.1),
              child: TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 300),
                text: ['Flash Chat'],
                totalRepeatCount: 1,
                textStyle: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                ),
                onFinished: () {
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, Home.id);
                  } else {
                    Navigator.pushReplacementNamed(context, Verification.id);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
