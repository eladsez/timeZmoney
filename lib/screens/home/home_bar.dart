import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../business_Logic/actions/auth_actions.dart';
import '../../business_Logic/actions/message_actions.dart';

class HomeAppbar extends StatefulWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  State<HomeAppbar> createState() => _State();
}

class _State extends State<HomeAppbar> {
  final MessageActions messageActions = MessageActions();

  void updateNotifications(RemoteMessage message) {
    setState(() {
      MessageActions.notifications.add(message);
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

  void onNotificationPressed() {
    showModalBottomSheet(
        barrierColor: Colors.black.withOpacity(0.3),
        context: context,
        builder: ((context) => StatefulBuilder(
            builder: ((context, setState) => Container(
                  padding: const EdgeInsets.all(20),
                  child: MessageActions.notifications.isEmpty
                      ? const Text("No new notifications")
                      : ListView(
                          children: MessageActions.notifications.map(
                            (notification) {
                              if (notification.notification == null) {
                                return const Text("No new notifications");
                              }
                              return Column(
                                children: [
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    tileColor: Theme.of(context).primaryColor,
                                    title: Text(
                                      notification.notification!.title!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      notification.notification!.body!,
                                      style: const TextStyle(
                                          color: Colors.white60),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.transparent,
                                  )
                                ],
                              );
                            },
                          ).toList(),
                        ),
                )))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, //for responsive
          left: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Home',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AuthActions.currUser.username,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
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
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.black26,
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
                padding: const EdgeInsets.all(10.0),
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
