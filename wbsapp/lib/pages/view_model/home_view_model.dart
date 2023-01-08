import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/pages/model/home_model.dart';

class HomeViewModel{
  final HomeModel model = HomeModel();
  final DataApplication dataApplication = DataApplication();

  List<String> taskList =[];
  List<dynamic> taskDescList = [];
  List<String> projectName = [];
  List<double> progressValues = [];
  List<int> daysLeft = [];

  // Initialize the variables
  void init(){
    taskList = [];
    taskDescList = [];
    projectName = [];
    daysLeft = [];
    progressValues = [];
  }

  // Create a tasks list for displaying Due task
  void getTodayTaskList(ProjectData project){
    model.todayProjectDetector(project,taskList, taskDescList,
        projectName, daysLeft);
  }

  // Calculate the percentage of the task progress
  void progressCalculation(ProjectData project) {
    progressValues.add(model.estimatedTimeProgress(project));
  }

  // Change the status of a task and Save that change
  void changeStatus(String project, String task){
    model.taskDone(project, task, dataApplication.dataRepository);
  }

  // Check a project is completed
  double checkCompletion(double progress, ProjectData _projectData){
    return model.checkProjectCompleted(progress, _projectData);
  }
}