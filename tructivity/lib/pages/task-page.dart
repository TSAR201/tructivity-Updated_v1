import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/new-task-dialog.dart';
import 'package:tructivity/models/category-model.dart';
import 'package:tructivity/models/task-model.dart';
import 'package:tructivity/functions.dart';
import 'package:tructivity/pages/category-page.dart';
import 'package:tructivity/widgets/custom-FAB.dart';
import 'package:tructivity/widgets/custom-calendar.dart';
import 'package:tructivity/widgets/custom-tile.dart';
import 'package:tructivity/widgets/filler-widget.dart';
import 'package:tructivity/widgets/loading-widget.dart';
import 'package:tructivity/widgets/task-category-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _selectedCategory = 'All';
  var _db = DatabaseHelper.instance;
  List<NeatCleanCalendarEvent> _selectedEvents = [];
  List taskData = [];
  List categoryData = [];
  late String _currentSemester;
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Future<Map<String, List>> getData() async {
    _currentSemester = await getSemesterPreference();
    var data = _db.getTaskPageData(_selectedCategory);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu_outlined,
        ),
        title: Text(
          'Tasks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CategoryPage(
                      categoryTable: 'taskCategory', dataTable: 'task');
                })).whenComplete(() {
                  setState(() {
                    _selectedCategory = 'All';
                  });
                });
              },
              icon: Icon(Icons.more_vert_outlined))
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              child: FutureBuilder(
                future: getData(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List>> snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingWidget();
                  } else {
                    var snapshotData = snapshot.data!;
                    taskData = snapshotData['taskData']!;
                    categoryData = snapshotData['categoryData']!;
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          height: 30,
                          width: double.infinity,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: displayCategories(),
                          ),
                        ),
                        _selectedEvents.isEmpty
                            ? Expanded(
                                child: FillerWidget(icon: Icons.task_outlined))
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
            CustomFAB(onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return NewTaskDialog(
                    taskData: TaskModel(
                      category: '',
                      isDone: false,
                      task: '',
                      note: '',
                      pickedDateTime: DateTime.now(),
                    ),
                  );
                },
              ).whenComplete(() {
                setState(() {});
              });
            }),
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<NeatCleanCalendarEvent>> getCalendarEvents() {
    Map<DateTime, List<NeatCleanCalendarEvent>> events = {};
    for (TaskModel model in taskData) {
      DateTime dateTime = model.pickedDateTime;
      var notificationTime;
      if (model.notificationDateTime == null) {
        notificationTime = '';
      } else {
        notificationTime =
            stringFromDateTime(dateTime: model.notificationDateTime!);
      }
      DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
      String summary = model.task;
      String description =
          "${model.note}\n${model.category}\n${model.id}\n$notificationTime";

      NeatCleanCalendarEvent event = NeatCleanCalendarEvent(
        summary,
        startTime: dateTime,
        endTime: dateTime,
        description: description,
        isDone: model.isDone,
      );
      List<NeatCleanCalendarEvent>? l = events[date];
      if (l == null) {
        l = [];
      }
      l.add(event);
      events[date] = l;
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

  List<CustomTile> getTiles() {
    List<NeatCleanCalendarEvent> ev = sortEvents(eventsToSort: _selectedEvents);
    List<CustomTile> tiles = [];
    TaskModel dataModel;
    for (NeatCleanCalendarEvent item in ev) {
      dataModel = TaskModel.fromNeatCleanCalendarEvent(item);
      tiles.add(
        CustomTile(
          currentSemester: _currentSemester,
          dataModel: dataModel,
          refreshCallback: () {
            setState(() {});
          },
        ),
      );
    }
    return tiles;
  }

  List<Widget> displayCategories() {
    List<Widget> categoryTiles = [];
    bool tileSelected = _selectedCategory == 'All';
    Color tileColor =
        tileSelected ? Theme.of(context).cardColor : Colors.transparent;

    categoryTiles.add(
      CategoryTile(
        text: 'All',
        color: tileColor,
        onTileSelected: (String category) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );

    for (CategoryModel item in categoryData) {
      tileSelected = _selectedCategory == item.category;
      tileColor =
          tileSelected ? Theme.of(context).cardColor : Colors.transparent;

      categoryTiles.add(
        CategoryTile(
          text: item.category,
          color: tileColor,
          onTileSelected: (String category) {
            setState(() {
              _selectedCategory = category;
            });
          },
        ),
      );
    }
    return categoryTiles;
  }
}
