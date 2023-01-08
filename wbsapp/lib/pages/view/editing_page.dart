import 'package:flutter/material.dart';
import 'package:wbsapp/Universal_Function/logger_management.dart';
import 'package:wbsapp/pages/view/home_page.dart';
import 'package:wbsapp/ui_feature_widget/basic_page_widget/divider.dart';
import 'package:wbsapp/ui_feature_widget/edit_component_widget/edit_boxes/custom_edit_box_widget.dart';
import 'package:wbsapp/ui_feature_widget/edit_component_widget/edit_boxes/edit_box_widget.dart';
import 'package:wbsapp/value_config/layout_config.dart';
import 'package:wbsapp/pages/view_model/editing_view_model.dart';

class EditingPage extends StatefulWidget{
  EditingPage();
  _EditingManager createState() => _EditingManager();
}

class _EditingManager extends State<EditingPage>{

  // Controllers
  final EditingViewModel model = EditingViewModel();
  final LoggerManager logger = LoggerManager();
  int _currentIndex = 0;

  @override
  void initState(){
    setState(() {
      model.initialize();
    });
    super.initState();
  }

  @override
  void dispose(){
    model.initialize();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: appBarItem.backPageIcon,
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: appBarItem.appBarIconTheme
      ),
      body: SingleChildScrollView(
        child: Container(
            color: ColorConfig.primaryBackground,
            padding: editPage.topBottomMargin,
            child: Center(
                child: Column(
                  children: [
                    Container(
                        width: editPage.titleWidth,
                        padding: editPage.titleLeftMargin,
                        child: editPage.pageTitle,
                    ),
                    const SizedBox(height: editPage.adjustedMargin),
                    _editDecoratedProject(),
                    const SizedBox(height: editPage.adjustedMargin),
                    _editDecoratedTask(),
                    Container(
                      color: ColorConfig.saveButton,
                      width: editPage.saveButtonWidth,
                      height: editPage.saveButtonHeight,
                      child:TextButton(
                        child: editPage.addText,
                        onPressed: () { model.saveChanges(); },
                      ),),
                    const SizedBox(height: editPage.adjustedMargin),
                  ],)
            )),
      ));
  }

  // Widget: Construct decorated box for task channels
  Widget _editDecoratedTask(){
    return Container(
      padding: editPage.decorationSurroundedMargin,
      child:ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BasicWidget.basicBorder,
          child: Column(
              children: [
                _injectNewTask(),
                _editTaskButton()
              ],
          ),
        ),
      ),
    );
  }

  // Widget: Display project channel
  Widget _editDecoratedProject(){
    return Container(
      padding: editPage.decorationSurroundedMargin,
      child:ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BasicWidget.basicBorder,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: editPage.subtitleLeftMargin),
                EditBox(editPage.subtitleProject, model.controllerList,
                    editPage.projectWordLength, editPage.projectLines),
                EditBox(editPage.subtitleDescription, model.controllerDes,
                    editPage.projectDescWordLength, editPage.projectDescLines)
              ],
          ),
        ),
      ),
    );
  }

  // Widget: display button for Add/Remove a expandable taskBox
  Widget _editTaskButton(){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                icon: editPage.addIcon,
                tooltip: editPage.addHintText,
                onPressed: (){
                  setState(() {
                    model.taskIndexIncrement();
                    _currentIndex = (model.textControllerList.keys.length - 1);
                    model.getNewTaskWidget(_taskEntryChannel(_currentIndex));
                  });
                }),
            IconButton(
                icon: editPage.removeIcon,
                tooltip: editPage.removeText,
                onPressed: (){
                  setState(() {
                    model.taskWidgetList.remove(model.taskWidgetList.last);
                    model.textControllerList.remove(model.taskWidgetList.length);
                  });
                }),
          ],));
  }

  // Widget: Create a new entry channel
  Widget _taskEntryChannel(int _taskIndex){
    return  Container(
        child: Column(children: [
          ExpansionTile(
            title: Text(editPage.subtitleTask),
            initiallyExpanded: false,
            children: [
              const SizedBox(height: editPage.projectTitleMargin),
              EditBox(editPage.subtitleTask,
                  model.textControllerList[_taskIndex]![taskCompose.taskTitle],
                  editPage.taskWordLength, editPage.projectLines),
              EditBox(editPage.subtitleDetail,
                  model.textControllerList[_taskIndex]![taskCompose.taskDesc],
                  editPage.taskDescWordLength, editPage.taskDescLines),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: editPage.subtitleLeftMargin),
                  CustomEditBox(editPage.subtitleEstimation,
                      model.textControllerList[_taskIndex]![taskCompose.estimation],
                      editPage.customBoxWidth),
                  Padding(padding: editPage.adjustedMargin2,),
                  CustomEditBox(editPage.subtitleDue,
                      model.textControllerList[_taskIndex]![taskCompose.dueDate],
                      editPage.customBoxWidth)
                ],
              ),
            ],
          ),
          DividerWidget(dividerWidget.dividerEditWidth,
          ColorConfig.customBorderColor)], )
    );
  }

  // Widget: Inject a new entry channel
  Widget _injectNewTask(){
    if(model.taskWidgetList.length == 0){
      model.taskWidgetList = [_taskEntryChannel(_currentIndex)];}
    return Column(children: model.taskWidgetList);
  }
}
