import 'package:flutter/material.dart';
import '/utils/helper_functions.dart';
import '../animations/change_screen_animation.dart';
import 'signup&login.dart';

class TopLogo extends StatefulWidget {
  const TopLogo({Key? key}) : super(key: key);

  @override
  State<TopLogo> createState() => _TopLogoState();
}

class _TopLogoState extends State<TopLogo> {
  @override
  void initState() {
    ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.wrapWithAnimatedBuilder(
      animation: ChangeScreenAnimation.topTextAnimation,
      child: Text(
        ChangeScreenAnimation.currentScreen == SignupLoginState.signIn
            ? 'Create Account'
            : 'Welcome Back',
        style: const TextStyle(
          fontFamily: 'ProstoOne',
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
      // child: Image.asset("assets/images/appLogo.png"),
    );
  }
}
