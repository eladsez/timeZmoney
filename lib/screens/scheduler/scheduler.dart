import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/jobs_actions.dart';
import 'package:time_z_money/screens/scheduler/components/flutter_neat_and_clean_calendar.dart';

import '../../utils/helper_functions.dart';
import '../../utils/theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
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
      backgroundColor: theme.backgroundColor,
      body: FutureBuilder(
        future: jobsActions.getCurrUserEvent(),
          builder: (context, eventListSnap) {
          List <NeatCleanCalendarEvent>? eventList = [];
          if (eventListSnap.hasData){
            eventList = eventListSnap.data;
          }
          return  SafeArea(
        child: Calendar(
          bottomBarArrowColor: theme.secondaryIconColor,
          events: _events,
          bottomBarColor: theme.appBarColor,
          bottomBarTextStyle: TextStyle(fontFamily: 'ProstoOne', color: theme.titleColor),
          startOnMonday: true,
          weekDays: const ['M0N', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
          eventsList: eventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: theme.accentColor!.withOpacity(0.5),
          selectedTodayColor: theme.accentColor,
          todayColor: Colors.red,
          eventColor: theme.accentColor,
          locale: 'en_US',
          todayButtonText: 'Today',
          allDayEventText: 'All the day',
          multiDayEndText: 'End',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          datePickerType: DatePickerType.date,
          defaultDayColor: theme.textFieldTextColor,
          defaultOutOfMonthDayColor: theme.accentColor,

          displayMonthTextStyle: TextStyle(fontFamily: 'ProstoOne', color: theme.titleColor),
          dayOfWeekStyle: TextStyle(
              color: theme.titleColor, fontWeight: FontWeight.w800, fontSize: 11),
        ),
      );}),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
