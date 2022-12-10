import 'package:flutter/material.dart';
import 'package:time_z_money/Business_Logic/models/CustomUser.dart';
import 'components/button_widget.dart';
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
          const SizedBox(
            height: 20,
          ),
          ProfileWidget(
            imagePath:
                "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80",
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          buildName(CustomUser(username: "", email: "", hashPass: "")),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(CustomUser(username: "", email: "", hashPass: "")),
        ],
      ),
    );
  }

  Widget buildName(CustomUser user) => Column(
        children: const [
          Text(
            "anton",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 4),
          Text(
            "anton@gmail.com",
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'hehehe',
        onClicked: () {},
      );

  Widget buildAbout(CustomUser user) => Container(
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
