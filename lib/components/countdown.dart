import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation, this.color})
      : super(key: key, listenable: animation);
  final Animation<int> animation;
  final Color color;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      " in $timerText",
      style: TextStyle(
        fontSize: 15,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
