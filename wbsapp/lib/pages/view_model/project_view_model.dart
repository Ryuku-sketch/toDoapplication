
import 'package:flutter/material.dart';
import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/pages/model/project_model.dart';
import 'package:wbsapp/universal_function/logger_management.dart';

class ProjectViewModel{
  final ProjectModel model = ProjectModel();
  final LoggerManager logger = LoggerManager();


  List<String> taskList = [];
  List<dynamic> taskDetailList = [];
  List<bool> taskDueOver = [];
  List<Widget> editEntryChannel = [];
  bool editable = false;
  bool recordable = false;
  bool taskIsEmpty = false;
  TextEditingController projectController = TextEditingController();
  TextEditingController descController  = TextEditingController();

  Map<int, List<TextEditingController>> taskController ={
    0: [
      // Task Title
      TextEditingController(),
      // Task Description
      TextEditingController(),
      // Estimated Time
      TextEditingController(),
      // Due
      TextEditingController(),
      // CurrentProgress
      TextEditingController(),
    ]
  };
  Map<int, List<TextEditingController>> newTaskController = {
    0 : [
      // Task Title
      TextEditingController(),
      // Task Description
      TextEditingController(),
      // Estimated Time
      TextEditingController(),
      // Due
      TextEditingController(),
      // CurrentProgress
      TextEditingController(),
    ]
  };
  void controllerInitialize(){
    newTaskController = {
      0 : [
        // Task Title
        TextEditingController(),
        // Task Description
        TextEditingController(),
        // Estimated Time
        TextEditingController(),
        // Due
        TextEditingController(),
        // CurrentProgress
        TextEditingController(),
      ]
    };
  }

  // Clean up all the list
  void taskInitializer(){
    taskList = [];
    taskDetailList = [];
    taskDueOver = [];
  }

  // Get necessary values for displaying
  void setList(ProjectData project){
    taskInitializer();
    model.getTaskList(project, taskList, taskDetailList, taskDueOver, taskIsEmpty);
    model.getTaskControllers(project.taskWithDetail.keys.length, taskController);
  }

  // Dispose all controllers
  void onDestroy() {
    projectController.dispose();
    descController.dispose();
    taskController.clear();
  }

  // Run the saving function if the existing task is edited
  void saveChanges(ProjectData projectData, DataApplication dataRepo){
    model.storeChanges(projectData, projectController,
        descController, taskController,taskList, dataRepo, (recordable && !editable));
    recordable = false;
    editable = false;
  }

  // Investigate changes and run the saving function
  void detectChanges(ProjectData projectData, DataApplication dataRepo){
    model.newTaskChangeDetector(newTaskController, projectData, dataRepo);
    model.newControllerDispose(newTaskController, editEntryChannel);
  }

  // Destroying created a created widget and controllers
  void cancel(){
    // Reset all the editable mode
    editable = false;
    recordable = false;
    model.newControllerDispose(newTaskController, editEntryChannel);
  }

  // Update the task status
  void taskCompletion(ProjectData projectData, DataApplication dataRepo){
    model.initSaving(projectData, dataRepo, projectData.project!);
  }

  // Expand new task entry channels
  void addControllers(Widget _newEditChannel){
    model.injectNewControllers(newTaskController);
    editEntryChannel.add(_newEditChannel);
  }

}