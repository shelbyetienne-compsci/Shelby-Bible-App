import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/highlight_controller.dart';
import 'package:se_bible_project/controllers/selected_verse_controller.dart';

import '../databases/highlight_db.dart';
import '../helper.dart';
import '../models/verse.dart';

@immutable
class VerseActionState extends State {
  final TextSpan? textSpan;
  final Verse? verse;
  final String verseId;
  final bool isSelected;
  final Color? highlightColor;

  VerseActionState({
    required this.verseId,
    this.isSelected = false,
    this.verse,
    this.highlightColor,
    this.textSpan,
  });

  VerseActionState copyWith({
    bool? isSelected,
    Color? highlightColor,
    TextSpan? textSpan,
  }) =>
      VerseActionState(
        verse: verse,
        verseId: verseId,
        isSelected: isSelected ?? this.isSelected,
        highlightColor: highlightColor ?? this.highlightColor,
        textSpan: textSpan ?? this.textSpan,
      );

  factory VerseActionState.fromJson(dynamic json) {
    return VerseActionState(
      highlightColor: Color(
        json['highlightColor'] as int,
      ),
      verseId: json['verseId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'highlightColor': highlightColor?.value,
        'verseId': verseId,
      };

  @override
  String toString() {
    return 'VerseActionState{textSpan: $textSpan, verse: $verse, verseId: $verseId, isSelected: $isSelected, highlightColor: $highlightColor}';
  }
}

class VerseActionController extends Controller<VerseActionState> {
  AutoDisposeRef ref;

  Function() onTap;

  final _nilColor = Colors.transparent;

  VerseActionController(this.ref, this.onTap, super.state) {
    ref.read(highlightTableProvider).get(whereArg: state.verseId).then((verse) {
      state = state.copyWith(highlightColor: verse?.highlightColor);
      build();
    });
    build();
    ref.listen(currentHighlightColorController, (previous, next) {
      if (state.isSelected) {
        if (next.color != _nilColor) {
          setHighlight(next.color);
        } else if (next.color == _nilColor) {
          removeHighlight();
        }
      }
    });
    ref.listen(selectedVersesNotifier, (previous, next) {
      if (next.isEmpty) {
        state = state.copyWith(
          isSelected: false,
        );
        build();
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

  void setHighlight(Color color) async {
    state = state.copyWith(
      highlightColor: color,
      isSelected: false,
    );
    await ref.read(highlightTableProvider).insert(state);
    // add to DB
    build();
  }

  void removeHighlight() async {
    state = state.copyWith(
      highlightColor: _nilColor,
      isSelected: false,
    );
    await ref.read(highlightTableProvider).delete(whereArg: state.verseId);
    // remove to DB
    build();
  }

  Color? get _displayHighlightColor => state.highlightColor == _nilColor
      ? _nilColor
      : state.highlightColor?.withOpacity(0.8);

  void build() {
    final gestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        onTapVerse();
        log(state.verse!.id);
      };
    state = state.copyWith(
      textSpan: TextSpan(
        text: state.verse?.verseNumber,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: state.verse?.text,
            recognizer: gestureRecognizer,
            style: TextStyle(
              decoration: state.isSelected ? TextDecoration.underline : null,
              decorationStyle: TextDecorationStyle.dashed,
              fontWeight: FontWeight.normal,
              fontSize: 20,
              backgroundColor: _displayHighlightColor,
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
          backgroundColor: _displayHighlightColor,
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
      verseId: verseTap.verse.id,
    ),
  );
});
