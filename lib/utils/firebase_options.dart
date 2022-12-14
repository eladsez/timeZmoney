// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyChVy7raiHlCwheI5YPfyljT3xc1pyNnXM',
    appId: '1:518913465132:web:b2caad51d70e43624cea89',
    messagingSenderId: '518913465132',
    projectId: 'timezmoney',
    authDomain: 'timezmoney.firebaseapp.com',
    storageBucket: 'timezmoney.appspot.com',
    measurementId: 'G-KRFP59B02T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTijFlXXyo9bWDjVq7lQv0I1aDYHDteDY',
    appId: '1:518913465132:android:8ace2ab8cdf9fe3b4cea89',
    messagingSenderId: '518913465132',
    projectId: 'timezmoney',
    storageBucket: 'timezmoney.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiyw9ZHAtIfgK5HX8op_lizHmMRQcQuQM',
    appId: '1:518913465132:ios:4c7d073caa7ca1184cea89',
    messagingSenderId: '518913465132',
    projectId: 'timezmoney',
    storageBucket: 'timezmoney.appspot.com',
    iosClientId: '518913465132-4u4ds8sm55kdqr7alm3raacfe34vj0ue.apps.googleusercontent.com',
    iosBundleId: 'com.example.timeZMoney',
  );
}
