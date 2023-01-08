
import 'package:flutter/material.dart';
import 'package:wbsapp/pages/view/home_page.dart';
import 'package:wbsapp/pages/view_model/search_result_view_model.dart';
import 'package:wbsapp/ui_feature_widget/basic_page_widget/divider.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final SearchResultViewModel model = SearchResultViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Search Project',
          style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: ColorConfig.primaryBackground,
        child: Column(
          children: [
            _searchBar(),
            _resultView(context),
          ],
        ),
      ),
    );
  }

  // Widget: Display the search bar
  Widget _searchBar(){
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: searchPage.searchBarMargin,
      child: TextField(
        controller:model.searchController,
       textInputAction:  TextInputAction.go,
        onSubmitted: (String value) {
          model.search(value);
          },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
        ),
      ),
    );
  }


  // Widget: Show the history of search
  Widget _showResult(BuildContext context, List<String> _listView, bool nonWordFlag){
    if (_listView.isEmpty && nonWordFlag) {
      return Column(
        children: [
          DividerWidget(searchPage.totalResultViewWidth,
              ColorConfig.customBorderColor),
          Container(
              height: searchPage.notFoundCaseHeight,
              padding: searchPage.noFoundCasedMargin,
              child: searchPage.noFoundCaseWord,
          )
        ],
      );
    }
    return Container(
      height: searchPage.resultWidgetHeight,
      width: searchPage.resultWidgetWidth,
      child: ListView.builder(itemCount: _listView.length,
          itemBuilder: (context, index){
        return Column(
          children: [
            DividerWidget(searchPage.totalResultViewWidth,
                ColorConfig.customBorderColor),

            Container(
                height: searchPage.taskNameHeight,
                alignment: Alignment.centerLeft,
                child: Text('${_listView[index]}')
            ),
            DividerWidget( searchPage.totalResultViewWidth,
                ColorConfig.customBorderColor),
          ]
        );
      }
      )
    );
  }

  Widget _resultView(BuildContext context){
    return Container(
        height: searchPage.totalResultViewHeight,
        width: searchPage.totalResultViewWidth,
        child: Column(
            children:[
              Container(
                padding: searchPage.resultViewHintTextMargin,
                child: searchPage.hitWording,
              ),
              _showResult(context, model.newHit, true),
              DividerWidget( searchPage.totalResultViewWidth,
                  ColorConfig.customBorderColor),
              Container(
                  padding: searchPage.resultViewHintTextMargin,
                  child: searchPage.historyWording
                  ),
              _showResult(context, model.resultHistory, false),
            ]
        )
    );
  }
}