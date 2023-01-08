


import 'package:flutter/material.dart';
import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/universal_function/data_management.dart';
import 'package:wbsapp/universal_function/logger_management.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class ProjectModel{

  final LoggerManager logger = LoggerManager();
  final DataManagement dataModel = DataManagement();


  // Method: Generate lists for displaying tasks
  void getTaskList(ProjectData project, List<String> task,
      List<dynamic> detail, List<bool> dueOver, bool _taskIsEmpty) {
    bool _dueOver = false;

    project.taskWithDetail.values.forEach((taskDetail) {

      // Check Whether this is default list
      for (int i = 0; i < 4; i++){
        if(i != taskCompose.estimation && taskDetail[i].isNotEmpty){
          _taskIsEmpty =  false;
        }
      }

      task.add(taskDetail[taskCompose.taskTitle]);
      detail.add(taskDetail);

      if (taskDetail[taskCompose.dueDate].isEmpty) {
        dueOver.add(false);
      } else {
        final _dueDate = DateTime.parse(taskDetail[taskCompose.dueDate]);
        _dueOver = _dueDate.isBefore(DateTime.now()) ? true : false;
        dueOver.add(_dueOver);
      }
    });
  }

  // Method: Generate text controllers according to a taskList index for the editing purpose
  void  getTaskControllers(int _index,
      Map<int, List<TextEditingController>> taskController) {
    _index = _index - 1;
    final List<TextEditingController> _defaultList = [
      TextEditingController(), TextEditingController(),
      TextEditingController(), TextEditingController(),
      TextEditingController()
    ];
    if (_index > 0 ){
      for (int i = 1; i <= _index; i++ ){
        taskController[i] = _defaultList;
      }
    }
    logger.d('Controllers Added: Keys ===>> ${taskController.keys} // Index => $_index');
  }

  // Method: Detect Changes for stored task and save it
  void storeChanges(ProjectData projectData,
      TextEditingController projectController,
      TextEditingController descController,
      Map<int, List<TextEditingController>> taskController, List<String> taskName,
      DataApplication dataRepo, bool _recordable
      ) {
    
    String _previousProjectName = '';
    // Detect Changes
    if (projectController.text.isNotEmpty){
      // Project Name
      if (projectData.project != projectController.text) {
        _previousProjectName = projectController.text;
        projectData.project = projectController.text;
      }
    }
    // Project Description
    if(descController.text.isNotEmpty){
      projectData.description = projectData.description != descController.text
          ? descController.text : projectData.description;
    }

    // Task Detail
    if (projectData.taskWithDetail.keys.length != 0 &&
        projectData.taskWithDetail.keys.length == taskController.keys.length){

      projectData.taskWithDetail.keys.forEach((index) {
        // Task Title
        if (taskController[int.parse(index)]![taskCompose.taskTitle].text.isNotEmpty &&
            projectData.taskWithDetail[index][taskCompose.taskTitle]
                != taskController[int.parse(index)]![taskCompose.taskTitle].text){
          projectData.taskWithDetail[index][taskCompose.taskTitle] =
              taskController[int.parse(index)]![taskCompose.taskTitle].text;

        }
        // Task description
        if (taskController[int.parse(index)]![taskCompose.taskDesc].text.isNotEmpty &&
            projectData.taskWithDetail[index][taskCompose.taskDesc]
                != taskController[int.parse(index)]![taskCompose.taskDesc].text
        ) {
          projectData.taskWithDetail[index][taskCompose.taskDesc]
          = taskController[int.parse(index)]![taskCompose.taskDesc].text;
        }
        // Estimated Time
        if (_recordable){
          if ( taskController[int.parse(index)]![taskCompose.progressController].text.isNotEmpty &&
              projectData.taskWithDetail[index]![taskCompose.currentProgress]
                  != taskController[int.parse(index)]![taskCompose.progressController].text){
            // Record the current Progress
            projectData.taskWithDetail[index][taskCompose.currentProgress] =
                taskController[int.parse(index)]![taskCompose.progressController].text;
          } else {
            projectData.taskWithDetail[index]![taskCompose.currentProgress] =
              projectData.taskWithDetail[index]![taskCompose.currentProgress].isNotEmpty
                  ? projectData.taskWithDetail[index]![taskCompose.currentProgress] : '0';
          }
        }
        if ( taskController[int.parse(index)]![taskCompose.estimation].text.isNotEmpty &&
            projectData.taskWithDetail[index][taskCompose.estimation]
                != taskController[int.parse(index)]![taskCompose.estimation].text){
          projectData.taskWithDetail[index][taskCompose.estimation] =
              taskController[int.parse(index)]![taskCompose.estimation].text;
        }
        // Due
        if ( taskController[int.parse(index)]![taskCompose.dueDate].text.isNotEmpty &&
            projectData.taskWithDetail[index][taskCompose.dueDate]
                != taskController[int.parse(index)]![taskCompose.dueDate].text){
          projectData.taskWithDetail[index][taskCompose.dueDate] =
              taskController[int.parse(index)]![taskCompose.dueDate].text;
        }
      });

    }
    initSaving(projectData, dataRepo, _previousProjectName);
  }

  // Method: Initiating saving function
  void initSaving(ProjectData projectData, DataApplication dataRepo, String _previousProject){
    // Get an index by using previous project data and replace it with the new data
    if (_previousProject.isNotEmpty){
      final int _index = dataRepo.dataRepository.indexWhere(
              (element) => element.project == _previousProject);
      dataRepo.dataRepository[_index] = projectData;
      dataModel.saveChanges(dataRepo.dataRepository);
    }

  }

  // Method: Incrementing the list size for editing a new task
  void injectNewControllers(
      Map<int, List<TextEditingController>> taskController) {
    final int _index = taskController.keys.length;
    if (_index > 0) {
      taskController[_index] = [
        TextEditingController(), TextEditingController(),
        TextEditingController(), TextEditingController(),
      ];
    }
    logger.d('Controllers Added: Keys ===>> ${taskController.keys}');
  }

  // Method: Detect changes for newly added task and store the changes
  void newTaskChangeDetector(Map<int, List<TextEditingController>> taskController,
      ProjectData projectData, DataApplication dataRepo){
    // Detect Changes
    taskController.forEach((key, value) {
      bool isChange = false;
      value.forEach((element) {
        if (element.text.isNotEmpty) {
          isChange = true;
        }
      });
      // Added a new task to TaskList
      if (isChange) {
        final String _taskName = value[taskCompose.taskTitle].text.isEmpty
            ? '' : value[taskCompose.taskTitle].text;
        final String _taskDesc = value[taskCompose.taskDesc].text.isEmpty
            ? '' : value[taskCompose.taskDesc].text;
        final String _estimatedHour = value[taskCompose.estimation].text.isEmpty
            ? '0' : value[taskCompose.estimation].text;
        final String _due = value[taskCompose.dueDate].text.isEmpty
            ? '' : value[taskCompose.dueDate].text;
        final String _keyIndex = projectData.taskWithDetail.keys.length.toString();
        projectData.taskWithDetail[_keyIndex] = [_taskName, _taskDesc,
          _estimatedHour, _due, false, '0'];
      }
    });

    // Initiate saving the changes
    final int _updateTargetProject = dataRepo.dataRepository.indexWhere(
            (element) => element.project == projectData.project);
    dataRepo.dataRepository[_updateTargetProject] = projectData;
    dataModel.saveChanges(dataRepo.dataRepository);
  }

  // Method: Clear the new task editing channel
  void newControllerDispose(Map<int, List<TextEditingController>> taskController,
      List<Widget> taskEntry){
    // Reset the Widgets / Controllers
    taskController.clear();
    taskEntry.clear();
  }
}