import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/worker_dashboard_screen.dart';
import '../../business_Logic/actions/auth_actions.dart';
import '../../utils/helper_functions.dart';
import '../../utils/theme.dart';
import '../jobs_dashboard/employer_dashboard_screen.dart';
import 'home_bar.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
          Column(
            children: [
              const HomeAppbar(),
              AuthActions.currUser.userType == "worker"
                  ? const WorkerDashboardScreen() : EmployerDashboardScreen(),
            ],
          ),
        ],
      ),
    );
  }
}
