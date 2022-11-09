import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/Authenticate.dart';
import 'package:time_z_money/screens/home/home.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: AuthService.getUser(),
            builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return Authenticate();
          }
        }),
      );
}
