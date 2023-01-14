import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/utils/theme.dart';

class ContactButton extends StatefulWidget {
  ContactButton({super.key, required this.user, required this.theme});

  CustomUser user;
  AppTheme theme;


  @override
  State<ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<ContactButton> {
  Future<void>? _launched;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      // animatedIcon: AnimatedIcons.menu_close,
      icon: Icons.call,
      animatedIconTheme: const IconThemeData(size: 22.0),
      backgroundColor: widget.theme.accentColor,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.email_outlined),
          backgroundColor: widget.theme.emailButtonColor,
          label: 'Email',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => setState(() {
            _launched = _sendEmail(widget.user.email);
          }),

        ),
        SpeedDialChild(
          child: const Icon(Icons.phone),
          backgroundColor: widget.theme.callButtonColor,
          label: 'Call',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => setState(() {
            _launched = _makePhoneCall(widget.user.phoneNum!);
          }),
        ),
      ],
    );
  }
}
