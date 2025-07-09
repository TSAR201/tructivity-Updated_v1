import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/timetable-dialog.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/models/timetable-data-model.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tructivity/widgets/loading-widget.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

DateTime today = DateTime.now();
DateTime start =
    DateTime(today.year, today.month, today.day, today.hour, today.minute);

class _TimetablePageState extends State<TimetablePage> {
  List<Appointment> l = [];
  DatabaseHelper _db = DatabaseHelper.instance;
  List<TimetableDataModel> timetableData = [];
  late String _currentSemester;
  Future<List<TimetableDataModel>> _getData() async {
    _currentSemester = await getSemesterPreference();
    List<TimetableDataModel> data = await _db.getTimetableData();
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
          'Timetable',
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
      body: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<TimetableDataModel>> snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          } else {
            timetableData = snapshot.data!;
            return SfCalendar(
              viewHeaderStyle: ViewHeaderStyle(
                  dateTextStyle: TextStyle(color: Colors.transparent)),
              minDate: DateTime(2021, 9, 6),
              maxDate: DateTime(2021, 9, 13),
              initialDisplayDate: DateTime(2021, 9, 5),
              viewNavigationMode: ViewNavigationMode.none,
              dataSource: CustomDataSource(getAppointments()),
              firstDayOfWeek: 1,
              headerHeight: 0,
              timeSlotViewSettings: TimeSlotViewSettings(
                timeInterval: Duration(hours: 1),
                timeIntervalHeight: 80,
              ),
              selectionDecoration: BoxDecoration(),
              view: CalendarView.week,
              onTap: (tile) async {
                if (tile.appointments != null) {
                  List appointments = tile.appointments!;
                  if (appointments.isNotEmpty) {
                    TimetableDataModel model = getModelById(appointments[0].id);
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return TimetableDialog(
                          semester: _currentSemester,
                          timetableData: model,
                        );
                      },
                    ).whenComplete(() {
                      setState(() {});
                    });
                  }
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return TimetableDialog(
                        semester: _currentSemester,
                        timetableData: TimetableDataModel(
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
                      );
                    },
                  ).whenComplete(() {
                    setState(() {});
                  });
                }
              },
            );
          }
        },
      ),
    );
  }

  List<Appointment> getAppointments() {
    List<Appointment> appointments = [];
    for (TimetableDataModel model in timetableData) {
      appointments.add(
        Appointment(
          startTime: model.start,
          endTime: model.end,
          color: model.color,
          id: model.id,
          notes: model.note,
          location: model.room,
          subject: model.subject + '\n' + model.room,
        ),
      );
    }

    return appointments;
  }

  getModelById(int id) {
    for (TimetableDataModel model in timetableData) {
      if (id == model.id) {
        return model;
      }
    }
  }

  Future<void> clearAll() async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
          text: 'Are you sure you want to delete all of these subjects?'),
    ).then((confirmed) async {
      if (confirmed != null) {
        if (confirmed) {
          for (TimetableDataModel data in timetableData) {
            await _db.remove(table: 'timetable', id: data.id!);
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
