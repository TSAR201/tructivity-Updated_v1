import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/note-category-model.dart';
import 'package:tructivity/models/note-model.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:tructivity/widgets/loading-widget.dart';
import 'package:tructivity/widgets/note-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'note-detail-page.dart';

class NoteCategoryPage extends StatefulWidget {
  final NoteCategoryModel categoryData;
  NoteCategoryPage({required this.categoryData});
  @override
  _NoteCategoryPageState createState() => _NoteCategoryPageState(categoryData);
}

class _NoteCategoryPageState extends State<NoteCategoryPage> {
  final NoteCategoryModel categoryData;
  _NoteCategoryPageState(this.categoryData);
  final _db = DatabaseHelper.instance;
  List<NoteModel> noteData = [];
  Color noteTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          categoryData.category,
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
                await deleteCategory();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  height: 30,
                  child: Text('Delete Category'),
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
              future: _db.getNotesByCategory(categoryData.category),
              builder: (BuildContext context,
                  AsyncSnapshot<List<NoteModel>> snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                } else {
                  noteData = snapshot.data!;
                  return noteData.isEmpty
                      ? FillerWidget(icon: Icons.event_note_outlined)
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.4,
                          ),
                          itemCount: noteData.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () => onTapCard(noteData[index]),
                            child: NoteCard(note: noteData[index]),
                          ),
                        );
                }
              }),
          Padding(
            padding: EdgeInsets.all(15),
            child: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NoteDetailPage(
                    noteData: NoteModel(
                      category: categoryData.category,
                      title: '',
                      description: '[{"insert": "\\n"}]',
                      pickedDateTime: DateTime.now(),
                      color: Color(0xffc14279),
                    ),
                  );
                })).whenComplete(() {
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  String getPriorityText({required String priority}) {
    switch (priority) {
      case 'low':
        return '!';
      case 'medium':
        return '!!';
      case 'high':
        return '!!!';
      default:
        return '';
    }
  }

  void onTapCard(NoteModel data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetailPage(
        noteData: data,
      );
    })).whenComplete(() {
      setState(() {});
    });
  }

  Future<void> deleteCategory() async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(text: confirmationText + ' category?'),
    ).then((confirmed) async {
      if (confirmed != null) {
        if (confirmed) {
          for (NoteModel data in noteData) {
            await _db.remove(table: 'note', id: data.id!);
          }
          await _db.remove(table: 'noteCategory', id: categoryData.id!);
          Navigator.pop(context);
        }
      }
    });
  }
}
