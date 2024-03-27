import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper.dart';

class HighlightColor extends State {
  Color? color;

  HighlightColor({this.color});

  HighlightColor copyWith({Color? color}) =>
      HighlightColor(color: color ?? this.color);
}

class HighlightController extends Controller<HighlightColor> {
  HighlightController(super.state);

  void setColor(Color? color) {
    state = state.copyWith(color: color);
  }
}

final currentHighlightColorController =
    StateNotifierProvider.autoDispose<HighlightController, HighlightColor>(
  (ref) => HighlightController(
    HighlightColor(),
  ),
);
