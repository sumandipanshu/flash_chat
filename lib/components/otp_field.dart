import 'package:flash_chat/global.dart';
import 'package:flutter/material.dart';

class OTPField extends StatelessWidget {
  OTPField({
    this.focusNode,
    this.controller,
    this.backgroundColor,
    this.onTap,
    this.autofocus,
    this.bottomBorderColor,
    this.onChanged,
    this.onEditingComplete,
  });

  final Color backgroundColor, bottomBorderColor;
  final Function onChanged, onTap, onEditingComplete;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus ?? false,
        focusNode: focusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: kPrimaryColor,
        cursorHeight: 25,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          hintText: '',
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: bottomBorderColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 3, color: bottomBorderColor),
          ),
        ),
        onChanged: onChanged,
        onTap: onTap,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
