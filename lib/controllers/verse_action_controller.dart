import 'dart:developer';

import 'package:flutter/cupertino.dart' hide State;
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper.dart';
import '../models/verse.dart';

@immutable
class VerseActionState extends State {
  final TextSpan? textSpan;
  final Verse verse;
  final bool isSelected;
  final bool isHighlight;
  final Color? highLightColor;

  VerseActionState({
    required this.verse,
    this.isSelected = false,
    this.isHighlight = false,
    this.highLightColor,
    this.textSpan,
  });

  VerseActionState copyWith({
    Verse? verse,
    bool? isSelected,
    bool? isHighlight,
    Color? highLightColor,
    TextSpan? textSpan,
  }) =>
      VerseActionState(
        verse: verse ?? this.verse,
        isSelected: isSelected ?? this.isSelected,
        isHighlight: isHighlight ?? this.isHighlight,
        highLightColor: highLightColor ?? this.highLightColor,
        textSpan: textSpan ?? this.textSpan,
      );
}

class VerseActionController extends Controller<VerseActionState> {
  VerseActionController(super.state) {
    build();
  }

  void onTapVerse() {
    state = state.copyWith(
      isSelected: !state.isSelected,
    );
    build();
  }

  void build() {
    final gestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        onTapVerse();
        log(state.verse.id);
      };
    state = state.copyWith(
      textSpan: TextSpan(
        text: state.verse.verseNumber,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: state.verse.text,
            recognizer: gestureRecognizer,
            style: TextStyle(
              // TODO: figure out how to get this to rebuild in order to implement Verse Actions
              // WIDGETSPAN????
              decoration: state.isSelected ? TextDecoration.underline : null,
              decorationStyle: TextDecorationStyle.dashed,
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
          const TextSpan(text: ' '),
        ],
        recognizer: gestureRecognizer,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          height: 1.5,
          fontSize: 16,
        ),
      ),
    );
  }
}

final verseActionStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<VerseActionController, VerseActionState, Verse>((ref, verse) {
  return VerseActionController(
    VerseActionState(
      verse: verse,
    ),
  );
});
