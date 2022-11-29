import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/AppWrapper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          //Lottie.asset('assets/images/billet.json'),
          Image.asset('assets/images/logolarge.png'),
          const Text(
            'timeZmoney',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'ProstoOne',
              color: Color(0xFFDA9537),
            ),
          )
        ],
      ),

      backgroundColor: Colors.white,
      // const Color(0xFFAFF5C3),
      nextScreen: const AppWrapper(),
      splashIconSize: 250,
      duration: 4000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
