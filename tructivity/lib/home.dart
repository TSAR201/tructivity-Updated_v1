import 'package:tructivity/constants.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/db/database-helper.dart';
import 'package:tructivity/dialogs/allow-notifications-dialog.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:tructivity/widgets/custom-drawer.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slider_drawer_v/flutter_slider_drawer_v.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    setQuickActions();
    initializeQuickActions();
    checkNotificationAllowed();
    listenToNotificationDisplayedStream();
    listenToNotificationActionStream();
    setInitialDrawerIndex();
  }

  final GlobalKey<CustomDrawerState> _drawerKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    ///ff_log below lines commented,removed in updated package
    // AwesomeNotifications().actionSink.close();
    // AwesomeNotifications().displayedSink.close();
  }

  int? _currentIndex;
  SharedPreferences? prefs;
  final quickActions = QuickActions();

  final GlobalKey<SliderMenuContainerState> _sliderKey =
      new GlobalKey<SliderMenuContainerState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _currentIndex == null
          ? Container()
          : SliderMenuContainer(
              hasAppBar: false,
              key: _sliderKey,
              sliderMenu: CustomDrawer(
                initialIndex: _currentIndex!,
                onSwipe: closeDrawer,
                key: _drawerKey,
                onItemClick: (index) {
                  closeDrawer();
                  setState(() {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _currentIndex = index;
                  });
                },
              ),
              sliderMain: Stack(
                alignment: Alignment.topLeft,
                children: [
                  drawerPages[_currentIndex!],
                  SafeArea(
                    child: TextButton(
                      onPressed: () {
                        if (_sliderKey.currentState!.isDrawerOpen) {
                          closeDrawer();
                        } else {
                          openDrawer();
                        }
                      },
                      child: Text(''),
                    ),
                  ),
                ],
              )),
    );
  }

  void openDrawer() {
    //opening drawer from the setting page will refresh the drawer
    if (_currentIndex == drawerSettings.index) {
      _drawerKey.currentState!.refreshDrawer();
    }
    _sliderKey.currentState!.openDrawer();
  }

  void closeDrawer() {
    _sliderKey.currentState!.closeDrawer();
  }

  Future<void> removeNotification(
      {required String table, required String id}) async {
    final _db = DatabaseHelper.instance;
    await _db.removeNotification(table: table, id: id);
  }

  void listenToNotificationActionStream() {
    ///f_log below lines commented due to actionStream not found, replaced by AwesomeNotifications().setListeners
    // AwesomeNotifications().actionStream.listen(
    //   (event) async {
    //     await Future.delayed(
    //       Duration(milliseconds: 500),
    //     ); //delay to allow methods to finish so that updated data is displayed
    //     String title = event.title!.split(':')[0];
    //     late String table;
    //     late int id;
    //     late int index;
    //     if (title == 'Homework') {
    //       table = 'homework';
    //       id = event.id!;
    //       index = drawerHomework.index;
    //     }
    //     if (title == 'Event') {
    //       table = 'event';
    //       id = event.id! - 1000;
    //       index = drawerEvents.index;
    //     }
    //     if (title == 'Task') {
    //       table = 'task';
    //       id = event.id! - 2000;
    //       index = drawerTasks.index;
    //     }
    //
    //     if (prefs != null) {
    //       if (prefs!.getBool(index.toString())!) {
    //         setState(() {
    //           _currentIndex = index;
    //           _drawerKey.currentState!.changeSelected(index);
    //         });
    //       }
    //     }
    //   },
    // );
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction event) async {
        print("t_log: 1:");
        await Future.delayed(
          Duration(milliseconds: 500),
        ); //delay to allow methods to finish so that updated data is displayed
        String title = event.title!.split(':')[0];
        late String table;
        late int id;
        late int index;
        if (title == 'Homework') {
          table = 'homework';
          id = event.id!;
          index = drawerHomework.index;
        }
        if (title == 'Event') {
          table = 'event';
          id = event.id! - 1000;
          index = drawerEvents.index;
        }
        if (title == 'Task') {
          table = 'task';
          id = event.id! - 2000;
          index = drawerTasks.index;
        }

        if (prefs != null) {
          if (prefs!.getBool(index.toString())!) {
            setState(() {
              _currentIndex = index;
              _drawerKey.currentState!.changeSelected(index);
            });
          }
        }
      },
      onNotificationCreatedMethod: (ReceivedNotification receivedNotification) async{
        print("t_log: 2:");
      },
      onNotificationDisplayedMethod:(ReceivedNotification receivedNotification) async{
        print("t_log: 3:");
      } ,
      onDismissActionReceivedMethod: ( ReceivedAction receivedAction) async{
        print("t_log: 4:");
    }
    );
  }

  void listenToNotificationDisplayedStream() {
    // AwesomeNotifications().displayedStream.listen((event) async {
    //   String title = event.title!.split(':')[0];
    //   String table = title.toLowerCase();
    //   int eventId = event.id!;
    //   if (title == 'Homework') {
    //     await removeNotification(table: table, id: eventId);
    //   }
    //   if (title == 'Event') {
    //     await removeNotification(table: table, id: eventId - 1000);
    //   }
    //   if (title == 'Task') {
    //     await removeNotification(table: table, id: eventId - 2000);
    //   }
    // });
  }

  void checkNotificationAllowed() {
    AwesomeNotifications().isNotificationAllowed().then((allowed) {
      if (!allowed) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AllowNotificationsDialog(),
        );
      }
    });
  }

  void setQuickActions() {
    quickActions.setShortcutItems([
      ShortcutItem(
          type: 'Tasks', localizedTitle: 'Tasks', icon: 'outline_task'),
      ShortcutItem(
          type: 'Timetable',
          localizedTitle: 'Timetable',
          icon: 'outline_tablechart'),
      ShortcutItem(
          type: 'Schedule',
          localizedTitle: 'Schedule',
          icon: 'outline_schedule'),
      ShortcutItem(
          type: 'Notes', localizedTitle: 'Notes', icon: 'outline_event_note'),
    ]);
  }

  void initializeQuickActions() {
    quickActions.initialize(
      (type) async {
        if (type == 'Tasks') {
          int index = drawerTasks.index;
          if (prefs != null) {
            if (prefs!.getBool(index.toString())!) {
              setState(() {
                _currentIndex = index;
                _drawerKey.currentState!.changeSelected(index);
              });
            }
          }
        } else if (type == 'Timetable') {
          int index = drawerTimetable.index;

          if (prefs != null) {
            if (prefs!.getBool(index.toString())!) {
              setState(() {
                _currentIndex = index;
                _drawerKey.currentState!.changeSelected(index);
              });
            }
          }
        } else if (type == 'Schedule') {
          int index = drawerSchedule.index;

          if (prefs != null) {
            if (prefs!.getBool(index.toString())!) {
              setState(() {
                _currentIndex = index;
                _drawerKey.currentState!.changeSelected(index);
              });
            }
          }
        } else if (type == 'Notes') {
          int index = drawerNotes.index;
          if (prefs != null) {
            if (prefs!.getBool(index.toString())!) {
              setState(() {
                _currentIndex = index;
                _drawerKey.currentState!.changeSelected(index);
              });
            }
          }
        }
      },
    );
  }

  void setInitialDrawerIndex() async {
    prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < drawerItems.length; i++) {
      bool? x = prefs!.getBool(i.toString());
      if (x == null) {
        setState(() {
          _currentIndex = 0;
        });
        break;
      }
      if (x == true) {
        setState(() {
          _currentIndex = i;
        });
        break;
      }
    }
  }
}
