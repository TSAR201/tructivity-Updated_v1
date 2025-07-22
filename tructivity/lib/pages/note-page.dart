import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/note-category-update-dialog.dart';
import 'package:tructivity/dialogs/note-category-add-dialog.dart';
import 'package:tructivity/models/note-category-model.dart';
import 'package:tructivity/models/note-model.dart';
import 'package:tructivity/pages/note-category-page.dart';
import 'package:tructivity/pages/note-detail-page.dart';
import 'package:tructivity/widgets/category-card.dart';
import 'package:tructivity/widgets/custom-FAB.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:tructivity/widgets/loading-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _db = DatabaseHelper.instance;
  List<NoteCategoryModel> categoryData = [];

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
          'Notes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FutureBuilder(
            future: _db.getNoteCategoryData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<NoteCategoryModel>> snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                categoryData = snapshot.data!;
                return dataEmpty()
                    ? FillerWidget(icon: Icons.event_note_outlined)
                    : SizedBox(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.4,
                                ),
                                itemCount: categoryData.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        GestureDetector(
                                  onTap: () =>
                                      onTapCategory(categoryData[index]),
                                  onLongPress: () =>
                                      renameCategory(categoryData[index]),
                                  child: CategoryCard(
                                    icon: Icons.note_outlined,
                                    title: categoryData[index].category,
                                    subtitle: categoryData[index].description,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              }
            },
          ),
          CustomFAB(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return NoteCategoryAddDialog();
                },
              ).whenComplete(() {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }

  void onTapCategory(NoteCategoryModel data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteCategoryPage(
          categoryData: data,
        ),
      ),
    ).whenComplete(() {
      setState(() {});
    });
  }

  void renameCategory(NoteCategoryModel data) async {
    await showDialog(
      context: context,
      builder: (context) {
        return NoteCategoryUpdateDialog(
          categoryData: data,
          categoryTable: 'noteCategory',
          dataTable: 'note',
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  void onTapNote(NoteModel data) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return NoteDetailPage(
    //     noteData: data,
    //   );
    // })).whenComplete(() {
    //   setState(() {});
    // });
  }

  bool dataEmpty() {
    if (categoryData.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
