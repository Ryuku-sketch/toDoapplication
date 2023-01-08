import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/Universal_Function/logger_management.dart';

/// task: Projects
/// description: Projects description

// Model: Handle data
class DataManagement {
  // Instantiate SharedPreference
  static final DataManagement _instance = DataManagement._internal();

  factory DataManagement(){
    return _instance;
  }

  DataManagement._internal();

  static SharedPreferences? _getInfo;
  final LoggerManager logger = LoggerManager();
  final DataApplication dataApplication = DataApplication();


  // initialize the instances
  static Future<SharedPreferences> initialize() async {
    _getInfo = await SharedPreferences.getInstance();
    return _getInfo!;
  }

  // Method: Saving a project that is first created
  void storeProject(ProjectData project) async {
    // insert a new data to synchronize the operation with presentation layer
    dataApplication.dataRepository.add(project);

    // save the data for the later use
    String _value = jsonEncode(project);
    dataApplication.saveRepository.add(_value);
    _getInfo!.setStringList('ProjectList', dataApplication.saveRepository);
    logger.i('Task Saved');
    logger.i('added/ ${dataApplication.saveRepository.last}');
  }

  // Load Project data
  Future<void> loadProject() async {
    try{
      if (_getInfo == null){
        await initialize();
      }
      final _value = _getInfo!.getStringList('ProjectList');

      // the taskList is empty, return with the empty list
      if(_value == null){
        dataApplication.dataRepository = [];
      } else {
        _value.forEach((element) {
          Map<String, dynamic> json = jsonDecode(element);
          ProjectData projectData = ProjectData.fromJson(json);

          // make a synchronization of data
          // add both repositories to match all project data for later storing task
          dataApplication.saveRepository.add(element);
          dataApplication.dataRepository.add(projectData);
        });
        logger.i('Task Loaded/ ${dataApplication.dataRepository} '
            'with length of ${dataApplication.dataRepository.length}');
      }
    } catch(e){
     logger.e('Loading Error: $e');
    }
  }

  // Method: Saving modifications after a project is created
  void saveChanges(List<ProjectData> _projectData) async {
    try{
      // Initialize SharedPreference instance
      if (_getInfo == null){
        await initialize();
      }
      // initialize the sava repository
      dataApplication.saveRepository = [];

      // Modified data should be converted to Savable format
      _projectData.forEach((element) {
        String _projectData = jsonEncode(element);
        dataApplication.saveRepository.add(_projectData);
      });
      logger.d('Save repo ==> ${dataApplication.saveRepository}');
      _getInfo!.setStringList('ProjectList', dataApplication.saveRepository);
      logger.d('Change saved');
    } catch(e) {
      logger.e('Error: $e');
    }
  }

}