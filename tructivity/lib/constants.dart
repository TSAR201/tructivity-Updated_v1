import 'package:tructivity/pages/absence-page.dart';
import 'package:tructivity/pages/event-page.dart';
import 'package:tructivity/pages/schedule-page.dart';
import 'package:tructivity/pages/grades-page.dart';
import 'package:tructivity/pages/home-page.dart';
import 'package:tructivity/pages/homework-page.dart';
import 'package:tructivity/pages/note-page.dart';
import 'package:tructivity/pages/setting-page.dart';
import 'package:tructivity/pages/subject-page.dart';
import 'package:tructivity/pages/task-page.dart';
import 'package:tructivity/pages/teacher-page.dart';
import 'package:tructivity/pages/timetable-page.dart';
import 'models/drawer-item-model.dart';
import 'package:flutter/material.dart';

final List<DrawerItemModel> drawerItems = [
  drawerHome,
  drawerHomework,
  drawerEvents,
  drawerTasks,
  drawerNotes,
  drawerAbsences,
  drawerTeachers,
  drawerSubjects,
  drawerSchedule,
  drawerTimetable,
  drawerGrades,
  drawerSettings,
  drawerSignOut,
];
final DrawerItemModel drawerHome =
    DrawerItemModel(text: 'Home', iconData: Icons.home_outlined, index: 0);
final DrawerItemModel drawerHomework = DrawerItemModel(
    text: 'Homework', iconData: Icons.work_outline_outlined, index: 1);
final DrawerItemModel drawerEvents =
    DrawerItemModel(text: 'Events', iconData: Icons.event_outlined, index: 2);
final DrawerItemModel drawerTasks =
    DrawerItemModel(text: 'Tasks', iconData: Icons.task_outlined, index: 3);
final DrawerItemModel drawerNotes = DrawerItemModel(
    text: 'Notes', iconData: Icons.event_note_outlined, index: 4);
final DrawerItemModel drawerAbsences = DrawerItemModel(
    text: 'Absences', iconData: Icons.person_add_disabled_outlined, index: 5);
final DrawerItemModel drawerTeachers = DrawerItemModel(
    text: 'Teachers', iconData: Icons.person_outlined, index: 6);
final DrawerItemModel drawerSubjects =
    DrawerItemModel(text: 'Subjects', iconData: Icons.book_outlined, index: 7);

final DrawerItemModel drawerSchedule = DrawerItemModel(
    text: 'Schedule', iconData: Icons.schedule_outlined, index: 8);
final DrawerItemModel drawerTimetable = DrawerItemModel(
    text: 'Timetable', iconData: Icons.table_chart_outlined, index: 9);
final DrawerItemModel drawerGrades =
    DrawerItemModel(text: 'Grades', iconData: Icons.grade_outlined, index: 10);

final DrawerItemModel drawerSettings = DrawerItemModel(
    text: 'Settings', iconData: Icons.settings_outlined, index: 11);
final DrawerItemModel drawerSignOut = DrawerItemModel(
    text: 'Sign Out', iconData: Icons.logout_outlined, index: 12);
final List<Widget> drawerPages = [
  HomePage(),
  HomeworkPage(),
  EventPage(),
  TaskPage(),
  NotePage(),
  AbsencePage(),
  TeacherPage(),
  SubjectPage(),
  SchedulePage(),
  TimetablePage(),
  GradesPage(),
  SettingPage(),
];
final expression = RegExp(r'[+-]?([0-9]+\.?[0-9]*|\.[0-9]+)');
final intExpression = RegExp(r'^\d+$');
Color noteTextColor = Colors.white;
final List<String> gradeOptions = [
  'A+',
  'A',
  'A-',
  'B+',
  'B',
  'B-',
  'C+',
  'C',
  'C-',
  'D+',
  'D',
  'D-',
  'F'
];
final List<String> courseOptions = ['Regular', 'Honor', 'AP', 'IB', 'College'];
final List<String> creditOptions = [
  '0',
  '1',
  '1.5',
  '2',
  '2.5',
  '3',
  '3.5',
  '4',
  '4.5',
  '5',
  '5.5'
];
final List<String> repetitionOptions = ['Daily', 'Weekly', 'Monthly'];

final List<String> homeworkTypes = [
  'Homework',
  'Study',
  'Read',
  'Presentation',
  'Paper',
  'Quiz',
  'Project',
  'Other'
];

final List<String> scheduleTypes = [
  'Homework',
  'Presentation',
  'Paper',
  'Quiz',
  'Exam'
];

final Map<int, String> weekDays = {
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};
final List<int> monthDays = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
];

final List<String> allowedAudioExtensions = ['mp3', 'ogg', 'aac', 'm4a'];
final List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
final List<String> allowedDocumentExtensions = ['pdf', 'doc', 'xls', 'pptx'];
final String confirmationText = 'Are you sure you want to delete this';
final List<String> semesterOptions = ['Semester 1', 'Semester 2'];
final Map<int, String> gradingSystems = {
  1: 'Percentage Based Grade',
  2: 'Point Based Grade',
  3: 'Letter Based Grade',
  4: 'College GPA',
  5: 'High School GPA',
  6: 'High School GPA Percentage',
};
