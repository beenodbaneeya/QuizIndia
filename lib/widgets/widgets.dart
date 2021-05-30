import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_india/services/colors.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(
            text: 'Quiz',
            style: TextStyle(
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  color: Colors.white,
                )
              ],
              fontWeight: FontWeight.bold,
              color: Color(0xffff0057),
            )),
        TextSpan(
            text: ' India',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
      ],
    ),
  );
}

BoxDecoration myBoxDecoration1(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        secondaryColor,
        accentColor,
      ],
    ),
  );
}
