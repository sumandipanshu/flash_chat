import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/routes/chat_screen.dart';
import 'package:flash_chat/routes/home.dart';
import 'package:flash_chat/routes/submit_otp.dart';
import 'package:flash_chat/routes/user_profile.dart';
import 'package:flash_chat/routes/verification.dart';
import 'package:flash_chat/routes/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  runApp(FlashChat());
}

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
        home: WelcomeScreen(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case WelcomeScreen.id:
              return MaterialPageRoute(builder: (context) => WelcomeScreen());
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
            case UserProfile.id:
              return MaterialPageRoute(builder: (context) => UserProfile());
              break;
            case Home.id:
              return MaterialPageRoute(builder: (context) => Home());
              break;
            case ChatScreen.id:
              return MaterialPageRoute(builder: (context) => ChatScreen());
              break;
            default:
              return MaterialPageRoute(builder: (context) => WelcomeScreen());
              break;
          }
        },
      ),
    );
  }
}
