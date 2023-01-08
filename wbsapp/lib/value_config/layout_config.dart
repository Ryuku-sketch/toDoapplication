import 'package:flutter/material.dart';

///
/// Define all the values for the layout parameters
///
abstract class Res{}
extension BasicWidget on Res{
  static BoxDecoration basicBorder = BoxDecoration(
      color: Colors.white70,
      border: Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(20));
}

extension ColorConfig on Res{
  static Color primaryBackground = Colors.white30;
  static Color primaryWidgetColor = Colors.white70;
  static Color taskBorderColor = Colors.black26;
  static Color customBorderColor = Colors.black12;
  static Color swipeTaskColor = Colors.white;
  // Color for the container when the task is swiped
  static Color completeColor  = Colors.blueAccent;
  static Color editSwipeColor = Colors.green;
  static Color progressPercentageColor = Colors.blue;
  static Color? saveButton = Colors.cyan[50];
  static Color defaultTextColor = Colors.black;
  static Color editTextColor = Colors.black26;
}

extension appBarItem on Res{
  // Icon
  // HomePage AppBar
  static const Icon searchIcon = Icon(
    Icons.search_rounded,
    color: Colors.black,
  );
  static const Icon newProjectIcon =  Icon(
    Icons.add_outlined,
    color: Colors.black,
  );

  // Other Place AppBar
  static const Icon backPageIcon = Icon(Icons.arrow_back_ios);
  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.black, //change your color here
  );
}

extension homePage on Res{
  // Width
  static const double projectCardWidth = 315;
  static const double progressBarWidth = 235;
  static const double todayWidth = 375;
  static const double descriptionIconWidth = 25;
  static const double descriptionWidth = 270;
  static const double dueDescriptionWidth = 315;
  static const double projectCardDesWidth = 240;
  static const double projectCardDesContentWidth = 185;
  static const double projectCardSwipeWidth = 392;
  static const double projectCardTitleWidth = 219;

  // Height
  static const double projectCardHeight = 215;
  static const double todayHeight = 600;
  static const double noTaskHeight = 360;
  static const double dueTaskTitleHeight = 33;
  static const double dueTaskDetailHeight = 140;
  static const double dueDescriptionHeight = 100;
  static const double projectCardDesHeight = 90;
  static const double projectCardTitleHeight = 60;

  // Padding
  static const EdgeInsets dismissedTextPadding = EdgeInsets.all(10.0);
  static const EdgeInsets todayTitlePadding = EdgeInsets.only(bottom: 10.0,
      top: 10.0);
  static const EdgeInsets projectCardSidePadding = EdgeInsets.only(
      left:10, right: 10);
  static const EdgeInsets progressBarMeasurePadding = EdgeInsets.only(
      top: 7, bottom: 2, right: 17);
  static const EdgeInsets homePageAdjustPadding = EdgeInsets.all(20.0);
  static const EdgeInsets littleAdjustPadding = EdgeInsets.all(13.0);
  static const EdgeInsets noneTaskPadding  = EdgeInsets.only(top:30.0,
      bottom: 30.0);
  static const EdgeInsets dueTaskTitlePadding = EdgeInsets.only(
      left: 10, top: 5);
  static const EdgeInsets descriptionIconPadding =EdgeInsets.only(left:5,
      top: 1.5);
  static const EdgeInsets descriptionPadding = EdgeInsets.only(left: 5.0,
      top: 5.0, right: 5.0, bottom: 5.0);
  static const EdgeInsets dueDaysWarningPadding = EdgeInsets.only(bottom: 7,
      left: 15, top: 2);
  static const EdgeInsets dueProjectPadding =  EdgeInsets.only(
      top: 10, bottom: 0, right: 10);

  static const EdgeInsets cardPadding  = EdgeInsets.all(1);
  static const EdgeInsets projectCardTitlePadding  = EdgeInsets.only(
      top: 5, right: 1, left: 5, bottom: 5);

  // SizedBox
  static const double dueTitleMargin = 1.0;

  // Text
  static const String completionText = 'Complete!';
  static const Text taskCloseDue = Text('Close to the due date!!');
  static const Text noTaskText = Text("You're up to date!!",
    style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),);
  static const Text noDetail = Text('No Detail');
  static const TextStyle homeMainWord = TextStyle(fontSize: 22);
  static const  double daysLeftWording = 17;
}

extension editPage on Res{
  // Width: Container
  static const double titleWidth = 400;
  static const double editBoxWidth = 450;
  static const double textBoxWidth = 300;
  static const double saveButtonWidth = 100;
  static const double customBoxWidth = 126;

  // Height: Container
  static const double saveButtonHeight = 50;

  // FontSize
  static const double titleFontSize = 25;
  static const double semiTitleFontSize = 15;
  static const double saveFontSize = 20.0;

  // Padding
  static const EdgeInsets topBottomMargin
    = EdgeInsets.only(top:5, bottom: 25);
  static const EdgeInsets titleLeftMargin = EdgeInsets.only(left: 25);
  static const EdgeInsets adjustedMargin2 = EdgeInsets.all(25);

  static const EdgeInsets editBoxBottomMargin = EdgeInsets.all(12.0);
  static const EdgeInsets decorationSurroundedMargin
    = EdgeInsets.only(left:20, right: 20, bottom: 7);

  // SizedBox

  static const double projectTitleMargin = 25.0;
  static const double adjustedMargin = 10.0;
  static const double subtitleLeftMargin = 25.0;

  // Icon
  static const Icon addIcon = Icon(Icons.add);
  static const Icon removeIcon = Icon(Icons.remove);

  // Text
  static const Text pageTitle = Text('Edit Page',
    style: TextStyle(
        fontSize: editPage.titleFontSize),);
  static const Text addText = Text('Add',
      style: TextStyle(
          fontSize: editPage.saveFontSize)
  );
  static const String addHintText = 'Add a new task';
  static const String removeText = 'Remove the added task';
  static const String subtitleProject = 'Project Title';
  static const String subtitleDescription = 'Description';
  static const String subtitleTask = 'Task';
  static const String subtitleDetail = 'Detail';
  static const String subtitleEstimation = 'Estimation (h)';
  static const String subtitleDue = 'Due: Y/M/D';

  // Text word input param
  // maxLength
  static const int projectWordLength = 25; // Project name input
  static const int projectDescWordLength = 80; // Project desc input
  static const int taskWordLength = 20; // task name input
  static const int taskDescWordLength = 150; // task desc input

  // maxLines
  static const int projectLines = 1;
  static const int projectDescLines = 3;
  static const int taskDescLines = 3;
}

extension dividerWidget on Res{
  static const double dividerEditWidth = 325;
  //Not Fixed
  static const double dividerHomeWidth = 400;
  static const double dividerTaskList = 320;
}

extension searchPage on Res {
  // Height
  static const double notFoundCaseHeight = 50.0; // SearchResult
  static const double resultWidgetHeight = 250.0; // SearchResult
  static const double taskNameHeight = 50.0; // SearchResult
  static const double totalResultViewHeight = 570; // ResultView

  // Width
  static const double resultWidgetWidth = 350.0;
  static const double totalResultViewWidth = 350; // ResultView

  // Text
  static const Text noFoundCaseWord = Text(
      'No Project Matched',); // SearchResult
  static const Text hitWording = Text('Hit',
    style: TextStyle(fontWeight: FontWeight.bold )); // ResultView
  static const Text historyWording = Text('History',
      style: TextStyle(fontWeight: FontWeight.bold )); // ResultView
  // Padding
  static const EdgeInsets searchBarMargin = EdgeInsets.only(top: 25,
      left: 20, right: 20, bottom: 25); // SearchResult
  static const EdgeInsets noFoundCasedMargin = EdgeInsets.only(
      top: 5.0); // SearchResult
  static const EdgeInsets resultViewHintTextMargin = EdgeInsets.only(top:5,
      bottom:5); // ResultView
}

extension projectPage on Res{
  // Height
  static const double descriptionHeight = 100.0;
  static const double newTaskEditHeight = 480.0;
  static const double newTaskTitleHeight = 40;
  static const double editEntryHeight = 417.5;
  static const double editDescHeight = 100.0;
  static const double taskListHeight = 450;
  static const double numberInputHeight = 50.0;

  //Width
  static const double newTaskEditWidth = 450.0;
  static const double taskListWidth = 450;
  static const double checkBoxWidth = 25.0;
  static const double numberInputWidth = 90.0;
  static const double floatingButtonWidth = 120.0;
  static const double newInputExpandButtonWith = 50.0;
  static const double currentProgressWidth = 45.0;
  static const double estimationWidth = 45.0;

  // Padding
  static const EdgeInsets newTaskTitlePadding = EdgeInsets.all(10);
  static const EdgeInsets taskTitlePadding = EdgeInsets.only(top: 10, bottom: 5);

  // Icon ToolTip
  static const String editHint = 'Edit';
  static const String setProgress = 'Record your progress';
  static const Text progressDivider = Text('/ ');

  // Icon
  static const Icon edit = Icon(Icons.edit);

  // Sized Box
  static const double adjustedMargin = 20;
  static const double taskEditEntryMargin = 16.0;
  static const double entryBetweenMargin = 15.0;
  static const double entryEstimationLeftMargin = 16.0;
  static const double entryDueRightMargin = 25.0;
}

// Index for taskDetail
extension taskCompose on Res{
  static const int taskTitle = 0;
  static const int taskDesc = 1;
  static const int estimation = 2;
  static const int dueDate = 3;
  static const int taskCompletion = 4;
  static const int currentProgress = 5;
  static const int progressController = 4;
}