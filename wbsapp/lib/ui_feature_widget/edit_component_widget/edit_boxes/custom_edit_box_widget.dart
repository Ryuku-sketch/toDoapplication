

import 'package:flutter/material.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class CustomEditBox extends StatelessWidget{
  CustomEditBox(this.title, this.controller, this.widthSize);

  String title;
  TextEditingController controller;
  double widthSize;
  TextInputType _keyboardInput = TextInputType.number;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widthSize,
        child :Column(
          children: [
            Row(
              children: [
                Container(
                    width: widthSize,
                    alignment: Alignment.center,
                    child: TextField(
                      controller:controller,
                      keyboardType: _keyboardInput,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        hintText: title,
                      ),)),],),
            Padding(padding:editPage.editBoxBottomMargin)
          ],),
    );
  }

}