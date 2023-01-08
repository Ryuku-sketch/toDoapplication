import 'package:flutter_test/flutter_test.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/Universal_Function/data_management.dart';

///Test whether the class is generated once
///with the singleton
///

void main() {
  final ProjectData projectData = ProjectData('','',{});
  final DataManagement dataManagement = DataManagement();

  group('Check singleton: ProjectData ====>', (){
    test('Expected to be Same', (){
      final ProjectData testData = ProjectData('','',{});
      final bool testChecker = projectData == testData ? true : false;
      expect(false, testChecker);
    });
  });



  group('Check singleton: DataManagement ====>', (){
    test('Expected to be Same', (){
      final DataManagement testData = DataManagement();
      final bool testChecker = dataManagement == testData ? true : false;
      expect(true, testChecker);});
  });


}