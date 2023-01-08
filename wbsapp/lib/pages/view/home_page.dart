import 'package:flutter/material.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/pages/view/project_page.dart';
import 'package:wbsapp/pages/view_model/home_view_model.dart';
import 'package:wbsapp/ui_feature_widget/basic_page_widget/appbar_widget.dart';
import 'package:wbsapp/ui_feature_widget/basic_page_widget/divider.dart';
import 'package:wbsapp/ui_feature_widget/home_component_widget/home_dismissed_widget.dart';
import 'package:wbsapp/universal_function/logger_management.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class HomePage extends StatefulWidget {
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final HomeViewModel model = HomeViewModel();
  final LoggerManager logger = LoggerManager();

  @override
  void initState() {
    super.initState();
    setState(() {
      model.init();
      if (model.dataApplication.dataRepository.length > 0) {
        for (ProjectData project in model.dataApplication.dataRepository) {
          model.progressCalculation(project);
          model.getTodayTaskList(project);
        }
      } else {
        // Default value for the progress bar
        model.progressValues.add(0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      if (model.dataApplication.dataRepository.isNotEmpty) {
        model.init();
        for (ProjectData project in model.dataApplication.dataRepository) {
          model.progressCalculation(project);
          model.getTodayTaskList(project);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        color: ColorConfig.primaryBackground,
        alignment: Alignment.topCenter,
        child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: homePage.homePageAdjustPadding),
                  _projectCardWidget(
                      model.dataApplication.dataRepository.length),
                  Padding(padding: homePage.homePageAdjustPadding),
                  _toDayTaskView(context),
                  Padding(padding: homePage.homePageAdjustPadding),
                ],
              ),
            )),
      ),
    );
  }

  // Widget: Switch based on available project saved
  Widget _toDayTaskView(BuildContext context) {
    return model.taskList.length > 0
        ? _closeDueTaskWidget(_taskListView(context), homePage.todayHeight)
        : _closeDueTaskWidget(_noTaskWidget(), homePage.noTaskHeight);
  }

  // Widget: Construct Close Due Task Component
  Widget _closeDueTaskWidget(Widget taskWidget, double widgetHeight) {
    return Container(
      height: widgetHeight,
      width: homePage.todayWidth,
      padding: editPage.decorationSurroundedMargin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BasicWidget.basicBorder,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: homePage.todayTitlePadding,
                  child: homePage.taskCloseDue,
                ),
                DividerWidget(dividerWidget.dividerHomeWidth, Colors.black54),
                taskWidget,
                DividerWidget(dividerWidget.dividerHomeWidth, Colors.black54),
                Padding(padding: homePage.littleAdjustPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget: Display default widget
  Widget _noTaskWidget() {
    return Container(
        padding: homePage.noneTaskPadding,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            homePage.noTaskText,
            const SizedBox(
              height: 197,
            )
          ],
        ));
  }

  // Widget: Display each tasks details
  Widget _taskListView(BuildContext context) {
    return Container(
        child: ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.taskList.length,
      itemBuilder: (context, index) {
        return Visibility(
          visible: model.taskList.length > 0,
          child: Dismissible(
            background: DismissedContainer(homePage.completionText,
                ColorConfig.completeColor, Alignment.centerLeft),
            onDismissed: (direction) {
              setState(() {
                model.changeStatus(
                    model.projectName[index], model.taskList[index]);
                // Remove done task data from the list
                model.taskList.remove(model.taskList[index]);
                model.taskDescList.remove(model.taskDescList[index]);
                model.daysLeft.remove(model.daysLeft[index]);
              });
            },
            key: ValueKey<String>(model.taskList[index]),
            child: Column(
              children: [
                DividerWidget(dividerWidget.dividerHomeWidth,
                    ColorConfig.taskBorderColor),
                Container(
                    height: homePage.dueTaskTitleHeight,
                    padding: homePage.dueTaskTitlePadding,
                    alignment: Alignment.topLeft,
                    child: Text('${model.taskList[index]}',
                        style: homePage.homeMainWord)),
                _daysLeft(model.daysLeft[index]),
                const SizedBox(height: homePage.dueTitleMargin),
                _closeDueTaskDetail(
                    model.taskDescList[index], model.projectName[index]),
                DividerWidget(dividerWidget.dividerTaskList,
                    ColorConfig.customBorderColor),
              ],
            ),
          ),
        );
      },
    ));
  }

  // Widget: Construct details of task
  Widget _closeDueTaskDetail(String _description, String _project) {
    if (_description.isEmpty) {
      return Container(
        height: homePage.dueTaskDetailHeight,
        child: Column(children: [
          Container(
            height: homePage.dueDescriptionHeight,
            width: homePage.dueDescriptionWidth,
            decoration: BasicWidget.basicBorder,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: homePage.descriptionIconWidth,
                    padding: homePage.descriptionIconPadding,
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.chevron_right)),
                Container(
                  width: homePage.descriptionWidth,
                  alignment: Alignment.topLeft,
                  padding: homePage.descriptionPadding,
                  child: homePage.noDetail,
                ),
              ],
            ),
          ),
          Container(
            padding: homePage.dueProjectPadding,
            alignment: Alignment.bottomRight,
            child: Text(_project),
          ),
        ]),
      );
    }
    return Container(
      height: homePage.dueTaskDetailHeight,
      child: Column(children: [
        Container(
          height: homePage.dueDescriptionHeight,
          width: homePage.dueDescriptionWidth,
          decoration: BasicWidget.basicBorder,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: homePage.descriptionIconPadding,
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.chevron_right)),
              Container(
                width: homePage.descriptionWidth,
                alignment: Alignment.topLeft,
                padding: homePage.descriptionPadding,
                child: Text(_description),
              ),
            ],
          ),
        ),
        Container(
          padding: homePage.dueProjectPadding,
          alignment: Alignment.bottomRight,
          child: Text(_project),
        ),
      ]),
    );
  }

  // Widget: Construct a day reminder component
  Widget _daysLeft(int _daysLeft) {
    // Create the Days left wording
    String _dayWording =
        _daysLeft <= 0 ? 'Due: Over Due' : 'Due: $_daysLeft Day Left';
    Color _textColor = _daysLeft <= 0 ? Colors.red : Colors.black;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            alignment: Alignment.bottomLeft,
            child: Text(_dayWording,
                style: TextStyle(
                    fontSize: homePage.daysLeftWording, color: _textColor)),
            padding: homePage.dueDaysWarningPadding)
      ],
    );
  }

  // Widget: Display each project card
  Widget _projectCardWidget(int listLength) {
    // stored project is more than 1
    if (listLength > 0) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          color: ColorConfig.primaryBackground,
          padding: homePage.projectCardSidePadding,
          height: homePage.projectCardHeight,
          width: homePage.projectCardSwipeWidth,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: model.dataApplication.dataRepository.length,
              itemBuilder: (context, index) {
                return Container(
                    child: _projectName(
                        model.dataApplication.dataRepository[index], index));
              }),
        ),
      );
    } else {
      return Container(
        child: _defaultCardWidget('Add a New Project'),
      );
    }
  }

  // Widget: Display ProgressBar
  Widget _progressBar(int _index) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: homePage.progressBarWidth,
          child: LinearProgressIndicator(
            value: model.progressValues[_index],
            semanticsLabel: 'Linear progress indicator',
          ),
        ));
  }

  // Widget: Display progress %
  Widget _progressBarMeasure(int _index) {
    final double _currentProgress = model.progressValues[_index].isInfinite
        ? 0
        : model.progressValues[_index];
    double displayProgress = model.dataApplication.dataRepository.isEmpty
        ? 0
        : model.checkCompletion(_currentProgress * 100,
            model.dataApplication.dataRepository[_index]);

    return Container(
        padding: homePage.progressBarMeasurePadding,
        alignment: Alignment.centerRight,
        child: Text('${double.parse(displayProgress.toStringAsFixed(2))}%',
            style: TextStyle(
                fontSize: 12, color: ColorConfig.progressPercentageColor)));
  }

  // Widget: Project Card Content
  Widget _projectName(ProjectData project, int _index) {
    return Container(
      height: homePage.projectCardHeight,
      width: homePage.projectCardWidth,
      color: ColorConfig.primaryWidgetColor,
      padding: editPage.decorationSurroundedMargin,
      child: Card(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: homePage.projectCardTitleHeight,
                  width: homePage.projectCardTitleWidth,
                  padding: homePage.projectCardTitlePadding,
                  alignment: Alignment.centerLeft,
                  child: Text(project.project!, style: homePage.homeMainWord)),
              Container(
                width: 20,
                child: IconButton(
                  iconSize: 25,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProjectPage(project, model.dataApplication)));
                  },
                ),
              ),
            ],
          ),
          Padding(padding: homePage.cardPadding),
          descriptionSpace(project.description!),
          _progressBarMeasure(_index),
          _progressBar(_index),
          Padding(padding: homePage.cardPadding)
        ]),
      ),
    );
  }

  // Widget: Default Card (dataRepo == null)
  Widget _defaultCardWidget(String projectName) {
    return Container(
      height: homePage.projectCardHeight,
      width: homePage.projectCardWidth,
      color: ColorConfig.primaryWidgetColor,
      padding: editPage.decorationSurroundedMargin,
      child: Card(
        child: Column(children: [
          Container(child: Text(projectName, style: homePage.homeMainWord)),
          const SizedBox(height: 120),
          _progressBarMeasure(0),
          _progressBar(0),
        ]),
      ),
    );
  }

  // Widget: Display description
  Widget descriptionSpace(String _description) {
    _description = _description.isNotEmpty ? _description : 'No Detail';

    return Container(
        height: homePage.projectCardDesHeight,
        width: homePage.projectCardDesWidth,
        padding: homePage.descriptionPadding,
        decoration: BoxDecoration(
          color: ColorConfig.primaryWidgetColor,
          border: Border.all(color: ColorConfig.customBorderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: homePage.descriptionIconPadding,
                alignment: Alignment.topLeft,
                child: Icon(Icons.chevron_right)),
            Container(
              width: homePage.projectCardDesContentWidth,
              alignment: Alignment.topLeft,
              padding: homePage.descriptionPadding,
              child: Text(_description),
            ),
          ],
        ));
  }
}
