import 'package:tructivity/models/grade-models/college-grade-model.dart';
import 'package:tructivity/models/grade-models/highschool-grade-model.dart';
import 'package:tructivity/models/grade-models/letter-grade-model.dart';
import 'package:tructivity/models/grade-models/percentage-grade-model.dart';
import 'package:tructivity/models/grade-models/point-grade-model.dart';

class GradeDataModel {
  List<PointGradeModel> pointGradeData;
  List<LetterGradeModel> letterGradeData;
  List<HSGradeModel> highSchoolGradeData;
  List<CollegeGradeModel> collegeGradeData;
  List<PercentageGradeModel> percentageGradeData;
  GradeDataModel({
    required this.collegeGradeData,
    required this.highSchoolGradeData,
    required this.letterGradeData,
    required this.pointGradeData,
    required this.percentageGradeData,
  });

  bool isEmpty(int id) {
    bool res = false;
    switch (id) {
      case 1:
        if (this.percentageGradeData.isEmpty) {
          res = true;
        }
        break;
      case 2:
        if (this.pointGradeData.isEmpty) {
          res = true;
        }
        break;
      case 3:
        if (this.letterGradeData.isEmpty) {
          res = true;
        }
        break;
      case 4:
        if (this.collegeGradeData.isEmpty) {
          res = true;
        }
        break;
      case 5:
        if (this.highSchoolGradeData.isEmpty) {
          res = true;
        }
        break;
      default:
        if (this.highSchoolGradeData.isEmpty) {
          res = true;
        }
        break;
    }

    return res;
  }
}
