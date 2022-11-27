import 'package:flutter/material.dart';
import '../AppWrapper.dart';
import 'components/signup&login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  Widget back(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/appLogo.jpg"), fit: BoxFit.cover),
      ),
      child: Center(child: FlutterLogo(size: 300)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: const [
        SignupLoginContent()
      ]),
    );
  }
}
