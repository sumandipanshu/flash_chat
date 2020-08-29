import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/components/round_icon_button.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();
  String messageText;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User _user;
  ScrollController scrollController = ScrollController();

  void getCurrentUser() {
    _user = _auth.currentUser;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    messageFocusNode.dispose();
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
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
//            StreamBuilder<QuerySnapshot>(
//              stream: _firestore
//                  .collection("messages")
//                  .orderBy("timestamp")
//                  .snapshots(),
//              builder: (context, snapshot) {
//                if (!snapshot.hasData) {
//                  return Expanded(
//                    child: Center(
//                      child: CircularProgressIndicator(
//                        backgroundColor: kPrimaryColor,
//                      ),
//                    ),
//                  );
//                }
//                final messages = snapshot.data.docs.reversed;
//                List<MessageBubble> messageBubbles = [];
//                var x = List();
//                for (var message in messages) {
//                  x.add(message.data());
//                  var newMessage = MessageBubble(
//                    text: message.get('text'),
//                    isMe: _user.displayName == message.get('name'),
//                    sender: message.get('name'),
//                  );
//                  messageBubbles.add(newMessage);
//                }
//                print(x[0]);
//                return Expanded(
//                  child: ListView(
//                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                    scrollDirection: Axis.vertical,
//                    reverse: true,
//                    children: messageBubbles,
//                  ),
//                );
//              },
//            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                scrollDirection: Axis.vertical,
//                reverse: true,
                children: [
                  Message.text(
                    text: 'hey there! how are you?',
                    isMe: true,
                    lastMessage: false,
                  ),
                  Message.image(
                    imageURL: 'assets/images/user.png',
                    isMe: true,
                    lastMessage: false,
                  ),
                  Message.text(
                    text: 'hey there! how are you?',
                    isMe: true,
                    lastMessage: true,
                  ),
                  Message.text(
                    text: 'hey there! how are you?',
                    isMe: false,
                    lastMessage: false,
                  ),
                  Message.text(
                    text: 'hey there! how are you?',
                    isMe: false,
                    lastMessage: true,
                  ),
                  Message.text(
                    text: 'hey there! how are you?hey te! how are you?',
                    isMe: true,
                    lastMessage: true,
                  ),
                  Message.text(
                    text:
                        'hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?hey there! how are you?',
                    isMe: false,
                    lastMessage: true,
                  ),
                  Message.text(
                    text: 'hey there! how are you?',
                    isMe: true,
                    lastMessage: true,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: kPrimaryColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: Icon(
                              sticker,
                              color: Colors.blueGrey,
                              size: 28,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              focusNode: messageFocusNode,
                              controller: messageController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Type your message here...',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                messageText = value;
                              },
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text("First"),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text("Second"),
                              ),
                            ],
                            icon: Icon(
                              FontAwesomeIcons.images,
                              color: Colors.blueGrey,
                            ),
                            onSelected: (value) {
                              print(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RoundIconButton(
                    icon: Icons.send,
                    fillColor: kPrimaryColor,
                    onPressed: () {
                      try {
                        messageController.clear();
                        if (messageText == null && messageText.trim() == '')
                          throw 'Nothing to send.';

//                          _firestore.collection('messages').add({
//                            'text': messageText,
//                            'name': _user.displayName,
//                            'timestamp': Timestamp.now().millisecondsSinceEpoch,
//                          });
                        Future.delayed(Duration(milliseconds: 100), () {
                          scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              curve: Curves.ease,
                              duration: Duration(milliseconds: 500));
                        });
                        messageText = null;
                      } catch (e) {
                        print(e);
                      }
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
