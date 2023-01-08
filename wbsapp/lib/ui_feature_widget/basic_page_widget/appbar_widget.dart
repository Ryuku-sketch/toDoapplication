import 'package:flutter/material.dart';
import 'package:wbsapp/pages/view/editing_page.dart';
import 'package:wbsapp/pages/view/search_result_view.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {

  @override
  Widget build(BuildContext context){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        IconButton(
          icon: appBarItem.searchIcon,
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return SearchResult();
              }),
            );
          },
        ),
        IconButton(
          icon:appBarItem.newProjectIcon,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditingPage();
            })
            );
          },)],
      elevation: 0,
    );
  }

  AppBar mainAppBar(BuildContext context){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        IconButton(
          icon: appBarItem.searchIcon,
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return SearchResult();
              }),
            );
          },
        ),
        IconButton(
          icon:appBarItem.newProjectIcon,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditingPage();
            })
            );
          },)],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}