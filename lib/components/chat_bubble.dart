import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_chat/global.dart';
import 'package:flutter/material.dart';

class ChatBubble {
  static Widget text({
    BuildContext context,
    bool isMe,
    bool isFirstMessage,
    String messageText,
  }) {
    return Container(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      margin: EdgeInsets.only(
        top: isFirstMessage ? 20 : 0,
        bottom: 10,
        left: isMe
            ? 0
            : isFirstMessage
                ? 0
                : 15,
        right: isMe
            ? isFirstMessage
                ? 0
                : 15
            : 0,
      ),
      child: PhysicalShape(
        clipper: isFirstMessage
            ? Clipper(
                isMe: isMe,
              )
            : RRectClipper(),
        elevation: 5,
        color: isMe ? kPrimaryColor : Colors.white,
        shadowColor: Colors.grey.shade200,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: isMe
                  ? 10
                  : isFirstMessage
                      ? 25
                      : 10,
              right: isMe
                  ? isFirstMessage
                      ? 25
                      : 10
                  : 8),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  (isMe
                      ? isFirstMessage
                          ? 0.65
                          : 0.64
                      : 0.65),
            ),
            child: Text(
              messageText,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget image({
    BuildContext context,
    bool isMe,
    bool isFirstMessage,
    String imageURL,
  }) {
    return Container(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      margin: EdgeInsets.only(
        top: isFirstMessage ? 20 : 0,
        bottom: 10,
        left: isMe
            ? 0
            : isFirstMessage
                ? 0
                : 15,
        right: isMe
            ? isFirstMessage
                ? 0
                : 15
            : 0,
      ),
      child: PhysicalShape(
        clipper: isFirstMessage
            ? Clipper(
                isMe: isMe,
              )
            : RRectClipper(),
        elevation: 5,
        color: isMe ? kPrimaryColor : Colors.white,
        shadowColor: Colors.grey.shade200,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: isMe
                  ? 5
                  : isFirstMessage
                      ? 20
                      : 5,
              right: isMe
                  ? isFirstMessage
                      ? 20
                      : 5
                  : 5),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: CachedNetworkImage(
              imageUrl: imageURL,
              fit: BoxFit.fitWidth,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                      width: 512,
                      height: 512,
                      child: Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress))),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  static Widget sticker({
    BuildContext context,
    bool isMe,
    bool isFirstMessage,
    String stickerURL,
  }) {
    return Container(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      margin: EdgeInsets.only(
        top: isFirstMessage ? 20 : 0,
        bottom: 10,
        left: isMe
            ? 0
            : isFirstMessage
                ? 0
                : 15,
        right: isMe
            ? isFirstMessage
                ? 0
                : 15
            : 0,
      ),
      child: PhysicalShape(
        clipper: isFirstMessage
            ? Clipper(
                isMe: isMe,
              )
            : RRectClipper(),
        elevation: 5,
        color: isMe ? kPrimaryColor : Colors.white,
        shadowColor: Colors.grey.shade200,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: isMe
                  ? 5
                  : isFirstMessage
                      ? 20
                      : 5,
              right: isMe
                  ? isFirstMessage
                      ? 20
                      : 5
                  : 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            child: Image.asset(
              stickerURL,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  final bool isMe;

  Clipper({
    @required this.isMe,
  });

  @override
  Path getClip(Size size) {
    double radius = 10;
    double nipHeight = 10;
    double nipWidth = 15;
    double nipRadius = 3;
    var path = Path();

    if (isMe) {
      path.lineTo(size.width - nipRadius, 0);
      path.arcToPoint(Offset(size.width - nipRadius, nipRadius),
          radius: Radius.circular(nipRadius));
      path.lineTo(size.width - nipWidth, nipHeight);
      path.lineTo(size.width - nipWidth, size.height - radius);
      path.arcToPoint(Offset(size.width - nipWidth - radius, size.height),
          radius: Radius.circular(radius));
      path.lineTo(radius, size.height);
      path.arcToPoint(Offset(0, size.height - radius),
          radius: Radius.circular(radius));
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    } else {
      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius));
      path.lineTo(size.width, size.height - radius);
      path.arcToPoint(Offset(size.width - radius, size.height),
          radius: Radius.circular(radius));
      path.lineTo(radius + nipWidth, size.height);
      path.arcToPoint(Offset(nipWidth, size.height - radius),
          radius: Radius.circular(radius));
      path.lineTo(nipWidth, nipHeight);
      path.lineTo(nipRadius, nipRadius);
      path.arcToPoint(Offset(nipRadius, 0), radius: Radius.circular(nipRadius));
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class RRectClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 10;

    Path path = Path()
      ..addRRect(RRect.fromLTRBR(
          0, 0, size.width, size.height, Radius.circular(radius)))
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
