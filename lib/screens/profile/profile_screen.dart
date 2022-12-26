import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import '../../business_Logic/actions/auth_actions.dart';
import 'components/build_user_reviews.dart';
import 'components/stats.dart';
import 'components/profile_circle.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final CustomUser user;

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

// TODO: render the image after it change
class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthActions.currUser.uid != widget.user.uid ? AppBar(
        leading: const BackButton(color: Color(0xff01b2b8)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 30,
      ): PreferredSize(preferredSize: const Size(0, 0), child: Container()),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: buildSettingButton(widget.user)),
          ProfileCircle(
            imagePath: AuthActions.currUser.uid == widget.user.uid
                ? AuthActions.currUser.profileImageURL
                : widget.user.profileImageURL,
            onClicked: () {
              switch (AuthActions.currUser.uid == widget.user.uid) {
                case true:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(updateProfile: (void dummy) {
                            setState(() {
                              AuthActions.currUser.profileImageURL =
                                  AuthActions.currUser.profileImageURL;
                            });
                          })));
                  break;
                case false:
                  break;
              }
            },
            user: widget.user,
          ),
          const SizedBox(height: 24),
          buildName(widget.user),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          Stats(widget.user),
          const SizedBox(height: 48),
          buildAbout(widget.user),
          AuthActions.currUser.uid == widget.user.uid
              ? Container()
              : BuildUserReviews(user: widget.user),
        ],
      ),
    );
  }

  Widget buildName(CustomUser user) => Column(
        children: [
          Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildSettingButton(CustomUser user) {
    if (AuthActions.currUser.uid != widget.user.uid) {
      return IconButton(onPressed: () {}, icon: const Icon(IconData(0x0)));
    }
    return IconButton(
      icon: const Icon(Icons.logout, size: 26, color: Color(0xff01b2b8)),
      onPressed: () {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return const ProfileSetting(); // add this shit
        // }));
        FirebaseAuth.instance.signOut();
      },
    );
  }

  Widget buildAbout(CustomUser user) => Container(
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
              AuthActions.currUser.uid == widget.user.uid
                  ? (user.about == "Empty"
                      ? "Your about is currently empty, Press the edit button to write it!"
                      : user.about)
                  : (user.about == "Empty"
                      ? "This user has not written anything about him/herself yet!"
                      : user.about),
              style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: user.about == "Empty" ? Colors.red : Colors.black),
            ),
          ],
        ),
      );
}
