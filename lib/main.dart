import 'package:firebase_core/firebase_core.dart';
import 'package:time_z_money/screens/splash_screen.dart';
import 'package:time_z_money/screens/upload_job/upload_job_screen.dart';
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
        '/': (context) => const UploadJobScreen(),
      },
    );
  }
}
