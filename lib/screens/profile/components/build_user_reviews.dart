import 'package:flutter/material.dart';

import '../../../business_Logic/models/CustomUser.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';

class BuildUserReviews extends StatefulWidget {
  const BuildUserReviews({super.key, required this.user});

  final CustomUser user;

  @override
  State<BuildUserReviews> createState() => _BuildUserReviewsState();
}

class _BuildUserReviewsState extends State<BuildUserReviews> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 0.5,
            width: double.infinity,
            color: theme.secondaryIconColor,
            margin: const EdgeInsets.symmetric(vertical: 5),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Reviews",
            style: TextStyle(
                fontSize: 20, color: theme.titleColor, fontWeight: FontWeight.bold),
          ),
          // add separator
          Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.black12,
            margin: const EdgeInsets.symmetric(vertical: 5),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                //TODO: add the reviews to the firestore so we can get them from there.
                return ListTile(
                  // put a dammy review
                  title: Text(
                    "This is a review",
                    style: TextStyle(fontSize: 18, color: theme.textFieldTextColor),
                  ),

                );
              }
          ),
        ]
    );
  }
}
