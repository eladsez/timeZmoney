import 'package:flutter/material.dart';

class ProfileCircle extends StatefulWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileCircle(
      {super.key,
      required this.imagePath,
      this.isEdit = false,
      required this.onClicked});

  @override
  State<ProfileCircle> createState() => _ProfileCircleState();
}
// TODO: render the image after it change should come from here
class _ProfileCircleState extends State<ProfileCircle> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
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

  Widget buildEditIcon(Color color) => buildCircle(
      color: Colors.white,
      all: 0.2,
      child: buildCircle(
        color: color,
        all: 0.2,
        child: IconButton(
          iconSize: 20,
          onPressed: widget.onClicked,
          icon: Icon(
            widget.isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
          ),
        ),
      ));

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
