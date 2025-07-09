import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/dialogs/grade%20dialogs/college-grade-dialog.dart';
import 'package:tructivity/dialogs/grade%20dialogs/grading-system-dialog.dart';
import 'package:tructivity/dialogs/grade%20dialogs/highschool-grade-dialog.dart';
import 'package:tructivity/dialogs/grade%20dialogs/letter-grade-dialog.dart';
import 'package:tructivity/dialogs/grade%20dialogs/percentage-grade-dialog.dart';
import 'package:tructivity/dialogs/grade%20dialogs/point-grade-dialog.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/models/grade-models/college-grade-model.dart';
import 'package:tructivity/models/grade-models/grade-data-model.dart';
import 'package:tructivity/models/grade-models/highschool-grade-model.dart';
import 'package:tructivity/models/grade-models/letter-grade-model.dart';
import 'package:tructivity/models/grade-models/percentage-grade-model.dart';
import 'package:tructivity/models/grade-models/point-grade-model.dart';
import 'package:tructivity/widgets/custom-FAB.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/widgets/loading-widget.dart';
import 'package:tructivity/widgets/grade-tile.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late String _selectedSemester;
  final _db = DatabaseHelper.instance;
  late GradeDataModel gradeData;
  late int _gradingSystem;
  Future<GradeDataModel> _getData() async {
    _selectedSemester = await getSemesterPreference();
    _gradingSystem = await getGradingPreference();
    GradeDataModel data = await _db.getGradesByCategory(_selectedSemester);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.menu_outlined),
        centerTitle: true,
        title: Text(
          'Grades',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.adaptive.more),
            onSelected: (int value) async {
              if (value == 0) {
                await clearAll();
              }
              if (value == 1) {
                await selectGradingSystem(context);
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text('Clear All'),
                  value: 0,
                  height: 30,
                ),
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text('Grade System'),
                  value: 1,
                  height: 30,
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FutureBuilder(
              future: _getData(),
              builder: (BuildContext context,
                  AsyncSnapshot<GradeDataModel> snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                } else {
                  gradeData = snapshot.data!;
                  return Column(
                    children: [
                      gradeData.isEmpty(_gradingSystem)
                          ? Expanded(
                              child: FillerWidget(icon: Icons.grade_outlined))
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: getTiles(),
                                ),
                              ),
                            ),
                    ],
                  );
                }
              }),
          CustomFAB(onPressed: onTapFAB),
        ],
      ),
    );
  }

  void onTapFAB() async {
    if (_gradingSystem == 1) {
      showPercentageGradeOption();
    } else if (_gradingSystem == 2) {
      showPointGradeOption();
    } else if (_gradingSystem == 3) {
      showLetterGradeOption();
    } else if (_gradingSystem == 4) {
      showCollegeGradeOption();
    } else if (_gradingSystem == 5) {
      showHighSchoolGradeOption(false);
    } else if (_gradingSystem == 6) {
      showHighSchoolGradeOption(true);
    }
  }

  ///
  Future<void> clearAll() async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
          text:
              'Are you sure you want to delete all grades for this semester?'),
    ).then((confirmed) async {
      if (confirmed != null) {
        if (confirmed) {
          _db.removeDataByCategory(
              table: 'pointGrade', category: _selectedSemester);
          _db.removeDataByCategory(
              table: 'letterGrade', category: _selectedSemester);
          _db.removeDataByCategory(
              table: 'highSchoolGrade', category: _selectedSemester);
          _db.removeDataByCategory(
              table: 'collegeGrade', category: _selectedSemester);
          _db.removeDataByCategory(
              table: 'percentageGrade', category: _selectedSemester);
          setState(() {});
        }
      }
    });
  }

  showCollegeGradeOption() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CollegeGradeDialog(
          category: _selectedSemester,
          gradeData: CollegeGradeModel(
            category: _selectedSemester,
            credit: creditOptions[0],
            grade: gradeOptions[0],
            note: '',
            pickedDateTime: DateTime.now(),
            subject: '',
          ),
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> onTapCollegeGrade(int index) async {
    await showDialog(
      context: context,
      builder: (context) => CollegeGradeDialog(
        category: _selectedSemester,
        gradeData: gradeData.collegeGradeData[index],
      ),
    ).whenComplete(() {
      setState(() {});
    });
  }

  showPercentageGradeOption() async {
    await showDialog(
      context: context,
      builder: (context) {
        return PercentageGradeDialog(
          category: _selectedSemester,
          gradeData: PercentageGradeModel(
            category: _selectedSemester,
            weight: '',
            grade: '',
            note: '',
            pickedDateTime: DateTime.now(),
            subject: '',
          ),
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> onTapPercentageGrade(int index) async {
    await showDialog(
      context: context,
      builder: (context) => PercentageGradeDialog(
          category: _selectedSemester,
          gradeData: gradeData.percentageGradeData[index]),
    ).whenComplete(() {
      setState(() {});
    });
  }

  showPointGradeOption() async {
    await showDialog(
      context: context,
      builder: (context) {
        return PointGradeDialog(
          category: _selectedSemester,
          gradeData: PointGradeModel(
            category: _selectedSemester,
            maxPoints: '',
            grade: '',
            note: '',
            pickedDateTime: DateTime.now(),
            subject: '',
          ),
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> onTapPointGrade(int index) async {
    await showDialog(
      context: context,
      builder: (context) => PointGradeDialog(
          category: _selectedSemester,
          gradeData: gradeData.pointGradeData[index]),
    ).whenComplete(() {
      setState(() {});
    });
  }

  showLetterGradeOption() async {
    await showDialog(
      context: context,
      builder: (context) {
        return LetterGradeDialog(
          category: _selectedSemester,
          gradeData: LetterGradeModel(
            category: _selectedSemester,
            weight: '',
            grade: gradeOptions[0],
            note: '',
            pickedDateTime: DateTime.now(),
            subject: '',
          ),
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> onTapLetterGrade(int index) async {
    await showDialog(
      context: context,
      builder: (context) => LetterGradeDialog(
        category: _selectedSemester,
        gradeData: gradeData.letterGradeData[index],
      ),
    ).whenComplete(() {
      setState(() {});
    });
  }

  showHighSchoolGradeOption(bool gradeAsPercentage) async {
    await showDialog(
      context: context,
      builder: (context) {
        return HSGradeDialog(
          category: _selectedSemester,
          gradeAsPercentage: gradeAsPercentage,
          gradeData: HSGradeModel(
            category: _selectedSemester,
            course: courseOptions[0],
            credit: creditOptions[0],
            grade: gradeAsPercentage ? '' : gradeOptions[0],
            note: '',
            pickedDateTime: DateTime.now(),
            subject: '',
          ),
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> onTapHighSchoolGrade(
      HSGradeModel data, bool gradeAsPercentage) async {
    await showDialog(
      context: context,
      builder: (context) => HSGradeDialog(
          category: _selectedSemester,
          gradeAsPercentage: gradeAsPercentage,
          gradeData: data),
    ).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> selectGradingSystem(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return GradingSystemDialog();
        }).whenComplete(() {
      setState(() {});
    });
  }

  List<GradeTiles> getTiles() {
    List<GradeTiles> grades = [];
    if (_gradingSystem == 1) {
      grades.add(GradeTiles(
        data: gradeData.percentageGradeData,
        onTap: (int index) async {
          await onTapPercentageGrade(index);
        },
      ));
    }
    if (_gradingSystem == 2) {
      grades.add(
        GradeTiles(
          data: gradeData.pointGradeData,
          onTap: (int index) async {
            await onTapPointGrade(index);
          },
        ),
      );
    }
    if (_gradingSystem == 3) {
      grades.add(
        GradeTiles(
          data: gradeData.letterGradeData,
          onTap: (int index) async {
            await onTapLetterGrade(index);
          },
        ),
      );
    }
    if (_gradingSystem == 4) {
      grades.add(
        GradeTiles(
          data: gradeData.collegeGradeData,
          onTap: (int index) async {
            await onTapCollegeGrade(index);
          },
        ),
      );
    }
    if (_gradingSystem == 5) {
      List highSchoolData = [];
      for (var dataModel in gradeData.highSchoolGradeData) {
        late bool gradeAsPercentage;
        double? x = double.tryParse(dataModel.grade);
        gradeAsPercentage = x == null ? false : true;
        if (!gradeAsPercentage) {
          highSchoolData.add(dataModel);
        }
      }
      grades.add(
        GradeTiles(
          data: highSchoolData,
          onTap: (int index) async {
            await onTapHighSchoolGrade(highSchoolData[index], false);
          },
        ),
      );
    }
    if (_gradingSystem == 6) {
      List highSchoolData = [];
      for (var dataModel in gradeData.highSchoolGradeData) {
        late bool gradeAsPercentage;
        double? x = double.tryParse(dataModel.grade);
        gradeAsPercentage = x == null ? false : true;
        if (gradeAsPercentage) {
          highSchoolData.add(dataModel);
        }
      }
      grades.add(
        GradeTiles(
          data: highSchoolData,
          onTap: (int index) async {
            await onTapHighSchoolGrade(highSchoolData[index], true);
          },
        ),
      );
    }
    return grades;
  }
}
