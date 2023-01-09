import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/chat/chat_main.dart';
import 'package:time_z_money/screens/jobs_dashboard/search_job_screen.dart';
import 'package:time_z_money/screens/profile/profile_screen.dart';
import 'package:time_z_money/screens/scheduler/scheduler.dart';
import 'package:time_z_money/screens/upload_job/upload_job_screen.dart';

import '../business_Logic/actions/auth_actions.dart';
import '../utils/helper_functions.dart';
import '../utils/theme.dart';
import 'home/home_screen.dart';

enum BottomNavigationBarState {
  home,
  explore,
  jobPosting,
  scheduler,
  chat,
  searchJob,
  dummy,
  profile, // need to modify
  error
}

/*
 This class is responsible about the app Navigation Bar and the Navigation between the app screens
 Here we will check which user is connected and build the screens for him (also depend if he is worker or employer)
 */
class MainScreen extends StatefulWidget {
  MainScreen({Key? key, required this.theme}) : super(key: key);

  AppTheme theme;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavigationBarState selectedNavBar = BottomNavigationBarState.home;

  @override
  void initState() {
    super.initState();
  }

  // This method is responsible for the bottom navigation icons.
  List<Widget> buildNavigationIcons() {
    return AuthActions.currUser.userType == "worker"
        ? [
      Icon(Icons.home, size: 26, color: widget.theme.accentColor),
      Icon(Icons.calendar_month_outlined,
          size: 26, color: widget.theme.accentColor),
      Icon(Icons.search, size: 28, color: widget.theme.accentColor),
      Icon(Icons.chat_bubble_outline_sharp,
          size: 26, color: widget.theme.accentColor),
      Icon(Icons.person_outline_rounded,
          size: 26, color: widget.theme.accentColor),
    ]
        : [
      Icon(Icons.home, size: 26, color: widget.theme.accentColor),
      Icon(Icons.calendar_month_outlined, size: 26, color: widget.theme.accentColor),
      Icon(Icons.add_outlined, size: 28, color: widget.theme.accentColor),
      Icon(Icons.chat_bubble_outline_sharp,
          size: 26, color: widget.theme.accentColor),
      Icon(Icons.person_outline_rounded,
          size: 26, color: widget.theme.accentColor),
    ];
  }

  /*
  This function build the body of are app depend on the selectedNavBar
   */
  Widget bodyBuilder() {
    switch (selectedNavBar) {
      case BottomNavigationBarState.home:
        return const HomeScreen();
      case BottomNavigationBarState.profile:
        return ProfileScreen(user: AuthActions.currUser, callBack: refresh,);
      case BottomNavigationBarState.jobPosting:
        return const UploadJobScreen();
      case BottomNavigationBarState.scheduler:
        return const CalendarScreen();
      case BottomNavigationBarState.chat:
        return const ChatScreen();
      case BottomNavigationBarState.searchJob:
        return const SearchJobScreen();
      default:
        return Container();
    }
  }

  refresh(AppTheme theme) {
    setState(() {widget.theme = theme;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyBuilder(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: CurvedNavigationBar(
          color: widget.theme.appBarColor!,
          backgroundColor: widget.theme.secondaryIconColor!,
          buttonBackgroundColor: widget.theme.cardColor,
          height: 50,
          items: buildNavigationIcons(),
          animationDuration: const Duration(microseconds: 200),
          index: 0,
          // initial index
          animationCurve: Curves.bounceInOut,
          onTap: (index) {
            setState(
                  () {
                switch (index) {
                  case 0:
                    selectedNavBar = BottomNavigationBarState.home;
                    break;
                  case 1:
                    selectedNavBar = BottomNavigationBarState.scheduler;
                    break;
                  case 2:
                  //TODO: implement 2 of worker
                    selectedNavBar = AuthActions.currUser.userType == "employer"
                        ? BottomNavigationBarState.jobPosting
                        :BottomNavigationBarState.searchJob;
                    break;
                  case 3:
                    selectedNavBar = BottomNavigationBarState.chat;
                    break;

                  case 4:
                    selectedNavBar = BottomNavigationBarState.profile;
                    break;
                  default:
                    selectedNavBar = BottomNavigationBarState.error;
                }
              },
            );
          },
        ),
      ),
    );
  }
}
