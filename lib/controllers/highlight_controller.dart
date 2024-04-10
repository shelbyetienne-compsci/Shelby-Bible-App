import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper.dart';

@immutable
class HighlightColor extends State {
  final Color color;
  final bool isHighlight;

  final Set<String> selectedVerses;

  HighlightColor({
    this.color = Colors.transparent,
    this.isHighlight = false,
    this.selectedVerses = const {},
  });

  HighlightColor copyWith({
    Color? color,
    bool? isHighlight,
    Set<String>? selectedVerses,
  }) =>
      HighlightColor(
        color: color ?? this.color,
        isHighlight: isHighlight ?? this.isHighlight,
        selectedVerses: selectedVerses ?? this.selectedVerses,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightColor &&
          runtimeType == other.runtimeType &&
          selectedVerses == other.selectedVerses;

  @override
  int get hashCode => selectedVerses.hashCode;
}

class HighlightController extends Controller<HighlightColor> {
  HighlightController(super.state);

  void setColor(Color? color, Set<String> selectedVerses) {
    if(selectedVerses.isNotEmpty){
      state = state.copyWith(
        color: color,
        isHighlight: true,
        selectedVerses: selectedVerses,
      );
    }
  }

  void removeColor(Set<String> selectedVerses) {
    if(selectedVerses.isNotEmpty) {
      state = state.copyWith(
        color: Colors.transparent,
        isHighlight: false,
        selectedVerses: selectedVerses,
      );
    }
  }

  void removeSelected(){
    state.copyWith(selectedVerses: {});
  }
}

final currentHighlightColorController =
    StateNotifierProvider.autoDispose<HighlightController, HighlightColor>(
  (ref) => HighlightController(
    HighlightColor(),
  ),
);
