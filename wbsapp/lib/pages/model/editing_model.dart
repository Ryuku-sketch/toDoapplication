import 'package:flutter/material.dart';
import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/Universal_Function/data_management.dart';
import 'package:wbsapp/Universal_Function/logger_management.dart';
import 'package:wbsapp/value_config/layout_config.dart';


class EditingModel {
  // Controllers
  final DataManagement dataManager = DataManagement();
  final LoggerManager logger = LoggerManager();
  final DataApplication dataApplication = DataApplication();

  // Method: Controls changes are actually saved once not multiple times
  void changeEvaluator(String newProject, String newInputDes,
      Map<int, List<TextEditingController>> taskControllerList) {
    final Map<String, List<dynamic>> newDetailsTask = _taskInfoStore(
        taskControllerList);
    final bool _savableFlag = detectChanges(newProject,
        dataApplication.dataRepository);
    // Start saving
    if (_savableFlag) {
      final ProjectData projectData = ProjectData(newProject, newInputDes,
          newDetailsTask);
      dataManager.storeProject(projectData);
    }
    else {
      logger.d('Denied');
    }
  }

  // Method Evaluate a new input of the list whether changes are made
  bool detectChanges(String newInputList, List<ProjectData> model) {
    List<String> projectName = [];
    if (model.length != 0) {
      for (ProjectData project in model) {
        projectName.add(project.project!);
      }
      logger.d('Detect Change Result: ${!projectName.contains(newInputList)}');
      // Compare a new project added with stored project
      return !projectName.contains(newInputList);
    }
    return true;
  }

  // Method: Fetch TEC inputs to store data
  Map<String, List<dynamic>> _taskInfoStore(
      Map<int, List<TextEditingController>> taskControllerList) {
    Map<String, List<dynamic>> taskList = {};
    int _index = 0;
    bool _controllerIsEmpty = true;

    // Investigate the controller is not empty
    taskControllerList.values.forEach((element) {
      element.forEach((eachController) {
        if(eachController.text.isNotEmpty){
          _controllerIsEmpty = false;
        }
      });
      // fetch inputs from controller list and passes onto Saving list
      if (!_controllerIsEmpty){
        taskList[_index.toString()] = [];


        // Iterate to store inputs to the data model
        for (int i = 0; i < 4; i++) {
          String newInput;
          if (i == taskCompose.estimation){
            newInput = element[i].text.isNotEmpty ? element[i].text: '0';
          } else {
            newInput = element[i].text.isNotEmpty ? element[i].text: '';
          }

          taskList[_index.toString()]!.add(newInput);

          // Add Extra Status
          if (i == 3){
            // Done Flag
            taskList[_index.toString()]!.add(false);
            // current Progress
            taskList[_index.toString()]!.add('');
          }

        }
        _index ++;
        _controllerIsEmpty = true;
      }
    });

    // if the list is empty, put the default one
    if (taskList.isEmpty){
      taskList = {'0': ['', '', '0', '', false, '']};
    }

    return taskList;
  }

  // Method: Add new controllers for increasing number of task inputs
  void addTaskController(
      Map<int, List<TextEditingController>> taskControllers) {
    try {
      // Controllers for task info
      /// 1st input: title
      /// 2nd input: description
      /// 3rd input: estimated time
      /// 4th input: due
      final List<TextEditingController> newControllers = [
        TextEditingController(), TextEditingController(),
        TextEditingController(), TextEditingController(),
      ];
      taskControllers[taskControllers.keys.length] = newControllers;
    } catch (e) {
      logger.e('Edit Page: Adding controller error: $e');
    }
  }
}
