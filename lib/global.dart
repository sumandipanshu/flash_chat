import 'package:flutter/material.dart';

const kPrimaryColor = Colors.lightBlueAccent;
const kSecondaryColor = Colors.blueAccent;

const kTextInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Colors.lightBlueAccent),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.lightBlueAccent),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
);

const logoImage = 'assets/images/logo.png';
const IconData sticker =
    IconData(0xe800, fontFamily: 'Sticker', fontPackage: null);
