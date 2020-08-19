import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/routes/chat_screen.dart';
import 'package:flash_chat/routes/submit_otp.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PhoneAuthentication {
  static int _forceResendingToken;
  static String verificationId;

  static Future<void> login(
      BuildContext context, AuthCredential phoneAuthCredential) async {
    try {
      print('login');
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult authRes) {
        print(authRes.user.toString());
      });
      _forceResendingToken = null;
      verificationId = null;
      Navigator.of(context).pushNamedAndRemoveUntil(
          ChatScreen.id, (Route<dynamic> route) => false);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> submitPhoneNumber(
      BuildContext context, String phoneNumber, int resendOTPtimeout) async {
    phoneNumber = '+91' + phoneNumber;

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      login(context, phoneAuthCredential);
    }

    void verificationFailed(AuthException error) {
      print('verificationFailed');
      print(error);
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: error.message,
        buttons: [],
        closeFunction: () {},
      ).show();
    }

    void codeSent(String verificationId, [int forceResendingToken]) {
      print('codeSent');
      PhoneAuthentication.verificationId = verificationId;
      print(verificationId);
      PhoneAuthentication._forceResendingToken = forceResendingToken;
      print(forceResendingToken.toString());
      Navigator.pushNamed(context, SubmitOTP.id, arguments: {
        'phoneNumber': phoneNumber,
        'timeout': resendOTPtimeout,
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: resendOTPtimeout),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: _forceResendingToken,
    );
  }
}
