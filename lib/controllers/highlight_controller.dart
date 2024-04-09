import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper.dart';

class HighlightColor extends State {
  Color? color;
  bool colorIsNull;

  bool? shouldSetColor;

  HighlightColor({this.color, required this.colorIsNull, this.shouldSetColor});

  HighlightColor copyWith({
    Color? color,
    bool? colorIsNull,
    bool? shouldSetColor,
  }) =>
      HighlightColor(
        color: color ?? this.color,
        colorIsNull: colorIsNull ?? this.colorIsNull,
        shouldSetColor: shouldSetColor ?? this.shouldSetColor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightColor &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          colorIsNull == other.colorIsNull &&
          shouldSetColor == other.shouldSetColor;

  @override
  int get hashCode =>
      color.hashCode ^ colorIsNull.hashCode ^ shouldSetColor.hashCode;
}

class HighlightController extends Controller<HighlightColor> {
  HighlightController(super.state);

  void setColor(Color? color) {
    state = state.copyWith(color: color, colorIsNull: false);
  }

  void removeColor() {
    state = state.copyWith(color: Colors.transparent, colorIsNull: true);
  }

  void shouldSetColor(bool canSet){
    state = state.copyWith(shouldSetColor: canSet);
  }
}

final currentHighlightColorController =
    StateNotifierProvider.autoDispose<HighlightController, HighlightColor>(
  (ref) => HighlightController(
    HighlightColor(colorIsNull: false),
  ),
);
