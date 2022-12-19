import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../../data_access/messaging_dal.dart';

class MessageActions{


  final MessagingAccess mesa = MessagingAccess();
  static List<RemoteMessage> notifications = []; // the notification the currUser held

  static backgroundMessageHandler(){
   // TODO: seems to not listening all the time need to fix it
    // TODO: see reference here: https://github.com/HDEVCODER/fcmflutter3.3/blob/main/lib/main.dart

  }

  /*
   * This function initial and start listening for notification from fireBase messaging
   * When notification is received we will add it to the notifications list
   * and set the state of the HomeAppBar (from updateNotifications function) for the notification widget to update
   * updateNotifications - is a function to add notification to the notifications list inside the set state of HomeAppBar
   * (callback function)
   */
  void initNotification(ValueChanged<RemoteMessage> updateNotifications){
    mesa.requestPermission();
    mesa.listenForNotifications(updateNotifications);
  }

  void dispose(){
    mesa.stopListenForNotifications();
  }

}