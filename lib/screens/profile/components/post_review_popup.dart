import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/profile/components/xpopup/appbar.dart';
import 'package:time_z_money/screens/profile/components/xpopup/card.dart';
import 'package:time_z_money/screens/profile/components/xpopup/gutter.dart';

import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';

class PostReviewPopUp {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();

  XenCardAppBar buildReviewBar() => XenCardAppBar(
        shadow: const BoxShadow(color: Colors.transparent),
        child: Text(
          "Post Review",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: theme.titleColor),
        ),
      );

  XenCardGutter buildGutter() => XenCardGutter(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {},
            child: Material(
              borderRadius: BorderRadius.circular(5),
              color: theme.accentColor,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Center(
                    child: Text("post",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget postReviewPopUp(context) => TextButton(
        onPressed: () => showDialog(
          context: context,
          builder: (builder) => XenPopupCard(
            appBar: buildReviewBar(),
            gutter: buildGutter(),
            body: ListView(
              children: const [
                Text("body"),
              ],
            ),
          ),
        ),
        child: const Text("open card with gutter and app bar"),
      );
}
