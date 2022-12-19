import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/profile/profile_screen.dart';
import 'package:time_z_money/screens/scheduler/scheduler.dart';
import 'home/home_screen.dart';

enum BottomNavigationBarState {
  home,
  explore,
  jobPosting,
  scheduler,
  dummy,
  profile, // need to modify
  error
}
/*
 This class is responsible about the app Navigation Bar and the Navigation between the app screens
 Here we will check which user is connected and build the screens for him (also depend if he is worker or employer)
 */
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  BottomNavigationBarState selectedNavBar = BottomNavigationBarState.home;


  @override
  void initState() {
    super.initState();
  }

  /*
  This function build the body of are app depend on the selectedNavBar
   */
  Widget bodyBuilder() {
    switch (selectedNavBar) {
      case BottomNavigationBarState.home:
        return const HomeScreen();
      case BottomNavigationBarState.profile:
        return const ProfileScreen();
      case BottomNavigationBarState.scheduler:
        return const CalendarScreen();
      // case BottomNavigationBarState.setting:
      //   return const Settings();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyBuilder(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: CurvedNavigationBar(
          color: Colors.white,
          backgroundColor: Colors.grey.withOpacity(0.1),
          buttonBackgroundColor: Colors.yellow,
          height: 50,
          items: const <Widget>[
            Icon(Icons.home, size: 26, color: Color(0xff01b2b8)),
            Icon(Icons.calendar_month_outlined, size: 26, color: Color(0xff01b2b8)),
            Icon(Icons.add_outlined, size: 28, color: Color(0xff01b2b8)),
            Icon(Icons.chat_bubble_outline_sharp,
                size: 26, color: Color(0xff01b2b8)),
            Icon(Icons.person_outline_rounded,
                size: 26, color: Color(0xff01b2b8)),
          ],
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
