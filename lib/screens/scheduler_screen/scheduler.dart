import 'dart:math';
import 'package:flutter/material.dart';
import 'package:time_z_money/calendar/flutter_neat_and_clean_calendar.dart';
import 'package:time_z_money/screens/scheduler_screen/AddTasksView.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<NeatCleanCalendarEvent>> _events;
  final List<NeatCleanCalendarEvent> _todaysEvents = [
    NeatCleanCalendarEvent('Dog Walker Jason',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 12, 0),
        description: 'Hello',
        location: 'Bograshov 7 Tel Aviv',
        color: Colors.blue[700]),
  ];

  final List<NeatCleanCalendarEvent> _eventList = [
    NeatCleanCalendarEvent('BabySitter Jessica',
        description: 'Ramat Hagolan 25 Ariel',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 12, 0),
        color: Colors.orange,
        isMultiDay: true),
    NeatCleanCalendarEvent('Waiter David wedding',
        description: 'Neve Shaaane 35 Ariel',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day - 2, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 17, 0),
        color: Colors.pink,
        isAllDay: true),
    NeatCleanCalendarEvent('Dog Walker Jason',
        description: 'Bograshov 7 Tel Aviv',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 17, 0),
        color: Colors.purpleAccent),
    NeatCleanCalendarEvent('Normal Event E',
        description: 'test desc',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 7, 45),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 9, 0),
        color: Colors.indigo),
  ];

  @override
  void initState() {
    super.initState();
    _events = {};
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Calendar(
          events: _events,
          bottomBarColor: const Color(0xff7fdded),
          bottomBarTextStyle: const TextStyle(fontFamily: 'ProstoOne'),
          startOnMonday: true,
          weekDays: const ['M0N', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
          eventsList: _eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          selectedTodayColor: const Color(0xFFF9A825),
          todayColor: Colors.blue,
          eventColor: null,
          locale: 'en_US',
          todayButtonText: 'Today',
          allDayEventText: 'All the day',
          multiDayEndText: 'End',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          datePickerType: DatePickerType.date,
          dayOfWeekStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Add Job"),
            // content: TextFormField(
            //   controller: _eventController,
            // ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                onPressed: () {  },
                child: const Text("Ok"),
                // onPressed: () {
                //   if (_eventController.text.isEmpty) {
                //
                //   } else {
                //     if (selectedEvents[selectedDay] != null) {
                //       selectedEvents[selectedDay].add(
                //         Event(title: _eventController.text),
                //       );
                //     } else {
                //       selectedEvents[selectedDay] = [
                //         Event(title: _eventController.text)
                //       ]
                //       ;
                //     }
                //
                //   }
                //   Navigator.pop(context);
                //   _eventController.clear();
                //   setState((){});
                //   return;
                // },
              ),
            ],
          ),
        ),
        label: const Text("Add Job"),

        backgroundColor: const Color(0xff7fdded),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}

 AddTaskpopUp() async {
  await AddTaskpopUp(

  );

}