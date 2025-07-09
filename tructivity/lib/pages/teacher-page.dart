import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/dialogs/teacher-dialog.dart';
import 'package:tructivity/models/teacher-model.dart';
import 'package:tructivity/widgets/custom-FAB.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/widgets/loading-widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  DatabaseHelper _db = DatabaseHelper.instance;
  List<TeacherModel> teacherData = [];
  final String _table = 'teacher';
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
          'Teachers',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          PopupMenuButton(
            enableFeedback: false,
            icon: Icon(Icons.adaptive.more),
            onSelected: (int value) async {
              if (value == 0) {
                await clearAll();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  height: 30,
                  value: 0,
                  child: Text('Clear All'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            FutureBuilder(
              future: _db.getTeacherData(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TeacherModel>> snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                } else {
                  teacherData = snapshot.data!;
                  return teacherData.isEmpty
                      ? FillerWidget(icon: Icons.person_outlined)
                      : ListView.builder(
                          itemCount: teacherData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: 8, right: 8, top: 10),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                elevation: 2,
                                child: ListTile(
                                  isThreeLine: true,
                                  title: Text(
                                    teacherData[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    '${teacherData[index].phone}\n${teacherData[index].email}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final url =
                                              'tel:${teacherData[index].phone}';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          }
                                        },
                                        icon: Icon(Icons.phone_outlined),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final url =
                                              'mailto:${teacherData[index].email}';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          }
                                        },
                                        icon: Icon(Icons.email_outlined),
                                      )
                                    ],
                                  ),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => TeacherDialog(
                                        teacherData: teacherData[index],
                                      ),
                                    ).whenComplete(() {
                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                }
              },
            ),
            CustomFAB(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (_) => TeacherDialog(
                          teacherData: TeacherModel(
                            name: '',
                            phone: '',
                            email: '',
                            address: '',
                            officeHours: '',
                            website: '',
                          ),
                        )).whenComplete(() {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> clearAll() async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
          text: 'Are you sure you want to delete all of these contacts?'),
    ).then((confirmed) async {
      if (confirmed != null) {
        if (confirmed) {
          for (TeacherModel data in teacherData) {
            await _db.remove(table: _table, id: data.id!);
          }
          setState(() {});
        }
      }
    });
  }
}
