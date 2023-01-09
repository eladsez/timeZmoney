import 'package:flutter/material.dart';

import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';


class InputField extends StatelessWidget {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  final String title;
  final String hint;
  final TextEditingController? fieldController;
  final Widget? child;
  final double highet;
  final TextInputType keyboardType;

   InputField(
      {super.key,
        required this.title,
        required this.hint,
        this.fieldController,
        this.keyboardType = TextInputType.text,
        this.child, this.highet = 52,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.titleColor),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.95,
            height: highet,
            padding: const EdgeInsets.only(left: 8.0),
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400, color: theme.textFieldTextColor),
                    obscureText: false,
                    autocorrect: false,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400, color: theme.textFieldTextColor),
                    ),
                    controller: fieldController,
                    readOnly: child != null ? true : false,
                    maxLines: highet != 52 ? 5 : 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: child ?? Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
