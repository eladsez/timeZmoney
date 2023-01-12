import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/models/Job.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';

import '../../business_Logic/actions/auth_actions.dart';
import '../../business_Logic/actions/message_actions.dart';
import '../../utils/helper_functions.dart';
import '../../utils/theme.dart';

class HomeAppbar extends StatefulWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  State<HomeAppbar> createState() => _State();
}

class _State extends State<HomeAppbar> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  final MessageActions messageActions = MessageActions();

  void updateNotifications(dynamic message) {
    setState(() {
      // if the list doesn't contain this message, add it
      // we need it because we have another listener if we don't on the home_bar screen
      if (message is RemoteMessage && !MessageActions.notifications
          .map((msg) => msg.messageId)
          .toList()
          .contains(message.messageId)) {
        MessageActions.notifications.add(message);
      }
      if (message is Job) {
        MessageActions.notifications.add(message);
      }
    });
  }

  @override
  void initState() {
    messageActions.initNotification(updateNotifications);
    super.initState();
  }

  @override
  void dispose() {
    messageActions.dispose();
    super.dispose();
  }

  Widget buildNotification(String title, String body, Job? job) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            if (job != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JobDetails(
                            job: job,
                          )));
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tileColor: Theme.of(context).primaryColor,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            body,
            style: const TextStyle(color: Colors.white60),
          ),
        ),
        const Divider(
          color: Colors.transparent,
        )
      ],
    );
  }

  void onNotificationPressed() {
    showModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.3),
        context: context,
        builder: ((context) => StatefulBuilder(
            builder: ((context, setState) => Container(
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: MessageActions.notifications.isEmpty
                      ? const Text("No new notifications")
                      : ListView(
                          children: MessageActions.notifications.map(
                            (notification) {
                              if (notification is Job) {
                                return buildNotification(
                                    'You have been approved for the job',
                                    notification.title,
                                    notification);
                              }
                              if (notification.notification == null) {
                                return const Text("unavailable notification");
                              }
                              return buildNotification(
                                  notification.notification!.title!,
                                  notification.notification!.body!,
                                  null);
                            },
                          ).toList(),
                        ),
                )))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.135,
      decoration: BoxDecoration(
        color: theme.appBarColor,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 1))
        ],
      ),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, //for responsive
          left: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Home',
                  style: theme.titleTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    AuthActions.currUser.username,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: theme.nameColor),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  margin: const EdgeInsets.only(top: 40, right: 17),
                  transform: Matrix4.rotationZ(100),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Badge(
                          badgeContent: Text(
                            MessageActions.notifications.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          showBadge: true,
                          child: Icon(
                            Icons.notifications,
                            color: theme.accentColor,
                          ),
                        ),
                        onPressed: () {
                          onNotificationPressed();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipOval(
                  child: Image.network(
                    AuthActions.currUser.profileImageURL,
                    width: 50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
