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


  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}

