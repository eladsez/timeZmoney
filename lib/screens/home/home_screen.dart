import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/Jobs_dashboard_worker_screen.dart';
import 'home_bar.dart';

class WorkerHomeScreen extends StatefulWidget {

  const WorkerHomeScreen({Key? key}) : super(key: key);

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            children: const [
              HomeAppbar(),
              WorkerDashboardScreen(),
            ],
          ),
        ],
      ),
    );
  }
}
