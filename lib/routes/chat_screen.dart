import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/components/round_icon_button.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/verification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  String messageText;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  var loggedInUser;

  void getCurrentUser() {
    loggedInUser = _auth.currentUser;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Chat'),
        leading: IconButton(
          onPressed: () async {
            await _auth.signOut();
            print('signedOut');
            Navigator.pushReplacementNamed(context, Verification.id);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("messages")
                  .orderBy("timestamp")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      ),
                    ),
                  );
                }
                final messages = snapshot.data.docs.reversed;
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  var newMessage = MessageBubble(
                    text: message.get('text'),
                    isMe: loggedInUser.displayName == message.get('name'),
                    sender: message.get('name'),
                  );
                  messageBubbles.add(newMessage);
                }
                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    children: messageBubbles,
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: kTextInputDecoration.copyWith(
                        filled: true,
                        fillColor: kPrimaryColor.withAlpha(50),
                        hintText: 'Type your message here...',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Colors.lightBlueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      onChanged: (value) {
                        messageText = value;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RoundIconButton(
                    icon: Icons.send,
                    fillColor: kPrimaryColor,
                    onPressed: () {
                      messageController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'name': loggedInUser.displayName,
                        'timestamp': Timestamp.fromDate(DateTime.now()).seconds,
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
