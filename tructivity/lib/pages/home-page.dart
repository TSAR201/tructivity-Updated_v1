import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/models/event-model.dart';
import 'package:tructivity/models/homework-model.dart';
import 'package:tructivity/models/task-model.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/widgets/custom-calendar.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:tructivity/widgets/homepage-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:flutter/widgets.dart';
import 'package:tructivity/widgets/loading-widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  Map<String, List> allData = {};
  List homeworkData = [];
  List taskData = [];
  List eventData = [];
  List<NeatCleanCalendarEvent> _selectedEvents = [];
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late String _currentSemester;
  Future<Map<String, List>> getData() async {
    _currentSemester = await getSemesterPreference();
    var data = await _db.getHomePageData();
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
          'Home',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, List>> snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            } else {
              allData = snapshot.data!;
              homeworkData = allData['homework']!;
              taskData = allData['task']!;
              eventData = allData['event']!;
              return Column(
                children: [
                  CustomCalendar(
                    getCalendarEvents: getCalendarEvents(),
                    onDateSelected: (val) {
                      setState(() {
                        _selectedDate = val;
                      });
                    },
                  ),
                  _selectedEvents.isEmpty
                      ? Expanded(
                          child: FillerWidget(icon: Icons.home_outlined),
                        )
                      : Expanded(
                          child: ListView(
                            children: getTiles(),
                          ),
                        ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Map<DateTime, List<NeatCleanCalendarEvent>> getCalendarEvents() {
    Map<DateTime, List<NeatCleanCalendarEvent>> events = {};
    List modelLists = [
      homeworkData,
      taskData,
      eventData,
    ]; //list of lists containing all the data models
    for (var models in modelLists) {
      for (var model in models) {
        DateTime dateTime = model.pickedDateTime;
        DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
        String summary = '';
        String description = '';
        Map<String, String> dataMap = parseDataModel(model);
        summary = dataMap['summary']!;
        description = dataMap['description']!;

        NeatCleanCalendarEvent event = NeatCleanCalendarEvent(
          summary,
          startTime: dateTime,
          endTime: dateTime,
          description: description,
          isDone: model.isDone,
          location: model.id.toString(),
        );
        List<NeatCleanCalendarEvent>? l = events[date];
        if (l == null) {
          l = [];
        }
        l.add(event);
        events[date] = l;
      }
    }
    if (events[_selectedDate] != null) {
      if (events[_selectedDate]!.isNotEmpty) {
        _selectedEvents = events[_selectedDate]!;
      } else {
        _selectedEvents = [];
      }
    } else {
      _selectedEvents = [];
    }
    return events;
  }

  List<HomePageTile> getTiles() {
    List<NeatCleanCalendarEvent> sortedEvents =
        sortEvents(eventsToSort: _selectedEvents);
    List<HomePageTile> tiles = [];
    for (NeatCleanCalendarEvent item in sortedEvents) {
      tiles.add(
        HomePageTile(
            currentSemester: _currentSemester,
            dateTime: item.endTime,
            description: item.summary,
            title: item.description,
            isDone: item.isDone,
            id: item.location,
            refreshCallback: () {
              setState(() {});
            }),
      );
    }
    return tiles;
  }

  Map<String, String> parseDataModel(var model) {
    String summary = '', description = '';
    if (model.runtimeType == HomeworkModel) {
      summary = model.subject;
      description = 'Homework';
    } else if (model.runtimeType == TaskModel) {
      summary = model.task;
      description = 'Task';
    } else if (model.runtimeType == EventModel) {
      summary = model.event;
      description = 'Event';
    }
    return {
      'summary': summary,
      'description': description,
    };
  }
}
