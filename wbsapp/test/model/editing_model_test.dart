import 'package:flutter_test/flutter_test.dart';
import 'package:wbsapp/Data/data_repository/project_data.dart';
import 'package:wbsapp/pages/model/editing_model.dart';


void main() {
 final EditingModel model = EditingModel();
 ProjectData testCase = ProjectData('', '', {'0':[]});
 testCase.project = 'case1';
 testCase.description = 'case1';
 List<ProjectData> target = [testCase];
 final String newInput1 = "Case1";
 final String newInput2 = "Case2";

 group('Data Logic: Project is modified Case ====>',() {
   test('Expected to be True', () {
     expect(true, model.detectChanges(newInput1, target));
   });

   test('Expected to be False', (){
     target.add(ProjectData(newInput1, newInput1, {}));
     expect(false, model.detectChanges(newInput1, target));
   });
 });

 group('Data Logic: Description is modified Case ====>',() {
   test('Expected to be True', (){
     target.add(ProjectData('case1', 'case2', {}));
     expect(true, model.detectChanges(newInput2,target));
   });

   test('Expected to be False', (){
     target.add(ProjectData(newInput2, newInput2, {}));
     expect(false, model.detectChanges(newInput2,target));
   });
 });
 }