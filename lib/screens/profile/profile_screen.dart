import 'package:flutter/material.dart';
import '../../business_Logic/actions/auth_actions.dart';
import 'components/numbers_widget.dart';
import 'components/profile_widget.dart';
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
            imagePath:
                "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80",
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
          NumbersWidget(),
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
          //   return const EasySettingsWidget();
          // }));
        },
      );

  Widget buildAbout() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Anton is a CS student, very important person, love every one \nAnd every one loves him",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
