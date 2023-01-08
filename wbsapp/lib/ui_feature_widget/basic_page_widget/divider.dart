

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class DividerWidget extends StatelessWidget{
  DividerWidget(this.widthSize, this.widgetColor);
  double widthSize;
  Color widgetColor;

  @override
  Widget build(BuildContext context){
    return Container(
      width: widthSize,
      decoration: BoxDecoration(
        // put color of the Container
        color: ColorConfig.primaryWidgetColor,
        // Specifies the color of border
        border: Border(
            top: BorderSide(width: 0.5,  color: widgetColor)),
      ),
    );
  }
}