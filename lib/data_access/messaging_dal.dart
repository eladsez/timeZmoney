import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class MessagingAccess {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  late final StreamSubscription<RemoteMessage> listener;


  Future<bool> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      return true;
    } else {
      print('User declined or has not accepted permission');
      return false;
    }
  }

  void listenForNotifications(ValueChanged<RemoteMessage> updateNotifications) async {
    listener = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        updateNotifications(message);
        print("NOTIFICATION: ${notification.title}");
      }
    });
  }

  void stopListenForNotifications(){
    listener.cancel();
  }
}
