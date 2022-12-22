import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  const PostButton({required this.label, required this.onTap, Key? key})
      : super(key: key);

  final String label;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        alignment: Alignment.center,
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xff01b2b8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}