import 'package:firebase_core/firebase_core.dart';
import 'package:time_z_money/Business_Logic/actions/storage_actions.dart';
import 'package:time_z_money/screens/main_screen.dart';
import 'package:time_z_money/screens/splash_screen.dart';
import 'package:time_z_money/screens/template1/dashboard.dart';
import 'package:time_z_money/screens/template1/home.dart';
import 'package:time_z_money/screens/template2/home.dart';
import 'utils/firebase_options.dart';
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
    StorageAccess test = StorageAccess();
    test.uploadImage("test");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Montserrat',
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}
