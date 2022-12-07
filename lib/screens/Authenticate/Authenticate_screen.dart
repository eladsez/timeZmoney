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
        body: CustomPaint(painter:GreenPainter(),
        child: const SignupLoginContent(),));
  }
}
