import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/utils/helper_functions.dart';

import '../../business_Logic/actions/auth_actions.dart';
import '../../utils/theme.dart';
import 'components/build_user_reviews.dart';
import 'components/contact_button.dart';
import 'components/profile_circle.dart';
import 'components/stats.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user, this.callBack});

  final CustomUser user;
  final Function? callBack;

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

// TODO: render the image after it change
class ProfileScreenState extends State<ProfileScreen> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (AuthActions.currUser.uid != widget.user.uid && widget.user.userType == 'employer')
          ? ContactButton(user: widget.user, theme: theme)
          : Container(),
      backgroundColor: theme.backgroundColor,
      appBar: AuthActions.currUser.uid != widget.user.uid
          ? AppBar(
              leading: BackButton(color: theme.backArrowColor),
              backgroundColor: theme.appBarColor,
              elevation: theme.elevation,
              toolbarHeight: (MediaQuery.of(context).size.height * 0.135) / 2,
            )
          : AppBar(
              backgroundColor: theme.appBarColor,
              elevation: theme.elevation,
              toolbarHeight: (MediaQuery.of(context).size.height * 0.135) / 2,
              actions: [
                buildTrailingButtons(widget.user),
              ],
            ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 20,
          ),
          ProfileCircle(
            theme: theme,
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
          Stats(user: widget.user, theme: theme),
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
            style: TextStyle(
                color: theme.nameColor,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              color: theme.emailColor,
            ),
          )
        ],
      );

  Widget buildTrailingButtons(CustomUser user) {
    if (AuthActions.currUser.uid != widget.user.uid) {
      return IconButton(onPressed: () {}, icon: const Icon(IconData(0x0)));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: _onThemeIconTap,
          icon: Icon(
            HelperFunctions.isDarkMode
                ? Icons.brightness_4_outlined
                : Icons.dark_mode_outlined,
            color: theme.themeIconColor,
          ),
        ),
        IconButton(
          icon: Icon(Icons.logout, size: 26, color: theme.mainIconColor),
          onPressed: () {
            AuthActions().signOut();
          },
        ),
      ],
    );
  }

  Widget buildAbout(CustomUser user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(
                color: theme.titleColor,
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
                  color: user.about == "Empty"
                      ? Colors.red
                      : theme.textFieldTextColor),
            ),
          ],
        ),
      );

  void _onThemeIconTap() {
    setState(() {
      HelperFunctions.toggleDarkMode();
      theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
      widget.callBack!(theme);
    });
  }
}
