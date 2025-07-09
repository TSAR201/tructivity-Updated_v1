import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'models/event-model.dart';
import 'models/homework-model.dart';
import 'models/task-model.dart';

DateTime dateTimeFromString({required String dateTimeString}) {
  List data = dateTimeString.split('-');
  var year = int.parse(data[0]);
  var month = int.parse(data[1]);
  var day = int.parse(data[2]);
  var hour = int.parse(data[3]);
  var minute = int.parse(data[4]);
  DateTime dateTime = DateTime(year, month, day, hour, minute);
  return dateTime;
}

String stringFromDateTime({required DateTime dateTime}) {
  String dateTimeString =
      '${dateTime.year}-${dateTime.month}-${dateTime.day}-${dateTime.hour}-${dateTime.minute}';
  return dateTimeString;
}

List<NeatCleanCalendarEvent> sortEvents(
    {required List<NeatCleanCalendarEvent> eventsToSort}) {
  List<NeatCleanCalendarEvent> ev = eventsToSort;
  for (int i = 0; i < ev.length - 1; i++) {
    for (int j = 0; j < ev.length; j++) {
      if (j != ev.length - 1) {
        if (ev[j].endTime.isAfter(ev[j + 1].endTime)) {
          ev = swap(calEvents: ev, x: j, y: j + 1);
        }
      }
    }
  }
  return ev;
}

List<NeatCleanCalendarEvent> swap(
    {required List<NeatCleanCalendarEvent> calEvents,
    required int x,
    required int y}) {
  NeatCleanCalendarEvent h1 = calEvents[x];
  calEvents[x] = calEvents[y];
  calEvents[y] = h1;
  return calEvents;
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

int generateId({required Type dataType, required int id}) {
  if (dataType == HomeworkModel) {
    return id;
  } else if (dataType == EventModel) {
    return id + 1000;
  } else {
    return id + 2000;
  }
}

String getTitle({required var dataModel}) {
  var type = dataModel.runtimeType;
  if (type == TaskModel) {
    return 'Task: ${dataModel.task}';
  } else if (type == HomeworkModel) {
    return 'Homework: ${dataModel.subject}';
  } else {
    return 'Event: ${dataModel.event}';
  }
}

String getTable({required var dataModel}) {
  var type = dataModel.runtimeType;
  if (type == TaskModel) {
    return 'task';
  } else if (type == HomeworkModel) {
    return 'homework';
  } else {
    return 'event';
  }
}

String getBody({required var dataModel}) {
  return dataModel.note;
}

Map<String, dynamic> onSelectedDaysChanged(
    String repeat, List<int> selectedDays) {
  if (selectedDays.isEmpty) {
    selectedDays = [1];
  } else {
    selectedDays.sort();
  }
  String repetitionText = '';
  for (int day in selectedDays) {
    if (repeat == 'Weekly') {
      repetitionText += '${weekDays[day]!}  ';
    } else {
      repetitionText += '$day  ';
    }
  }
  return {'days': selectedDays, 'text': repetitionText};
}

List<DateTime> getDaysInBetween(String repeat, List<int> selectedDays,
    DateTime startDate, DateTime endDate) {
  List<DateTime> days = [startDate];
  for (int i = 1; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  if (repeat == 'Daily') {
    return days;
  } else if (repeat == 'Weekly') {
    List<DateTime> weekly = [];

    for (DateTime day in days) {
      if (selectedDays.contains(day.weekday)) {
        weekly.add(day);
      }
    }
    return weekly;
  } else {
    //Monthly
    List<DateTime> monthly = [];

    for (DateTime day in days) {
      if (selectedDays.contains(day.day)) {
        monthly.add(day);
      }
    }
    return monthly;
  }
}

Future<bool> setSemesterPreference(String semester) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool result = await _prefs.setString('currentSemester', semester);
  return result;
}

Future<String> getSemesterPreference() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? result = _prefs.getString('currentSemester');
  if (result == null) {
    await setSemesterPreference('Semester 1');
    result = 'Semester 1';
  }
  return result;
}

Future<int> getGradingPreference() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  int? result = _prefs.getInt('gradingSystem');
  if (result == null) {
    await setGradingPreference(1);
    result = 1;
  }
  return result;
}

Future<bool> setGradingPreference(int index) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool result = await _prefs.setInt('gradingSystem', index);
  return result;
}

Future<String> getPromodoroPreference() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? result = _prefs.getString('promodoro');
  if (result == null) {
    //25=focus, 5=break
    await setPromodoroPreference('25:5');
    result = '25:5';
  }
  return result;
}

Future<bool> setPromodoroPreference(String times) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool result = await _prefs.setString('promodoro', times);
  return result;
}
