import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/event-dialog.dart';
import 'package:tructivity/dialogs/homework-dialog.dart';
import 'package:tructivity/dialogs/notification-add-dialog.dart';
import 'package:tructivity/dialogs/task-dialog.dart';
import 'package:tructivity/models/event-model.dart';
import 'package:tructivity/models/homework-model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tructivity/pages/promodoro-page.dart';

class CustomTile extends StatelessWidget {
  final _db = DatabaseHelper.instance;
  final refreshCallback;
  final dataModel;
  final String currentSemester;
  CustomTile(
      {required this.dataModel,
      required this.refreshCallback,
      required this.currentSemester});
  @override
  Widget build(BuildContext context) {
    Widget dialog;
    MaterialColor? trailingIconColor;
    String title, subtitle, table;
    trailingIconColor =
        dataModel.notificationDateTime != null ? Colors.teal : null;
    bool isDone = dataModel.isDone;

    Map data = parseDataModel();
    title = data['title'];
    dialog = data['dialog'];
    subtitle = data['subtitle'];
    table = data['table']; //sqflite table
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Dismissible(
        resizeDuration: Duration(milliseconds: 100),
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
          await onTileDismissed(context, table, dataModel, refreshCallback);
        },
        child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 2,
            child: Stack(alignment: Alignment.centerLeft, children: [
              Opacity(
                opacity: isDone ? 0.4 : 1.0,
                child: ListTile(
                  leading: SizedBox(width: 40),
                  title: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: isDone ? TextDecoration.lineThrough : null),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  onTap: isDone
                      ? null
                      : () =>
                          showEditingDialog(context: context, dialog: dialog),
                  onLongPress: () {
                    if (table == 'homework' && !isDone) {
                      Navigator.push(context, MaterialPageRoute(builder: (c) {
                        return Promodoro(title: title);
                      }));
                    }
                  },
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(
                      color: trailingIconColor,
                      icon: Icon(
                        Icons.notification_add_outlined,
                      ),
                      onPressed: isDone
                          ? null
                          : () => showNotificationDialog(
                              table: table, context: context),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: () async {
                    dataModel.isDone = !isDone;
                    await _db.update(table: table, model: dataModel);
                    refreshCallback();
                  },
                  icon: isDone
                      ? Icon(Icons.check_circle_outline, color: Colors.teal)
                      : Icon(Icons.circle_outlined),
                ),
              ),
            ])),
      ),
    );
  }

  showNotificationDialog(
      {required String table, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return NotificationDialog(
          dataModel: dataModel,
          table: table,
        );
      },
    ).whenComplete(() {
      refreshCallback();
    });
  }

  showEditingDialog({required BuildContext context, required Widget dialog}) {
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    ).whenComplete(() {
      refreshCallback();
    });
  }

  Map parseDataModel() {
    String time = DateFormat("h:mma").format(dataModel.pickedDateTime);
    Widget dialog;
    String table = '', title = '', subtitle = '';
    if (dataModel.runtimeType == HomeworkModel) {
      title = dataModel.subject;

      if (dataModel.note.length > 25) {
        subtitle += "${dataModel.note.substring(0, 24)} ...\n";
      } else {
        subtitle += "${dataModel.note}\n";
      }

      dialog = HomeworkDialog(
        homeworkData: dataModel,
        semester: currentSemester,
      );
      table = 'homework';
    } else if (dataModel.runtimeType == EventModel) {
      title = dataModel.event;
      if (dataModel.note.length > 25) {
        subtitle += "${dataModel.note.substring(0, 24)} ...\n";
      } else {
        subtitle += "${dataModel.note}\n";
      }

      dialog = EventDialog(
        eventData: dataModel,
        semester: currentSemester,
      );
      table = 'event';
    } else {
      title = dataModel.task;
      if (dataModel.note.length > 25) {
        subtitle += "${dataModel.note.substring(0, 24)} ...\n";
      } else {
        subtitle += "${dataModel.note}\n";
      }

      dialog = TaskDialog(taskData: dataModel);
      table = 'task';
    }
    subtitle += "\n$time";
    return {
      'table': table,
      'dialog': dialog,
      'title': title,
      'subtitle': subtitle,
    };
  }

  Future<void> onTileDismissed(
      BuildContext context, String table, var tileData, var refresh) async {
    await _db.remove(table: table, id: tileData.id!);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Entry Deleted', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.grey[400],
      action: SnackBarAction(
          textColor: Colors.black,
          label: 'Undo',
          onPressed: () async {
            await _db.add(table: table, model: tileData);
            refresh();
          }),
    ));
  }
}
