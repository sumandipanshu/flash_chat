import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/chat_bubble.dart';
import 'package:flash_chat/components/round_icon_button.dart';
import 'package:flash_chat/components/stickerview.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/services/image_toolkit.dart';
import 'package:flash_chat/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';

  ChatScreen(
      {@required this.chatId,
      @required this.uid,
      @required this.peerUid,
      @required this.peerName});

  final String chatId, uid, peerUid, peerName;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();
  String messageText;
  final _firestore = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();

  bool isShowSticker = false;
  ImageToolkit imageToolkit = ImageToolkit();
  Storage storage = Storage();

  File _imageFile;

  void chooseImage(ImageSource source) async {
    try {
      await imageToolkit.pickImage(source);
      setState(() {
        _imageFile = imageToolkit.imageFile;
      });
      print('file found');
    } catch (e) {
      print(e);
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
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
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(widget.peerName),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                    .doc(widget.chatId)
                    .collection('chats')
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
                        isMe: message.get('uid') == widget.uid,
                        isFirstMessage: message.get('uid') != lastMessage,
                      );
                    } else if (type == 'image') {
                      newMessage = ChatBubble.image(
                        context: context,
                        imageURL: message.get('data'),
                        isMe: message.get('uid') == widget.uid,
                        isFirstMessage: message.get('uid') != lastMessage,
                      );
                    } else {
                      newMessage = ChatBubble.sticker(
                        context: context,
                        stickerURL: message.get('data'),
                        isMe: message.get('uid') == widget.uid,
                        isFirstMessage: message.get('uid') != lastMessage,
                      );
                    }
                    lastMessage = message.get('uid');
                    chatBubbles.add(newMessage);
                  }
                  Future.delayed(Duration(milliseconds: 100), () {
                    scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 500));
                  });
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
                                messageFocusNode.unfocus();
                                setState(() {
                                  isShowSticker = !isShowSticker;
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
                                    isShowSticker = false;
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
                                print('reached');
                                if (_imageFile != null) {
                                  print('uploading');
                                  final imageUrl = await storage.uploadPhoto(
                                    imageToolkit.imageFile,
                                    widget.chatId,
                                    widget.uid,
                                  );

                                  await _firestore
                                      .collection('messages')
                                      .doc(widget.chatId)
                                      .collection('chats')
                                      .add({
                                    'type': 'image',
                                    'uid': widget.uid,
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
                      onPressed: () async {
                        try {
                          messageController.clear();
                          if (messageText == null || messageText.trim() == '')
                            throw 'Nothing to send';

                          await _firestore
                              .collection('messages')
                              .doc(widget.chatId)
                              .collection('chats')
                              .add({
                            'type': 'text',
                            'uid': widget.uid,
                            'data': messageText,
                            'timestamp': Timestamp.now().millisecondsSinceEpoch,
                          });
                          Future.delayed(Duration(milliseconds: 100), () {
                            scrollController.animateTo(
                                scrollController.position.minScrollExtent,
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
              Visibility(
                visible: isShowSticker,
                child: Container(
                  height: 250,
                  child: StickerView(
                    firestore: _firestore,
                    uid: widget.uid,
                    chatId: widget.chatId,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
