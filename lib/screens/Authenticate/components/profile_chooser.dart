import 'package:flutter/material.dart';
import 'package:time_z_money/utils/BackgroundGenerator.dart';

import '../../../business_Logic/actions/auth_actions.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';
import '../../home/home_screen.dart';
import '../../main_screen.dart';

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
            fixedSize: Size(widthScreenSize - 100, 100),
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
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_circle_right_sharp),
            onPressed: () async {
              if (selectedUserProfile == null) {
                return; // in case he didn't choose anything (should be popup or something)
              }
              if (!AuthActions.googleSignIn) {
                String firstSignUpCode =
                    await authActions.chooseProfile(selectedUserProfile!);
                if (firstSignUpCode != "OK") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(firstSignUpCode),
                    backgroundColor: Colors.red,
                    duration: const Duration(milliseconds: 1500),
                  ));
                }
                Navigator.pop(context); // pop the profileChooserScreen
              } else {
                await authActions.signupSecondStage(
                    userType: (selectedUserProfile == UserProfile.employer)
                        ? "employer"
                        : "worker");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(
                          theme: HelperFunctions.isDarkMode
                              ? DarkTheme()
                              : LightTheme()),
                    ));
              }
            }),
        // body: CustomPaint(
        //   painter: GreenPainter(),
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.9],
              colors: [
                Color(0xff60f8ff),
                Colors.yellow,
              ],
            )),
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
                  typeButton("Worker", workerColor, workerChoice),
                  const SizedBox(
                    height: 20,
                  ),
                  typeButton("Employer", employerColor, employerChoice),
                ],
              ),
            ),
          ),
        ));
  }
}
