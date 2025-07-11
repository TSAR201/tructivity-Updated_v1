import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final onDateSelected, getCalendarEvents;
  CustomCalendar(
      {required this.getCalendarEvents, required this.onDateSelected});
  @override
  Widget build(BuildContext context) {
    return Calendar(
        startOnMonday: true,
        weekDays: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
        eventsList: getCalendarEvents,
        isExpandable: true,
        selectedColor: Colors.teal,
        todayColor: Colors.teal,

        ///ff_log selectedTodayColor added, because in updated package it will show red by default
        selectedTodayColor: Colors.teal,
        eventDoneColor: Colors.grey[400],
        hideTodayIcon: true,
        eventListBuilder: (BuildContext context,
            List<NeatCleanCalendarEvent> _selectedEvents) {
          return Container(height: 0, width: 0);
        },
        eventColor: Colors.teal,
        locale: 'en_US',
        expandableDateFormat: 'EEEE, dd. MMMM yyyy',
        dayOfWeekStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
        onDateSelected: (val) {
          onDateSelected(val);
        });
  }
}
