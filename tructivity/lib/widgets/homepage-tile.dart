import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/event-dialog.dart';
import 'package:tructivity/dialogs/homework-dialog.dart';
import 'package:tructivity/dialogs/task-dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageTile extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  final String description;
  final String id;
  final _db = DatabaseHelper.instance;
  final refreshCallback;
  final bool isDone;
  final String currentSemester;
  HomePageTile({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.id,
    required this.refreshCallback,
    required this.isDone,
    required this.currentSemester,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle = DateFormat("h:mma").format(dateTime);
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.teal,
          ),
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) async {
          await onTileDismissed(context, title.toLowerCase());
        },
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Opacity(
                opacity: isDone ? 0.4 : 1.0,
                child: ListTile(
                  leading: SizedBox(width: 40),
                  title: Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      )),
                  subtitle: Text(
                    '$description\n\n$subtitle',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  onTap: isDone
                      ? null
                      : () => onTapTile(context, title.toLowerCase()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: () async {
                    await toggleDone(title.toLowerCase());
                  },
                  icon: isDone
                      ? Icon(Icons.check_circle_outline, color: Colors.teal)
                      : Icon(Icons.circle_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> toggleDone(String table) async {
    var dataModel = await _db.getDataById(table, id);
    dataModel.isDone = !dataModel.isDone;
    await _db.update(table: table, model: dataModel);
    refreshCallback();
  }

  Future<void> onTileDismissed(BuildContext context, String table) async {
    var dataModel = await _db.getDataById(table, id);
    await _db.remove(table: table, id: dataModel.id!);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Entry Deleted', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.grey[400],
      action: SnackBarAction(
        textColor: Colors.black,
        label: 'Undo',
        onPressed: () async {
          await _db.add(table: table, model: dataModel);
          refreshCallback();
        },
      ),
    ));
  }

  Future<void> onTapTile(BuildContext context, String table) async {
    var dataModel = await _db.getDataById(table, id);
    if (table == 'homework') {
      showDialog(
          context: context,
          builder: (_) => HomeworkDialog(
                homeworkData: dataModel,
                semester: currentSemester,
              )).whenComplete(() {
        refreshCallback();
      });
    } else if (table == 'event') {
      showDialog(
          context: context,
          builder: (_) => EventDialog(
                eventData: dataModel,
                semester: currentSemester,
              )).whenComplete(() {
        refreshCallback();
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => TaskDialog(taskData: dataModel)).whenComplete(() {
        refreshCallback();
      });
    }
  }
}
