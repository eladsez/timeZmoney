import 'package:flutter/material.dart';

import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final TextEditingController controller;
  final TextAlign align;

  TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.controller,
    required this.align,
  }) : super(key: key);

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.titleColor),
          ),
          const SizedBox(height: 8),
          TextField(
            textAlign: widget.align,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText:
                  "Your about is currently empty, Press the edit button to write it!",
              hintStyle: TextStyle(
                  color: theme.textFieldTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}
