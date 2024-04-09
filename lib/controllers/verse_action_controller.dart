import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/highlight_controller.dart';

import '../helper.dart';
import '../models/verse.dart';

@immutable
class VerseActionState extends State {
  final TextSpan? textSpan;
  final Verse verse;
  final bool isSelected;
  final bool isHighlight;
  final Color? highlightColor;

  VerseActionState({
    required this.verse,
    this.isSelected = false,
    this.isHighlight = false,
    this.highlightColor,
    this.textSpan,
  });

  VerseActionState copyWith({
    Verse? verse,
    bool? isSelected,
    bool? isHighlight,
    Color? highlightColor,
    TextSpan? textSpan,
  }) =>
      VerseActionState(
        verse: verse ?? this.verse,
        isSelected: isSelected ?? this.isSelected,
        isHighlight: isHighlight ?? this.isHighlight,
        highlightColor: highlightColor ?? this.highlightColor,
        textSpan: textSpan ?? this.textSpan,
      );
}

class VerseActionController extends Controller<VerseActionState> {
  AutoDisposeRef ref;

  Function() onTap;

  // figure out another way
  final _nilColor = Colors.transparent;

  VerseActionController(this.ref, this.onTap, super.state) {
    build();
    ref.listen(currentHighlightColorController, (previous, next) {
      if (previous != next) {
        if (state.isSelected) {
          if (previous == null) {
            if (next.color != null) {
              setHighlight(next.color!);
            }
            clearNoSet();
          } else {
            if (previous.colorIsNull && next.colorIsNull == false) {
              setHighlight(next.color!);
            } else if (previous.colorIsNull == false &&
                next.colorIsNull == false &&
                previous.color != next.color) {
              setHighlight(next.color!);
            } else if (previous.colorIsNull == false && next.colorIsNull && state.isHighlight && next.shouldSetColor == true && previous.color != _nilColor) {
              removeHighlight();
            } else if (previous.colorIsNull && next.colorIsNull && state.isHighlight && next.shouldSetColor == true  && previous.color != _nilColor) {
              removeHighlight();
            } else if(next.shouldSetColor == false){
              setSelected(false);
            }
          }
        }
      }
    });
  }

  void onTapVerse() {
    state = state.copyWith(
      isSelected: !state.isSelected,
    );
    onTap.call();
    build();
  }

  void setSelected(bool isSelected){
    state = state.copyWith(isSelected: false);
    build();
  }
  void clearNoSet() {
    state = state.copyWith(
      highlightColor: _nilColor,
      isSelected: false,
    );
    // add to DB
    build();
  }

  void setHighlight(Color color) {
    state = state.copyWith(
      highlightColor: color,
      isHighlight: true,
      isSelected: false,
    );
    // add to DB
    build();
  }

  void removeHighlight() {
    state = state.copyWith(
      highlightColor: _nilColor,
      isHighlight: false,
      isSelected: false,
    );
    // remove to DB
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
              decoration: state.isSelected ? TextDecoration.underline : null,
              decorationStyle: TextDecorationStyle.dashed,
              fontWeight: FontWeight.normal,
              fontSize: 20,
              backgroundColor: state.highlightColor,
            ),
          ),
          const TextSpan(text: ' '),
        ],
        recognizer: gestureRecognizer,
        style: TextStyle(
          decoration: state.isSelected ? TextDecoration.underline : null,
          decorationStyle: TextDecorationStyle.dashed,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          backgroundColor: state.highlightColor,
        ),
      ),
    );
  }
}

class VerseTap {
  final Verse verse;
  final Function() onTap;

  const VerseTap({required this.verse, required this.onTap});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseTap &&
          runtimeType == other.runtimeType &&
          verse == other.verse;

  @override
  int get hashCode => verse.hashCode;
}

final verseActionStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<VerseActionController, VerseActionState, VerseTap>(
        (ref, verseTap) {
  return VerseActionController(
    ref,
    verseTap.onTap,
    VerseActionState(
      verse: verseTap.verse,
    ),
  );
});
