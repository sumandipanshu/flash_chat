import 'package:flash_chat/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    @required this.onPressed,
    this.color,
    this.text,
    this.focusNode,
    this.child,
    this.borderColor,
  });
  final String text;
  final Color color;
  final Function onPressed;
  final FocusNode focusNode;
  final Widget child;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: onPressed != null ? 5 : 0,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: onPressed != null
            ? BorderSide(width: 1, color: borderColor ?? kPrimaryColor)
            : BorderSide.none,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          minWidth: 200,
          height: 42,
          focusNode: focusNode,
          onPressed: onPressed,
          child: child ??
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
        ),
      ),
    );
  }
}
