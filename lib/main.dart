import 'package:firebase_core/firebase_core.dart';
import 'package:time_z_money/screens/login&signup/login_screen.dart';
import 'package:time_z_money/utils/constants.dart';
import 'utils/firebase_options.dart';
import 'package:flutter/material.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Montserrat',
            ),
      ),
      home: const LoginScreen(),
    );
  }
}
