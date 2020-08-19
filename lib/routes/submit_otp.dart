import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/countdown.dart';
import 'package:flash_chat/components/otp_field.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/services/phone_authentication.dart';
import 'package:flutter/material.dart';

class SubmitOTP extends StatefulWidget {
  static const String id = 'submitOTP';
  SubmitOTP({@required this.phoneNumber, @required this.timeout});

  final String phoneNumber;
  final int timeout;

  @override
  _SubmitOTPState createState() => _SubmitOTPState();
}

class _SubmitOTPState extends State<SubmitOTP>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool activateResendOTPButton = false, error = false, isWaiting = false;

  String _otp,
      digit1 = '',
      digit2 = '',
      digit3 = '',
      digit4 = '',
      digit5 = '',
      digit6 = '';

  FocusNode input1 = FocusNode(),
      input2 = FocusNode(),
      input3 = FocusNode(),
      input4 = FocusNode(),
      input5 = FocusNode(),
      input6 = FocusNode();

  final inputController1 = TextEditingController(),
      inputController2 = TextEditingController(),
      inputController3 = TextEditingController(),
      inputController4 = TextEditingController(),
      inputController5 = TextEditingController(),
      inputController6 = TextEditingController();

  AuthCredential _phoneAuthCredential;

  void clearInputFields() {
    inputController1.clear();
    inputController2.clear();
    inputController3.clear();
    inputController4.clear();
    inputController5.clear();
    inputController6.clear();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.timeout));

    _controller.forward();
    _controller.addListener(() {
      if (_controller.value == 1) {
        setState(() {
          activateResendOTPButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    input1.dispose();
    input2.dispose();
    input3.dispose();
    input4.dispose();
    input5.dispose();
    input6.dispose();
    inputController1.dispose();
    inputController2.dispose();
    inputController3.dispose();
    inputController4.dispose();
    inputController5.dispose();
    inputController6.dispose();
    super.dispose();
  }

  void _submitOTP() async {
    _otp = '$digit1$digit2$digit3$digit4$digit5$digit6';
    try {
      if (_otp == null &&
          _otp.length != 6 &&
          !_otp.contains(RegExp(r'^[0-9]+$'))) throw 'Invalid OTP entered.';
      _phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: PhoneAuthentication.verificationId, smsCode: _otp);
      setState(() {
        isWaiting = true;
      });
      await PhoneAuthentication.login(context, _phoneAuthCredential);
    } catch (e) {
      setState(() {
        isWaiting = false;
        error = true;
      });
      print(e.toString());
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
            Text(
              'Enter the 6-digit code we sent to ${widget.phoneNumber}:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OTPField(
                  controller: inputController1,
                  backgroundColor: error
                      ? Colors.red.withOpacity(0.35)
                      : kPrimaryColor.withOpacity(0.15),
                  bottomBorderColor: error ? Colors.red : kPrimaryColor,
                  focusNode: input1,
                  autofocus: true,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).requestFocus(input2);
                    }
                    digit1 = value ?? '';
                    setState(() {
                      error = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      error = false;
                    });
                  },
                  onEditingComplete: _submitOTP,
                ),
                OTPField(
                  controller: inputController2,
                  backgroundColor: error
                      ? Colors.red.withOpacity(0.35)
                      : kPrimaryColor.withOpacity(0.15),
                  bottomBorderColor: error ? Colors.red : kPrimaryColor,
                  focusNode: input2,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).requestFocus(input3);
                    }
                    digit2 = value ?? '';
                    setState(() {
                      error = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      error = false;
                    });
                  },
                  onEditingComplete: _submitOTP,
                ),
                OTPField(
                  controller: inputController3,
                  backgroundColor: error
                      ? Colors.red.withOpacity(0.35)
                      : kPrimaryColor.withOpacity(0.15),
                  bottomBorderColor: error ? Colors.red : kPrimaryColor,
                  focusNode: input3,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).requestFocus(input4);
                    }
                    digit3 = value ?? '';
                    setState(() {
                      error = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      error = false;
                    });
                  },
                  onEditingComplete: _submitOTP,
                ),
                OTPField(
                  controller: inputController4,
                  backgroundColor: error
                      ? Colors.red.withOpacity(0.35)
                      : kPrimaryColor.withOpacity(0.15),
                  bottomBorderColor: error ? Colors.red : kPrimaryColor,
                  focusNode: input4,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).requestFocus(input5);
                    }
                    digit4 = value ?? '';
                    setState(() {
                      error = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      error = false;
                    });
                  },
                  onEditingComplete: _submitOTP,
                ),
                OTPField(
                  controller: inputController5,
                  backgroundColor: error
                      ? Colors.red.withOpacity(0.35)
                      : kPrimaryColor.withOpacity(0.15),
                  bottomBorderColor: error ? Colors.red : kPrimaryColor,
                  focusNode: input5,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).requestFocus(input6);
                    }
                    digit5 = value ?? '';
                    setState(() {
                      error = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      error = false;
                    });
                  },
                  onEditingComplete: _submitOTP,
                ),
                OTPField(
                  controller: inputController6,
                  backgroundColor: error
                      ? Colors.red.withOpacity(0.35)
                      : kPrimaryColor.withOpacity(0.15),
                  bottomBorderColor: error ? Colors.red : kPrimaryColor,
                  focusNode: input6,
                  onChanged: (value) {
                    digit6 = value ?? '';
                    setState(() {
                      error = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      error = false;
                    });
                  },
                  onEditingComplete: _submitOTP,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: _submitOTP,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Verify OTP',
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: RoundedButton(
                color:
                    activateResendOTPButton ? Colors.white : Colors.grey[400],
                onPressed: activateResendOTPButton
                    ? () {
                        setState(() {
                          activateResendOTPButton = false;
                          _controller.reset();
                          _controller.forward();
                        });
                        PhoneAuthentication.submitPhoneNumber(
                            context, widget.phoneNumber, widget.timeout);
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 15,
                        color: activateResendOTPButton
                            ? Colors.black
                            : Colors.black54,
                      ),
                    ),
                    Visibility(
                      visible: !activateResendOTPButton,
                      child: Countdown(
                        animation: StepTween(
                          begin: widget.timeout,
                          end: 0,
                        ).animate(_controller),
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
