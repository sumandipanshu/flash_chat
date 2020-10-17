import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/chat_bubble.dart';
import 'package:flash_chat/components/round_icon_button.dart';
import 'package:flash_chat/components/stickerview.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/verification.dart';
import 'package:flash_chat/services/image_toolkit.dart';
import 'package:flash_chat/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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

  bool isvisible = false;
  ImageToolkit imageToolkit = ImageToolkit();
  Storage storage = Storage();

  File _imageFile;

  void getCurrentUser() {
    _user = _auth.currentUser;
    setState(() {});
  }

  void chooseImage(ImageSource source) async {
    try {
      await imageToolkit.pickImage(source);
      setState(() {
        _imageFile = imageToolkit.imageFile;
      });
      print('done');
    } catch (e) {
      print(e);
    }
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
                final messages = snapshot.data.docs;
                var lastMessage;
                List<Widget> chatBubbles = [];
                for (var message in messages) {
                  var type = message.get('type');
                  var newMessage;

                  if (type == 'text') {
                    newMessage = ChatBubble.text(
                      context: context,
                      messageText: message.get('data'),
                      isMe: message.get('uid') == _user.uid,
                      isFirstMessage: message.get('uid') != lastMessage,
                    );
                  } else if (type == 'image') {
                    newMessage = ChatBubble.image(
                      context: context,
                      imageURL: message.get('data'),
                      isMe: message.get('uid') == _user.uid,
                      isFirstMessage: message.get('uid') != lastMessage,
                    );
                  } else {
                    newMessage = ChatBubble.sticker(
                      context: context,
                      stickerURL: message.get('data'),
                      isMe: message.get('uid') == _user.uid,
                      isFirstMessage: message.get('uid') != lastMessage,
                    );
                  }
                  lastMessage = message.get('uid');
                  chatBubbles.add(newMessage);
                }
                return Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    reverse: true,
                    children: chatBubbles.reversed.toList(),
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 5),
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
                          GestureDetector(
                            onTap: () {
                              print('tap');
                              setState(() {
                                messageFocusNode.unfocus();
                                isvisible = !isvisible;
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 50,
                              child: Icon(
                                sticker,
                                color: Colors.blueGrey,
                                size: 28,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              focusNode: messageFocusNode,
                              controller: messageController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
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
                              onTap: () {
                                setState(() {
                                  isvisible = false;
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              imageToolkit.showMenu(
                                context: context,
                                chooseImage: chooseImage,
                              );
                              if (_imageFile != null) {
                                print('started');
                                final imageUrl = await storage.uploadPhoto(
                                    imageToolkit.imageFile, 'swas');

                                _firestore.collection('messages').add({
                                  'type': 'image',
                                  'uid': _user.uid,
                                  'data': imageUrl,
                                  'timestamp':
                                      Timestamp.now().millisecondsSinceEpoch,
                                });
                              }
                              Future.delayed(Duration(milliseconds: 100), () {
                                scrollController.animateTo(
                                    scrollController.position.minScrollExtent,
                                    curve: Curves.ease,
                                    duration: Duration(milliseconds: 500));
                              });
                              messageFocusNode.unfocus();
                            },
                            child: Container(
                              width: 40,
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                FontAwesomeIcons.images,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  RoundIconButton(
                    icon: Icons.send,
                    fillColor: kPrimaryColor,
                    onPressed: () {
                      try {
                        messageController.clear();
                        Future.delayed(Duration(milliseconds: 100), () {
                          scrollController.animateTo(
                              scrollController.position.minScrollExtent,
                              curve: Curves.ease,
                              duration: Duration(milliseconds: 500));
                        });
                        if (messageText == null || messageText.trim() == '')
                          throw 'Nothing to send';

                        _firestore.collection('messages').add({
                          'type': 'text',
                          'uid': _user.uid,
                          'data': messageText,
                          'timestamp': Timestamp.now().millisecondsSinceEpoch,
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
            Visibility(
              visible: isvisible,
              child: Container(
                height: 250,
                child: StickerView(
                  firestore: _firestore,
                  user: _user,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
