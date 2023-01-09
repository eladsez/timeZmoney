import 'package:flutter/material.dart';

import '../../../business_Logic/actions/auth_actions.dart';
import '../../../business_Logic/models/CustomUser.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';

class ProfileCircle extends StatefulWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;
  final CustomUser user;
  final AppTheme theme;

  ProfileCircle(
      {super.key,
      required this.imagePath,
      this.isEdit = false,
      required this.onClicked, required this.user, required this.theme});

  @override
  State<ProfileCircle> createState() => _ProfileCircleState();
}
// TODO: render the image after it change should come from here
class _ProfileCircleState extends State<ProfileCircle> {
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(widget.theme.accentColor, widget.user),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: NetworkImage(widget.imagePath),
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: widget.onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color? color, CustomUser user) => Visibility(
    visible:  AuthActions.currUser.uid != widget.user.uid
        ? false : true,
    child: buildCircle(
        color: Colors.white,
        all: 0.2,
        child: buildCircle(
          color: color!,
          all: 0.2,
          child: IconButton(
            iconSize: 20,
            onPressed: widget.onClicked,
            icon: Icon(
              AuthActions.currUser.uid != widget.user.uid
                  ? const IconData(0x0) : Icons.edit,
              color: Colors.white,
            ),
          ),
        )),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
