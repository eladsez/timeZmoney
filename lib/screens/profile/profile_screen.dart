import 'package:flutter/material.dart';
import '../../business_Logic/actions/auth_actions.dart';
import 'components/stats.dart';
import 'components/profile_circle.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Align(alignment: Alignment.centerRight, child: buildSettingButton()),
          const SizedBox(
            height: 10,
          ),
          ProfileWidget(
            imagePath: AuthActions.currUser.profileImageURL,
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          const Stats(),
          const SizedBox(height: 48),
          buildAbout(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            AuthActions.currUser.username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            AuthActions.currUser.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildSettingButton() => IconButton(
        icon: const Icon(Icons.settings, size: 26, color: Color(0xff01b2b8)),
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          //   return const ProfileSetting(); // add this shit
          // }));
        },
      );

  Widget buildAbout() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AuthActions.currUser.about == "Empty"
                  ? "Your about is currently empty, Press the edit button to write it!"
                  : AuthActions.currUser.about,
              style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: AuthActions.currUser.about == "Empty"
                      ? Colors.red
                      : Colors.black),
            ),
          ],
        ),
      );
}
