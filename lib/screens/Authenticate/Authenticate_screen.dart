import 'package:flutter/material.dart';
import '../../utils/BackgroundGenerator.dart';
import 'components/signup&login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: const SignupLoginContent(),
      ),
    ));
  }
}
