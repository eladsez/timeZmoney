import 'package:flutter/material.dart';
import 'package:time_z_money/Business_Logic/actions/auth_actions.dart';
import 'package:time_z_money/utils/BackgroundGenerator.dart';

import '../../home/home.dart';

enum UserProfile {
  worker,
  employer,
}

class ProfileChooserScreen extends StatefulWidget {
  const ProfileChooserScreen({Key? key}) : super(key: key);

  @override
  State<ProfileChooserScreen> createState() => _ProfileChooserScreenState();
}

class _ProfileChooserScreenState extends State<ProfileChooserScreen> {
  Color employerColor = Colors.grey;
  Color workerColor = Colors.grey;
  UserProfile? selectedUserProfile;
  Text description = const Text('\n\n\n\n');
  late double widthScreenSize;
  AuthActions authActions = AuthActions();

  void workerChoice() {
    selectedUserProfile = UserProfile.worker;
    setState(() {
      description = const Text(
        'Worker profile will allow you to view jobs and communicate with employers for work',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'IBMPlex', fontSize: 25),
      );
      workerColor = const Color(0xFFEB9F40);
      employerColor = Colors.grey;
    });
  }

  void employerChoice() {
    selectedUserProfile = UserProfile.employer;
    setState(() {
      description = const Text(
        'An employer profile will allow you to post gigs and find employees',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'IBMPlex', fontSize: 25),
      );
      employerColor = const Color(0xFFEB9F40);
      workerColor = Colors.grey;
    });
  }

  Widget getTitle() {
    return const Text(
      "Choose your profile",
      style: TextStyle(
        color: Colors.black,
        fontSize: 35,
        fontFamily: 'ProstoOne',
      ),
    );
  }

  Widget typeButton(String text, Color color, Function func) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
      child: ElevatedButton(
        onPressed: () => func(),
        style: ElevatedButton.styleFrom(
            primary: color,
            fixedSize: Size(widthScreenSize - 70, 100),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(
          text,
          style: const TextStyle(fontSize: 25, fontFamily: 'SecularOne'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widthScreenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        if (selectedUserProfile == null) return; // in case he didn't choose anything (should be popup or something)
        await authActions.chooseProfile(selectedUserProfile!);
        Navigator.pop(context); // pop the profileChooserScreen
      }),
      body: CustomPaint(
        painter: GreenPainter(),
        child: Container(
          // margin: const EdgeInsets.only(top: 100),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getTitle(),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 300,
                child: Center(child: description),
              ),
              const SizedBox(
                height: 50,
              ),
              typeButton("Worker", workerColor, workerChoice),
              const SizedBox(
                height: 20,
              ),
              typeButton("Employer", employerColor, employerChoice),
            ],
          ),
        ),
      ),
    );
  }
}
