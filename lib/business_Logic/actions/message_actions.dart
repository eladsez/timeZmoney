import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_z_money/business_Logic/actions/jobs_actions.dart';
import 'package:time_z_money/business_Logic/models/Job.dart';
import '../../data_access/messaging_dal.dart';
import 'auth_actions.dart';

class MessageActions{


  final MessagingAccess mesa = MessagingAccess();
  final JobsActions jobsActions = JobsActions();
  static List notifications = []; // the notification the currUser held


  static backgroundMessageHandler(){
   // TODO: seems to not listening all the time need to fix it
    // TODO: see reference here: https://github.com/HDEVCODER/fcmflutter3.3/blob/main/lib/main.dart

  }

  void findNewApprovals(updateNotifications) async{
    List<Job> jobs = await jobsActions.getFutureJobsApproved(AuthActions.currUser);
    for (Job job in jobs){
      for (String uid_seen in job.approvedWorkers){
        if (uid_seen.contains(AuthActions.currUser.uid!) && uid_seen.split(",")[1] == "unseen"){
          updateNotifications(job);
          jobsActions.updateUnseenToSeen(job);
          break;
        }
      }
    }
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