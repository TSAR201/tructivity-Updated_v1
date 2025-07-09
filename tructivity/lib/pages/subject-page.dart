// import 'package:tructivity/db/database-helper.dart';
// import 'package:tructivity/dialogs/subject-dialog.dart';
// import 'package:tructivity/models/subject-model.dart';
// import 'package:tructivity/widgets/custom-FAB.dart';
// import 'package:tructivity/widgets/filler-widget.dart';
// import 'package:flutter/material.dart';
// import 'package:tructivity/widgets/loading-widget.dart';

// class SubjectPage extends StatefulWidget {
//   @override
//   _SubjectPageState createState() => _SubjectPageState();
// }

// class _SubjectPageState extends State<SubjectPage> {
//   DatabaseHelper _db = DatabaseHelper.instance;
//   List<SubjectModel> subjectData = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: Icon(
//           Icons.menu_outlined,
//         ),
//         centerTitle: true,
//         title: Text(
//           'Subjects',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(8),
//         child: Stack(
//           alignment: Alignment.bottomRight,
//           children: [
//             FutureBuilder(
//               future: _db.getSubjectData(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<SubjectModel>> snapshot) {
//                 if (!snapshot.hasData) {
//                   return LoadingWidget();
//                 } else {
//                   subjectData = snapshot.data!;
//                   return subjectData.isEmpty
//                       ? FillerWidget(icon: Icons.book_outlined)
//                       : ListView.builder(
//                           itemCount: subjectData.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding:
//                                   EdgeInsets.only(left: 8, right: 8, top: 10),
//                               child: Material(
//                                 borderRadius: BorderRadius.circular(10),
//                                 elevation: 2,
//                                 child: ListTile(
//                                   title: Text(
//                                     subjectData[index].subject,
//                                     overflow: TextOverflow.ellipsis,
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   subtitle: Text(subjectData[index].teacher),
//                                   onTap: () async {
//                                     await showDialog(
//                                       context: context,
//                                       builder: (_) => SubjectDialog(
//                                         subjectData: subjectData[index],
//                                       ),
//                                     ).whenComplete(() {
//                                       setState(() {});
//                                     });
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                 }
//               },
//             ),
//             CustomFAB(
//               onPressed: () async {
//                 await showDialog(
//                   context: context,
//                   builder: (_) => SubjectDialog(
//                     subjectData: SubjectModel(
//                         subject: '', teacher: '', room: '', note: ''),
//                   ),
//                 ).whenComplete(() {
//                   setState(() {});
//                 });
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/dialogs/subject-dialog.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/models/subject-model.dart';
import 'package:tructivity/widgets/custom-FAB.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/widgets/loading-widget.dart';

class SubjectPage extends StatefulWidget {
  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  DatabaseHelper _db = DatabaseHelper.instance;
  List<SubjectModel> subjectData = [];
  String _table = 'subject';
  late String _selectedSemester;
  Future<List<SubjectModel>> _getData() async {
    _selectedSemester = await getSemesterPreference();
    List<SubjectModel> data =
        await _db.getSubjectsByCategory(_selectedSemester);
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
          'Subjects',
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
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  height: 30,
                  child: Text('Clear All'),
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
                AsyncSnapshot<List<SubjectModel>> snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                subjectData = snapshot.data!;
                return Column(
                  children: [
                    subjectData.isEmpty
                        ? Expanded(
                            child: FillerWidget(icon: Icons.book_outlined))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: subjectData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 10),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(
                                        subjectData[index].subject,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle:
                                          Text(subjectData[index].teacher),
                                      onTap: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => SubjectDialog(
                                            subjectData: subjectData[index],
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
                    // SizedBox(height: 15),
                    // Container(
                    //   color: Theme.of(context)
                    //       .bottomNavigationBarTheme
                    //       .backgroundColor,
                    //   padding: EdgeInsets.only(left: 30, right: 150),
                    //   child: Center(
                    //     child: DropdownList(
                    //       label: null,
                    //       icon: Icons.list_outlined,
                    //       onChanged: (String semester) async {
                    //         if (_selectedSemester != semester) {
                    //           await setSemesterPreference(semester);
                    //           setState(() {});
                    //         }
                    //       },
                    //       options: semesterOptions,
                    //       initialSelection: _selectedSemester,
                    //     ),
                    //   ),
                    // ),
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
                builder: (_) => SubjectDialog(
                  subjectData: SubjectModel(
                    subject: '',
                    teacher: '',
                    room: '',
                    note: '',
                    category: _selectedSemester,
                  ),
                ),
              ).whenComplete(() {
                setState(() {});
              });
            },
          )
        ],
      ),
    );
  }

  Future<void> clearAll() async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
          text:
              'Are you sure you want to delete all subjects in this semester?'),
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
}
