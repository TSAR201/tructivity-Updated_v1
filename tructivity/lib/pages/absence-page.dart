import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/absence-dialog.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/models/absence-model.dart';
import 'package:tructivity/widgets/custom-FAB.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/widgets/loading-widget.dart';
import 'package:intl/intl.dart';
import 'package:tructivity/functions.dart';
import 'absence-detail-page.dart';

class AbsencePage extends StatefulWidget {
  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  final _db = DatabaseHelper.instance;
  final String _table = 'absence';
  late String _selectedSemester;
  List<AbsenceModel> absenceData = [];
  Future<List<AbsenceModel>> getData() async {
    _selectedSemester = await getSemesterPreference();
    List<AbsenceModel> data = await _db.getAbsenceByCategory(_selectedSemester);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(
          Icons.menu_outlined,
        ),
        centerTitle: true,
        title: Text(
          'Absences',
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
                navigateToDetail();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text('Clear All'),
                ),
                PopupMenuItem(
                  value: 1,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  height: 25,
                  child: Text('Absence Details'),
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
            future: getData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<AbsenceModel>> snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                absenceData = snapshot.data!;
                return Column(
                  children: [
                    absenceData.isEmpty
                        ? Expanded(
                            child: FillerWidget(
                                icon: Icons.person_add_disabled_outlined))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: absenceData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 10),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 2,
                                    child: ListTile(
                                      isThreeLine: true,
                                      title: Text(
                                        absenceData[index].subject,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        generateSubtitle(absenceData[index]),
                                      ),
                                      onTap: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AbsenceDialog(
                                            category: _selectedSemester,
                                            absenceData: absenceData[index],
                                          ),
                                        ).whenComplete(() {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                );
              }
            },
          ),
          CustomFAB(
            padding: 20,
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => AbsenceDialog(
                  category: _selectedSemester,
                  absenceData: AbsenceModel(
                    pickedDateTime: DateTime.now(),
                    note: '',
                    room: '',
                    subject: '',
                    teacher: '',
                    category: _selectedSemester,
                  ),
                ),
              ).whenComplete(() {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> clearAll() async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
          text:
              'Are you sure you want to delete all absences in this semester?'),
    ).then((confirmed) async {
      if (confirmed != null) {
        if (confirmed) {
          await _db.removeDataByCategory(
              table: _table, category: _selectedSemester);
          setState(() {});
        }
      }
    });
  }

  String generateSubtitle(AbsenceModel absence) {
    String subtitle = '';
    subtitle += '${absence.teacher}\n';
    subtitle += '${DateFormat.yMd().format(absence.pickedDateTime)}';
    return subtitle;
  }

  void navigateToDetail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AbsenceDetail(
                absenceData: absenceData, category: _selectedSemester)));
  }
}
