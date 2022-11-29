import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_z_money/data_access/DAL.dart';
import 'package:time_z_money/screens/AppWrapper.dart';
import 'package:time_z_money/screens/home/home.dart';
import 'utils/firebase_options.dart';
import 'package:time_z_money/screens/Authenticate/Authenticate_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => const AppWrapper(),
      },
    );
  }
}
