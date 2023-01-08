
import 'package:flutter/material.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class EditBox extends StatelessWidget{
  EditBox(this.title, this.controller, this.maxWord, this.specifiedLines);

  String title;
  TextEditingController controller;
  int maxWord;
  int specifiedLines;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: editPage.editBoxWidth,
        child :Column(
          children: [
            Row(
              children: [
                const SizedBox(width: editPage.subtitleLeftMargin),
                Container(
                    width: editPage.textBoxWidth,
                    alignment: Alignment.center,
                    child: TextField(
                        controller:controller,
                        maxLength: maxWord,
                        maxLines: specifiedLines,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                          hintText: title,
                        ),
                    ),
                ),
              ],),
            Padding(padding:editPage.editBoxBottomMargin)
          ],));
  }

}