import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/round_icon_button.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isWaiting,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      logoImage,
                    ),
                    height: 200,
                  ),
                ),
              ),
              SizedBox(
                height: 48,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextInputDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: kTextInputDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Hero(
                  tag: 'login',
                  child: RoundedButton(
                    text: 'Log In',
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      setState(() {
                        _isWaiting = true;
                      });
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "ERROR",
                          desc: "Invalid username or password.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Try Again!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              width: 120,
                            )
                          ],
                          closeFunction: () {},
                        ).show();
                      }
                      setState(() {
                        _isWaiting = false;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RoundIconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.arrow_back_ios,
                  fillColor: kPrimaryColor,
                  padding: EdgeInsets.only(left: 12),
                  radius: 65,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
