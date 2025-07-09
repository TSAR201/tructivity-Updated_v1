import 'package:tructivity/constants.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/schedule-dialog.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/models/schedule-model.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tructivity/widgets/loading-widget.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

DateTime today = DateTime.now();
DateTime start =
    DateTime(today.year, today.month, today.day, today.hour, today.minute);

class _SchedulePageState extends State<SchedulePage> {
  List<Appointment> l = [];
  DatabaseHelper _db = DatabaseHelper.instance;
  List<ScheduleModel> scheduleData = [];
  late String _currentSemester;
  Future<List<ScheduleModel>> _getData() async {
    _currentSemester = await getSemesterPreference();
    List<ScheduleModel> data = await _db.getScheduleData();
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
          'Schedule',
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
                AsyncSnapshot<List<ScheduleModel>> snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                scheduleData = snapshot.data!;
                return SfCalendar(
                  headerStyle: CalendarHeaderStyle(textAlign: TextAlign.center),
                  dataSource: CustomDataSource(getAppointments()),
                  firstDayOfWeek: 1,
                  allowViewNavigation: false,
                  view: CalendarView.week,
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeInterval: Duration(hours: 1),
                    timeIntervalHeight: 80,
                  ),
                  selectionDecoration: BoxDecoration(),
                  onTap: (tile) async {
                    if (tile.appointments != null) {
                      List appointments = tile.appointments!;
                      if (appointments.isNotEmpty) {
                        ScheduleModel model = getModelById(appointments[0].id);
                        await showScheduleDialog(
                          context: context,
                          dialog: ScheduleDialog(
                            scheduleData: model,
                            semester: _currentSemester,
                          ),
                        );
                      }
                    } else {
                      await showScheduleDialog(
                        context: context,
                        dialog: ScheduleDialog(
                          semester: _currentSemester,
                          scheduleData: ScheduleModel(
                            type: scheduleTypes[0],
                            color: Color(0xffc14279),
                            subject: '',
                            teacher: '',
                            room: '',
                            note: '',
                            start: tile.date!,
                            end: tile.date!.add(
                              Duration(hours: 1),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  showScheduleDialog(
      {required BuildContext context, required ScheduleDialog dialog}) {
    showDialog(
      context: context,
      builder: (context) => dialog,
    ).whenComplete(() {
      setState(() {});
    });
  }

  List<Appointment> getAppointments() {
    List<Appointment> appointments = [];
    for (ScheduleModel model in scheduleData) {
      appointments.add(
        Appointment(
          startTime: model.start,
          endTime: model.end,
          color: model.color,
          id: model.id,
          notes: model.note,
          location: model.room,
          subject: model.subject + '\n' + model.room + '\n' + model.type,
        ),
      );
    }

    return appointments;
  }

  getModelById(int id) {
    for (ScheduleModel model in scheduleData) {
      if (id == model.id) {
        return model;
      }
    }
  }

  Future<void> clearAll() async {
    await showDialog(
            context: context,
            builder: (_) => ConfirmationDialog(
                text: 'Are you sure you want to delete all of these subjects?'))
        .then((confirmed) async {
      if (confirmed != null) {
        if (confirmed) {
          for (ScheduleModel data in scheduleData) {
            await _db.remove(table: 'schedule', id: data.id!);
          }
          setState(() {});
        }
      }
    });
  }
}

class CustomDataSource extends CalendarDataSource {
  CustomDataSource(List<Appointment> source) {
    appointments = source;
  }
}
