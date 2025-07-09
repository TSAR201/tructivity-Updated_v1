import 'package:flutter/material.dart';
import 'package:tructivity/constants.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/widgets/dropdown-list.dart';

class SemesterChangeDialog extends StatefulWidget {
  @override
  State<SemesterChangeDialog> createState() => _SemesterChangeDialogState();
}

class _SemesterChangeDialogState extends State<SemesterChangeDialog> {
  String? _selectedSemester;
  getData() async {
    _selectedSemester = await getSemesterPreference();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Text('Change Semester'),
      content: _selectedSemester == null
          ? Container(
              height: 10,
              color: Colors.red,
            )
          : DropdownList(
              label: null,
              icon: Icons.school_outlined,
              options: semesterOptions,
              initialSelection: _selectedSemester!,
              onChanged: (String semester) async {
                if (semester != _selectedSemester) {
                  _selectedSemester = semester;
                  await setSemesterPreference(semester);
                  showDialog(
                      context: context,
                      builder: (c) {
                        return AlertDialog(
                          content: Text(
                              'Semester changed successfully. Changes in semester will be applied throughout the app.'),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.teal)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'I Understand',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
            ),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Done',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
