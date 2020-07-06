import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  ReusableText({@required this.text, this.colour, this.fsize});

  final String text;
  final Color colour;
  final double fsize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: colour,
        fontSize: fsize,
      ),
    );
  }
}
