
import 'package:flutter/material.dart';
import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/pages/view_model/project_view_model.dart';
import 'package:wbsapp/ui_feature_widget/basic_page_widget/divider.dart';
import 'package:wbsapp/value_config/layout_config.dart';

class ProjectPage extends StatefulWidget{
  ProjectPage(
      this.project,
      this.dataRepo
      );
  final ProjectData project;
  final DataApplication dataRepo;

  @override
  _ProjectPageState createState() => _ProjectPageState(project, dataRepo);
}

class _ProjectPageState extends State<ProjectPage> {
  _ProjectPageState(
      this.project,
      this.dataRepo
      );
  final ProjectData project;
  final DataApplication dataRepo;

  final ProjectViewModel model = ProjectViewModel();
  @override
  void initState() {
    model.setList(project);
    super.initState();
  }

  @override
  void dispose() {
    model.onDestroy();
    model.editable = false;
    model.recordable = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: changeButtons(),
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            tooltip: projectPage.setProgress,
              onPressed: (){
                setState(() {
                  // Reverse boolean for the recordable mode
                  model.recordable = model.recordable ? false : true;
                  model.editable = false;
                });
              },
          ),
          IconButton(
            icon: projectPage.edit,
            tooltip: projectPage.editHint,
              onPressed: (){
              setState(() {
                // Reverse boolean for the editable mode
                model.editable = model.editable ? false : true;
                model.recordable = model.editable;
              });
              if (model.editEntryChannel.isEmpty || model.newTaskController.isEmpty){
                model.addControllers(_newTaskWidget());}
              },
          )
        ],
        iconTheme: appBarItem.appBarIconTheme
      ),
      body: SingleChildScrollView(
        child:  Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
                children: [
                  SizedBox(
                    height: projectPage.adjustedMargin,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: _textEditBox(model.projectController,
                                model.editable,
                                widget.project.project!, true,true),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: projectPage.adjustedMargin,),
                  Container(
                    height: projectPage.descriptionHeight,
                    color: ColorConfig.primaryBackground,
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.topLeft,
                    child: _descEditBox(model.descController,
                        model.editable, widget.project.description!.isEmpty
                            ? 'No Detail' : widget.project.description!),
                  ),
                  const SizedBox(height: projectPage.adjustedMargin,),
                  const SizedBox(height: projectPage.adjustedMargin,),
                  _taskView(widget.project),
                  const SizedBox(height: projectPage.adjustedMargin,),
                  Visibility(
                    visible: model.editable,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: projectPage.adjustedMargin,),
                        Expanded(child: addTaskController(project)),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: model.editable,
                      child: Container(
                          width: projectPage.newTaskEditWidth,
                          height: projectPage.newTaskEditHeight,
                          decoration: BasicWidget.basicBorder,
                          child: Column(
                            children: [
                              Container(
                                height: projectPage.newTaskTitleHeight,
                                padding: projectPage.newTaskTitlePadding,
                                child: const Text('New Task'),
                              ),
                              DividerWidget(
                                  MediaQuery.of(context).size.width * 0.7,
                                  ColorConfig.taskBorderColor),
                              Container(
                                height: projectPage.editEntryHeight,
                                child: ListView.builder(
                                    itemCount: model.editEntryChannel.length,
                                    itemBuilder: (context, _index){
                                      return model.editEntryChannel[_index];
                                    }),
                              ),
                            ],
                          )
                      )
                  ),
                  const SizedBox(height: projectPage.adjustedMargin,),
                ]
            ),
          ),
        ),
      )
    );
  }

  // New Task entry
  Widget _newTaskWidget(){
    if (model.newTaskController.isEmpty){
      model.controllerInitialize();
    }
    final int index = model.newTaskController.keys.length - 1 < 0 ? 0
        : model.newTaskController.keys.length - 1;
    return Column(
        children: [
          Row(
            children: [
              const SizedBox(width: projectPage.taskEditEntryMargin,),
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                alignment: Alignment.centerLeft,
                padding: projectPage.taskTitlePadding,
                child: _textEditBox(
                    model.newTaskController[index]![taskCompose.taskTitle],
                    model.editable,'Project Name',false, false),
              ),
            ],
          ),
          const SizedBox(height: projectPage.entryBetweenMargin),
          Row(
            children: [
              const SizedBox(width: projectPage.taskEditEntryMargin,),
              Container(
                height: projectPage.editDescHeight,
                width: MediaQuery.of(context).size.width * 0.7,
                child: _descEditBox(
                    model.newTaskController[index]![taskCompose.taskDesc],
                    model.editable,'Details'
                ),
              ),
            ],
          ),
          const SizedBox(height: projectPage.entryBetweenMargin),
          Row(
            children: [
              const SizedBox(width: projectPage.entryEstimationLeftMargin,),
              _decoratedEditBox(
                  model.newTaskController[index]![taskCompose.estimation],
                  model.editable,
                  'Estimated ', 'h', false),
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _decoratedEditBox(
                      model.newTaskController[index]![taskCompose.dueDate],
                      model.editable,
                      'Due Date', '',
                      false),
                  const SizedBox(width: projectPage.entryDueRightMargin,),
                ],
              ),
            ],
          ),
          const SizedBox(height: projectPage.entryBetweenMargin),
          DividerWidget(MediaQuery.of(context).size.width * 0.7,
              ColorConfig.customBorderColor),
        ]
    );

  }

  Widget _taskView(ProjectData projectData){
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.lightGreen;
    }
    return Container(
      width: projectPage.taskListWidth,
      height: projectPage.taskListHeight,
      decoration: BasicWidget.basicBorder,
      child: ListView.builder(
        itemCount: model.taskList.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: projectPage.taskEditEntryMargin,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    alignment: Alignment.centerLeft,
                    padding: projectPage.taskTitlePadding,
                    child: _textEditBox(
                        model.taskController[index]![taskCompose.taskTitle],
                        model.editable, model.taskList[index], false, model.taskIsEmpty),
                    ),
                  Container(
                    width: projectPage.checkBoxWidth,
                      child:
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: projectData.taskWithDetail[
                          index.toString()][taskCompose.taskCompletion],
                        onChanged: (bool? _){
                          setState(() {
                            projectData.taskWithDetail[
                              index.toString()]![taskCompose.taskCompletion] =
                            projectData.taskWithDetail[index.toString()][taskCompose.taskCompletion]
                                ? false : true;
                            model.taskCompletion(projectData, dataRepo);
                              });

                          },
                        ),
                      )
                ],
              ),
              const SizedBox(height: projectPage.entryBetweenMargin,),
              Row(
                children: [
                  const SizedBox(
                    width: projectPage.entryEstimationLeftMargin,
                  ),
                  Container(
                    height: projectPage.editDescHeight,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: _descEditBox(
                        model.taskController[index]![taskCompose.taskDesc],
                        model.editable,
                        model.taskDetailList[index]![taskCompose.taskDesc]),
                  ),
                ],
              ),

              const SizedBox(height: projectPage.entryBetweenMargin,),
              Row(
                children: [
                  const SizedBox(width: projectPage.entryEstimationLeftMargin,),
                  _estimationEditBox(
                      model.taskController[index]![taskCompose.estimation],
                      model.taskController[index]![taskCompose.progressController],
                      model.taskDetailList[index][taskCompose.estimation].isEmpty
                          ?
                      '0' : model.taskDetailList[index][taskCompose.estimation],
                      model.taskDetailList[index][taskCompose.currentProgress],
                      ' h',
                  model.taskDetailList[index][taskCompose.taskCompletion]
                  ),
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _decoratedEditBox(
                          model.taskController[index]![taskCompose.dueDate],
                          model.editable,
                          model.taskDueOver[index] ? 'Over Due'
                              : model.taskDetailList[index][taskCompose.dueDate].isEmpty
                              ? 'No Due'
                              : model.taskDetailList[index][taskCompose.dueDate], '',
                          model.taskDueOver[index]),
                      const SizedBox(width: projectPage.entryDueRightMargin,),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: projectPage.entryBetweenMargin,),
              DividerWidget(MediaQuery.of(context).size.width * 0.7,
                  ColorConfig.customBorderColor),
            ]
          );
        },
      )
    );
  }

  Widget _textEditBox(TextEditingController _controller, bool _editable,
      String _hintTitle, bool _extraTextStyle, bool _isEmpty) {
    Color _color = _editable ? ColorConfig.editTextColor : ColorConfig.defaultTextColor;
    double _textSize = _extraTextStyle ? 25 : 14;
    TextStyle _textStyle = _extraTextStyle
        ? TextStyle(color:_color, fontSize: _textSize)
        : TextStyle(color: _color, fontSize: _textSize);
    _hintTitle = !_isEmpty ? _hintTitle : 'Add Your Task' ;

    return TextField(
        controller: _controller,
      enabled: _editable,
      decoration: InputDecoration(
          hintText: _hintTitle,
          hintStyle: _textStyle
      ),
    );
  }

  Widget _descEditBox(TextEditingController _controller, bool _editable,
      String _hintTitle) {
    final Color _color = _editable
        ? ColorConfig.editTextColor : ColorConfig.defaultTextColor;
    return TextField(
      controller: _controller,
      enabled: _editable,
      maxLines: 20,
      decoration: InputDecoration(
        border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),),
          hintText: _hintTitle,
          hintStyle: TextStyle(color: _color, fontSize: 14)
      ),
    );
  }
  Widget _estimationEditBox(TextEditingController _controller,
      TextEditingController _progressController,
      String _totalTime, String _currentProgress, String _prefix,
      bool _taskCompleted
      ) {
    TextStyle _style = TextStyle(color: Colors.black);
    _style = model.recordable ? TextStyle(color: Colors.black26) : _style;
    TextStyle _totalTimeStyle =  model.editable
        ? TextStyle(color: Colors.black26) : TextStyle(color: Colors.black);
    _currentProgress = _currentProgress.isEmpty ? '0' : _currentProgress;
    _currentProgress = _taskCompleted ? _totalTime : _currentProgress;
    return Row(
      children: [
      Container(
        width: projectPage.currentProgressWidth,
        height: projectPage.numberInputHeight,
        child: TextField(
          controller: _progressController,
          keyboardType: TextInputType.number,
          enabled: model.recordable,
          decoration: InputDecoration(
              hintText: _currentProgress,
              hintStyle: _style
          ),
        ),
      ),
        Container(
          child: projectPage.progressDivider
        ),
        Container(
          width: projectPage.estimationWidth,
          height: projectPage.numberInputHeight,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            enabled: model.recordable && model.editable,
            decoration: InputDecoration(
                hintText: _totalTime + _prefix,
                hintStyle: _totalTimeStyle
            ),
          ),
        ),
      ],
    );
  }

  Widget _decoratedEditBox(TextEditingController _controller, bool _editable,
      String _hintTitle, String _prefix, bool dueChecker) {
    TextStyle _style = dueChecker ? TextStyle(color: Colors.red)
        : TextStyle(color: Colors.black);
    _style = _editable ? TextStyle(color: Colors.black26) : _style;

    return Container(
      width: projectPage.numberInputWidth,
      height: projectPage.numberInputHeight,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        enabled: _editable,
        decoration: InputDecoration(
            hintText: _hintTitle + _prefix,
            hintStyle: _style
        ),
      ),
    );
  }

  Widget changeButtons(){
    return Visibility(
      visible: model.editable || model.recordable,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: projectPage.floatingButtonWidth,
            decoration: BasicWidget.basicBorder,
            child: Row(
              children: [
                FloatingActionButton(
                    child: Icon(Icons.done, color: Colors.lightGreen,),
                    heroTag: 'SaveButton',
                    tooltip: 'Save Changes',
                    elevation: 0,
                    backgroundColor: ColorConfig.primaryBackground,
                    onPressed: (){
                      setState(() {
                        model.saveChanges(project, dataRepo);
                        model.detectChanges(project,dataRepo);

                        // Fetch the controllers again
                        model.setList(project);

                        model.editable = false;
                      });
                    }),
                FloatingActionButton(
                  child: Icon(Icons.cancel, color: Colors.red),
                  elevation: 0,
                  backgroundColor: ColorConfig.primaryBackground,
                  heroTag: 'CancelButton',
                  tooltip: 'Cancel',
                  onPressed: (){
                    setState(() {
                      model.cancel();
                      model.editable = false;
                    });
                  },)

              ],
            ),
          )
        ],
      )
    );
  }

  Widget addTaskController(ProjectData projectData){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: projectPage.newInputExpandButtonWith,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'New Task',
                  onPressed: (){
                    setState(() {
                      model.addControllers(_newTaskWidget());
                    });
                  }),
            ],
          ),
        )
      ],
    );
  }
}