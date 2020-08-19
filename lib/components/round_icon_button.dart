import 'package:flash_chat/global.dart';
import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    @required this.onPressed,
    @required this.icon,
    this.fillColor,
    this.radius,
    this.padding,
    this.size,
    this.iconColor,
  });

  final Function onPressed;
  final IconData icon;
  final Color fillColor, iconColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.only(left: 4),
      child: IconButton(
        iconSize: 30,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: size ?? 30,
        ),
      ),
      width: radius ?? 50,
      height: radius ?? 50,
      decoration: BoxDecoration(
        color: (fillColor ?? kSecondaryColor).withOpacity(0.75),
        shape: BoxShape.circle,
      ),
    );
  }
}
