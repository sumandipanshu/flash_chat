import 'package:flutter/material.dart';
import '../global.dart';

class Message {
  static Widget text(
      {bool isMe, String photoURL, String text, bool lastMessage}) {
    return Padding(
      padding: isMe
          ? EdgeInsets.fromLTRB(80, 0, 0, lastMessage ? 20 : 10)
          : EdgeInsets.fromLTRB(0, 0, 80, lastMessage ? 20 : 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Material(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 18),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 15,
                            color: isMe ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                      color: isMe ? kPrimaryColor : Colors.white,
                      elevation: 5,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    Visibility(
                      visible: lastMessage && !isMe,
                      child: Positioned(
                        left: -12,
                        bottom: -20,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x30000000),
                                blurRadius: 1.0,
                                spreadRadius: 1,
                              ),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            child: ClipRRect(
                              child: Image.asset(
                                photoURL ?? 'assets/images/user.png',
                                fit: BoxFit.contain,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            backgroundColor: Colors.white,
                            radius: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget image(
      {String photoURL, String imageURL, bool isMe, bool lastMessage}) {
    return Padding(
      padding: isMe
          ? EdgeInsets.fromLTRB(80, 0, 0, lastMessage ? 20 : 10)
          : EdgeInsets.fromLTRB(0, 0, 80, lastMessage ? 20 : 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 1.0,
                          spreadRadius: 0.25,
                        ),
                      ],
                      color:
                          isMe ? kPrimaryColor.withOpacity(0.75) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      imageURL,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Visibility(
                    visible: lastMessage && !isMe,
                    child: Positioned(
                      left: -12,
                      bottom: -10,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x30000000),
                              blurRadius: 1.0,
                              spreadRadius: 1,
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          child: ClipRRect(
                            child: Image.asset(
                              photoURL ?? 'assets/images/user.png',
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          backgroundColor: Colors.white,
                          radius: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget sticker(
      {String photoURL, String stickerURL, bool isMe, bool lastMessage}) {
    return Padding(
      padding: isMe
          ? EdgeInsets.fromLTRB(80, 0, 0, lastMessage ? 20 : 10)
          : EdgeInsets.fromLTRB(0, 0, 80, lastMessage ? 20 : 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      stickerURL,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Visibility(
                    visible: lastMessage && !isMe,
                    child: Positioned(
                      left: -12,
                      bottom: -10,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x30000000),
                              blurRadius: 1.0,
                              spreadRadius: 1,
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          child: ClipRRect(
                            child: Image.asset(
                              photoURL ?? 'assets/images/user.png',
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          backgroundColor: Colors.white,
                          radius: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
