import 'dart:core';

class ProjectData{
  ProjectData(
    this.project,
    this.description,
    this.taskWithDetail
    );
  String? project;
  String? description;

  // Format: taskWidthDetail[index] =
  //  {Task, Description, EstimatedTime, Due, doneFlag, progressTime}
  Map<String, dynamic> taskWithDetail = {};


  // When decode from the json, automatically assign values to variables
  ProjectData.fromJson(Map<String, dynamic> json){
       project = json['project'];
        description = json['description'];
        taskWithDetail = json['taskWithDetail'];
  }

  // Specify a format in order to covert this object into json
  Map<String, dynamic> toJson(){
    return {
    'project':project,
    'description': description,
    'taskWithDetail': taskWithDetail,
    };

  }
}
