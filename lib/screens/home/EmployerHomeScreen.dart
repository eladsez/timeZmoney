import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/Jobs_dashboard_worker_screen.dart';
import 'home_bar.dart';

class EmployerHomeScreen extends StatefulWidget {

  const EmployerHomeScreen({Key? key}) : super(key: key);

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
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

            ],
          ),
        ],
      ),
    );
  }
}
