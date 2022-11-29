
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/Authenticate_screen.dart';
import 'package:time_z_money/screens/home/home.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: AuthService.getLogInState(),
            initialData: FirebaseAuth.instance.currentUser,
            builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const Authenticate();
          }
        }),
      );
}