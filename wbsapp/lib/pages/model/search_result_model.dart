

import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/universal_function/logger_management.dart';

class SearchResultModel {
  final LoggerManager logger = LoggerManager();

  // Method: Find matched projects
  List<String> search(String _searchTarget, List<ProjectData> _dataRepo) {
    final List<String> _searchResult = [];

    for (final project in _dataRepo){
      final String _match = project.project!.contains(_searchTarget)
          ? project.project! : '';
      if (_match.isNotEmpty) {
        _searchResult.add(_match);
      }
    }
    return _searchResult;
  }
}