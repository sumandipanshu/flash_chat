import 'package:flash_chat/routes/chat_screen.dart';
import 'package:flash_chat/routes/submit_otp.dart';
import 'package:flash_chat/routes/verification.dart';
import 'package:flash_chat/routes/welcome_screen2.dart';
import 'package:flutter/material.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen2(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case WelcomeScreen2.id:
              return MaterialPageRoute(builder: (context) => WelcomeScreen2());
              break;
            case Verification.id:
              return MaterialPageRoute(builder: (context) => Verification());
              break;
            case SubmitOTP.id:
              Map<String, dynamic> args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) => SubmitOTP(
                  phoneNumber: args['phoneNumber'],
                  timeout: args['timeout'],
                ),
              );
              break;
            case ChatScreen.id:
              return MaterialPageRoute(builder: (context) => ChatScreen());
              break;
            default:
              return MaterialPageRoute(builder: (context) => WelcomeScreen2());
              break;
          }
        },
      ),
    );
  }
}
