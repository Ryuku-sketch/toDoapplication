
import 'package:flutter/material.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class DismissedContainer extends StatelessWidget{
  DismissedContainer(this.text, this.insideColor, this.textPosition);
  final String text;
  final Color insideColor;
  final Alignment textPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: textPosition,
      color: insideColor,
      padding: homePage.dismissedTextPadding,
      child: Text(text,
        style: TextStyle(color: ColorConfig.swipeTaskColor),)
    );
  }
}