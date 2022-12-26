import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/jobs_actions.dart';
import 'package:time_z_money/screens/scheduler/components/flutter_neat_and_clean_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<NeatCleanCalendarEvent>> _events;

  JobsActions jobsActions = JobsActions();
  
  @override
  void initState() {
    super.initState();
    _events = {};
    // Force selection of today on first load, so that the list of today's jobs gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: jobsActions.getCurrUserEvent(),
          builder: (context, eventListSnap) {
          List <NeatCleanCalendarEvent>? eventList = [];
          if (eventListSnap.hasData){
            eventList = eventListSnap.data;
          }
          return  SafeArea(
        child: Calendar(
          events: _events,
          bottomBarColor: Colors.white,
          bottomBarTextStyle: const TextStyle(fontFamily: 'ProstoOne'),
          startOnMonday: true,
          weekDays: const ['M0N', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
          eventsList: eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          selectedTodayColor: const Color(0xff01b2b8),
          todayColor: const Color(0xff01b2b8),
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
      );}),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
