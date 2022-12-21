import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class HelperFunctions {
  static Widget wrapWithAnimatedBuilder({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => FractionalTranslation(
        translation: animation.value,
        child: child,
      ),
    );
  }

  static String generateMd5(String? input) {
    if (input != null) {
      return md5.convert(utf8.encode(input)).toString();
    } else {
      return "ERROR";
    }
  }


  /*
  * This function take a string of an inputFiled and return his validation function
  */
  static String? Function(String?) validatorFunctions(String which) {
    switch (which) {
      case "Email":
        return (val) {
          if (val == null ||
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(val)) {
            return "Invalid email address";
          }
        };
      case "Username":
        return (val) {
          if (val == null || val.length < 6) {
            return "Username must be at least 6 characters";
          }
          return null;
        };
      case "Password":
        return (val) {
          if (val == null || val.length < 6){
            return "Password must be at least 6 characters";
          }
          return null;
        };
      default:
        return (val) {
          return null;
        };
    }
  }
}
