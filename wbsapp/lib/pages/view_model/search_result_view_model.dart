
import 'package:flutter/material.dart';
import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/pages/model/search_result_model.dart';
import 'package:wbsapp/universal_function/logger_management.dart';

class SearchResultViewModel {
  final SearchResultModel model = SearchResultModel();
  final DataApplication dataApplication = DataApplication();
  final LoggerManager logger = LoggerManager();
  final TextEditingController searchController = TextEditingController();


  // List: Display the hit history
  final List<String> resultHistory = [];
  // List: Display the current hit project
  List<String> newHit = [];

  // List all the matched project name with the input
  void search(String _word){
    _managePreviousSearchResult(_word);
    newHit.addAll(model.search(_word, dataApplication.dataRepository));
  }

  // Private Method: Reorganize the hit and history list
  void _managePreviousSearchResult(String _word){
    final List<String> _deleteTarget = [];
    // Get the previous result into resultHistory first
    resultHistory.addAll(newHit);

    // Process the duplicated history with the current input
    for (String _projectName in resultHistory){
      String _delete = _projectName.contains(_word) ? _projectName : '';
      if (_delete.isNotEmpty){
        logger.d('Test: Matched value ==> $_delete');
        _deleteTarget.add(_delete);
      }
    }
    // Removing the matched target
    if (_deleteTarget.isNotEmpty) {
      for (String _delete in _deleteTarget) {
        resultHistory.remove(_delete);
        // If removal is not enough due to duplication, iterates to delete all
        for (String _projectName in resultHistory){
          if (_projectName.contains(_delete)) resultHistory.remove(_delete);
        }
      }
    }
    newHit = []; // initialize the list in order to store the next hit
  }
}