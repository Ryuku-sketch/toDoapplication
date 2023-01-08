

import 'package:wbsapp/Data/data_repository/project_data.dart';

class DataApplication{

  static final DataApplication _instance = DataApplication._internal();

  factory DataApplication(){
    return _instance;
  }

  DataApplication._internal();

  void initialize(){
    dataRepository = [];
    saveRepository = [];
  }

  List<ProjectData> dataRepository = [];
  List<String> saveRepository = [];

}