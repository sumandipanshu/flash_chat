import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/services/phone_authentication.dart';
import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  static const String id = 'verification';

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String phoneNumber;
  bool error = false, isWaiting = false;
  int resendOTPtimeout = 90;

  void getOTP() async {
    try {
      if (phoneNumber == null ||
          phoneNumber.length != 10 ||
          !phoneNumber.contains(RegExp(r'^[0-9]+$')))
        throw 'Enter a valid Phone number';
      print('start');
      setState(() {
        isWaiting = true;
      });
      print('start2');
      await Future.delayed(Duration(milliseconds: 30));
      await PhoneAuthentication.submitPhoneNumber(
          context, phoneNumber, resendOTPtimeout);
    } catch (e) {
      print(e);
      setState(() {
        isWaiting = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
            TextField(
              autofocus: true,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              textAlign: TextAlign.center,
              decoration: kTextInputDecoration.copyWith(
                fillColor: Colors.red.withOpacity(0.35),
                filled: error,
                hintText: error
                    ? 'Enter a valid Phone number'
                    : 'Enter your Phone number',
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: error ? Colors.red : kPrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: error ? Colors.red : kPrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
              onChanged: (value) {
                phoneNumber = value;
                setState(() {
                  error = false;
                });
              },
              onEditingComplete: getOTP,
              onTap: () {
                setState(() {
                  error = false;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: getOTP,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Verify your number',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator()),
                      ),
                      visible: isWaiting,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'By tapping "Verify your number", an SMS may be sent. Message & data rates may apply.',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
