import 'package:flutter/material.dart';
import 'package:tructivity/models/grade-models/college-grade-model.dart';
import 'package:tructivity/models/grade-models/highschool-grade-model.dart';
import 'package:tructivity/models/grade-models/letter-grade-model.dart';
import 'package:tructivity/models/grade-models/percentage-grade-model.dart';

class GradeTiles extends StatelessWidget {
  final List data;
  final void Function(int index) onTap;
  const GradeTiles({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 10),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 2,
            child: ListTile(
              isThreeLine: true,
              title: Text(
                data[index].subject,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(generateSubtitle(data[index])),
              onTap: () => onTap(index),
            ),
          ),
        );
      },
    );
  }

  String generateSubtitle(var data) {
    String subtitle = '';
    subtitle = 'Grade: ${data.grade}\n';
    Type type = data.runtimeType;
    if (type == CollegeGradeModel || type == HSGradeModel) {
      subtitle += 'Credit: ${data.credit}';
    } else if (type == LetterGradeModel || type == PercentageGradeModel) {
      subtitle += 'Weight: ${data.weight}';
    } else {
      subtitle += 'Max Points: ${data.maxPoints}';
    }
    // subtitle += '\n${DateFormat("y/M/d").format(data.pickedDateTime)}';
    return subtitle;
  }
}
