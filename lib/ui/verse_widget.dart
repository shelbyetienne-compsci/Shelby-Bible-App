import 'dart:developer';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/verse.dart';

class VerseSpan {
  final Verse verse;

  VerseSpan({required this.verse});

  TextSpan build() {
    final gestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        log(verse.id);
      };
    return TextSpan(
      text: verse.verseNumber,
      children: [
        const TextSpan(text: ' '),
        TextSpan(
          text: verse.text,
          recognizer: gestureRecognizer,
          style: const TextStyle(
              // TODO: figure out how to get this to rebuild in order to implement Verse Actions
              // WIDGETSPAN????
              // decoration: TextDecoration.underline,
              // decorationStyle: TextDecorationStyle.dashed,
              fontWeight: FontWeight.normal,
              fontSize: 20),
        ),
        const TextSpan(text: ' '),
      ],
      recognizer: gestureRecognizer,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        height: 1.5,
        fontSize: 16,
      ),
    );
  }
}
