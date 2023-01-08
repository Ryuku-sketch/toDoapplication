import 'package:intl/intl.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/universal_function/data_management.dart';
import 'package:wbsapp/universal_function/logger_management.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class HomeModel{
  final LoggerManager logger = LoggerManager();
  final DataManagement dataManagement = DataManagement();

  // Method: Store near due tasks to list
  void todayProjectDetector(ProjectData project,
      List<String> taskList,
      List<dynamic> taskDescList,
      List<String> projectName,
      List<int> daysLeft,
      ){
    project.taskWithDetail.forEach((index, details) {
      try {
        // Display if the task is not completed
        if (!project.taskWithDetail[index][4] &&
            project.taskWithDetail[index][3].isNotEmpty) {

          int calculatedDays;
          final _date = DateTime.now();
          // Get days only: Using default datetime will distort the comparison
          final String _today = DateFormat('dd').format(_date);
          final String _month  = DateFormat('MM').format(_date);
          final String _year = DateFormat('yyyy').format(_date);
          final String _dueDate =  DateFormat('dd').format(
              DateTime.parse(project.taskWithDetail[index][3]));
          final String _dueMonth =  DateFormat('MM').format(
              DateTime.parse(project.taskWithDetail[index][3]));

          if (int.parse(_dueMonth) > int.parse(_month)){
            // Calculate for days remain when the due is on the another month
            // Get the last day of this_month
            final _lastDay =  DateFormat('dd').format(DateTime(int.parse(_year), int.parse(_month) + 1, 0));
            calculatedDays = (int.parse(_today) - (int.parse(_lastDay) + int.parse(_dueDate))) * -1;
          } else if (int.parse(_dueMonth) < int.parse(_month)){
            // Calculate for the overdue task
            // Get the last day of the due month
            final _lastDay =  DateFormat('dd').format(DateTime(int.parse(_year), int.parse(_dueMonth) + 1, 0));
            calculatedDays = ((int.parse(_lastDay) + int.parse(_today)) - ( int.parse(_dueDate))) * -1;
          } else {
            // Negative means that the dueDate is in the past
            // Compare today and dueDate
            calculatedDays = (int.parse(_today) - int.parse(_dueDate)) * -1;
          }

          // Include only due within 4 days task
          if (calculatedDays <= 4) {
            taskList.add(details[0]);
            taskDescList.add(details[1]);
            projectName.add(project.project!);
            daysLeft.add(calculatedDays);
          }
        }
      } catch (e) {
        logger.e('HomePage: Due left calculation error: $e');
      }
    });

    logger.d('Added Tasks: $taskList / Description: $taskDescList / Days: $daysLeft');
  }

  // Method: Calculate the current progress
  double estimatedTimeProgress(ProjectData projectData){
    List<double> totalEstimatedTime = [];
    List<double> completedTaskTime = [];
    double _currentProgress = 0;
    projectData.taskWithDetail.values.forEach((taskDetail) {
      if (taskDetail[taskCompose.estimation] != null
          && taskDetail[taskCompose.estimation].isNotEmpty
          && taskDetail[taskCompose.estimation] != 0){
        totalEstimatedTime.add(double.parse(taskDetail[taskCompose.estimation]));
      }

      // Look for the completed task's estimation time for a progress indicator
      if (taskDetail[taskCompose.taskCompletion]
          && taskDetail[taskCompose.estimation].isNotEmpty){
        completedTaskTime.add(double.parse(taskDetail[taskCompose.estimation]));
      } else if (taskDetail[taskCompose.currentProgress].isNotEmpty){
        double _adjustedProgress = double.parse(
            taskDetail[taskCompose.currentProgress]) > double.parse(taskDetail[taskCompose.estimation])
            ? double.parse(taskDetail[taskCompose.estimation])
            : double.parse(taskDetail[taskCompose.currentProgress]);
        completedTaskTime.add(_adjustedProgress);
      }
    });

    // Check for not putting any estimated values
    if (totalEstimatedTime.isEmpty){
      return _currentProgress;
    }
    if (completedTaskTime.isEmpty){
      completedTaskTime.add(0);
    }

    // Calculate the progress
    // Sum(CompletedTask) / Sum(TotalTime)
    _currentProgress = (completedTaskTime.reduce((a, b) => a + b)) /
        totalEstimatedTime.reduce((a, b) => a + b);
    logger.d('Calculated Value => ${_currentProgress.isNaN ? 0 : _currentProgress}');
    return _currentProgress.isNaN || _currentProgress < 0 ? 0 : _currentProgress;
  }

  // Method: Detect whether the project is completed
  double checkProjectCompleted(double _currentProgress, ProjectData _project){
    bool _taskAllCompleted= true;

    // Check if there is uncompleted task
    _project.taskWithDetail.values.forEach((taskDetail) {
      if (!taskDetail[taskCompose.taskCompletion]){
        _taskAllCompleted = false;
      }
    });
    if(_taskAllCompleted){
      return _currentProgress;
    } else {
      // Suggesting uncompleted task is in a stack
      if (_currentProgress >= 100) {
        _currentProgress = 100;
        return _currentProgress -0.1;
      } else {
        return _currentProgress;
      }
    }
  }

  // Method: Complete the task by changing the its status
  void taskDone(String project, String task, List<ProjectData> dataRepo) {
    final int _index = dataRepo.indexWhere(
            (projectData) => projectData.project == project);
    final ProjectData _targetProject = dataRepo[_index];
    final String _taskIndex = _targetProject.taskWithDetail.keys.firstWhere(
            (keys) => _targetProject.taskWithDetail[keys][taskCompose.taskTitle] == task);
    _targetProject.taskWithDetail[_taskIndex][taskCompose.taskCompletion] = true;
    dataManagement.saveChanges(dataRepo);
  }
}