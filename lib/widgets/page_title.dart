import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry margin;
  final Alignment alignment;
  final double fontSize;

  const PageTitle(
    this.text, {
    super.key,
    this.margin = const EdgeInsets.only(top: 60.0, bottom: 20.0, left: 20.0),
    this.alignment = Alignment.bottomLeft,
    this.fontSize = 32.0,
  });

  double getHeight() {
    final marginSize = margin.collapsedSize.height;
    return marginSize + fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      alignment: alignment,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}