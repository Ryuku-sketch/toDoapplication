import 'package:flutter/material.dart';
import 'package:wbsapp/pages/model/editing_model.dart';
import 'package:wbsapp/universal_function/logger_management.dart';

// Place for transforming and handling data
class EditingViewModel {
  final EditingModel model = EditingModel();
  final LoggerManager logger = LoggerManager();

  // keyboard Controllers
  TextEditingController controllerList = TextEditingController();
  TextEditingController controllerDes = TextEditingController();

  // Task Widget List
  List<Widget> taskWidgetList = [];
  Map<int, List<TextEditingController>> textControllerList = {
    0: [
      // [0]: Title
      TextEditingController(),
      // [1]: Description
      TextEditingController(),
      // [2]: Estimated Time
      TextEditingController(),
      // [3]: Due
      TextEditingController()]};


  void initialize() {
    controllerList.clear();
    controllerDes.clear();
  }

  // Call the change evaluation process for saving
  void saveChanges() {
    model.changeEvaluator(controllerList.text, controllerDes.text,
        textControllerList);
    }

  // Increments the index
  void taskIndexIncrement(){
    model.addTaskController(textControllerList);
  }

  // Add a new controller with an index for TEC
  void getNewTaskWidget(Widget newTaskWidget){
    taskWidgetList.add(newTaskWidget);
  }
}
