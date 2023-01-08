import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wbsapp/Data/data_repository/data_repository.dart';
import 'package:wbsapp/Universal_Function/data_management.dart';
import 'package:wbsapp/pages/view/home_page.dart';

void main() async{
  // ensureInitialized() is required if some kind of process took place
  // before runApp runs
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  // instantiate sharedPreference
  await DataManagement.initialize();

  runApp(MyApp());
}


class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  final DataApplication dataApplication = DataApplication();
  final DataManagement dataManager = DataManagement();

  @override
  void initState(){
    super.initState();
    dataLoading();
  }

  @override
  void dispose(){
    super.dispose();
  }

  // Loading data.
  Future<void> dataLoading() async {
    dataApplication.initialize();
    await dataManager.loadProject();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // set the color theme for the entire app
        theme:ThemeData(
          dividerColor: Colors.transparent
      ),

      title: 'Project Manager',
      home: HomePage()
    );
  }
}
