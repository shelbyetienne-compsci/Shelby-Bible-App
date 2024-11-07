import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/verse.dart';

class SelectedVersesNotifier extends ChangeNotifier {
  final Set<Verse> verses = <Verse>{};

  bool get isEmpty => verses.isEmpty;

  bool get isNotEmpty => verses.isNotEmpty;

  bool contains(Verse value) {
    return verses.contains(value);
  }

  void addVerse(Verse value) {
    if (verses.contains(value)) return;
    verses.add(value);
    updateListeners();
  }

  void removeVerse(Verse value) {
    verses.remove(value);
    updateListeners();
  }

  void removeAll() {
    if (verses.isEmpty) return;
    verses.clear();
    updateListeners();
  }

  void updateListeners() {
    log('verses: $verses');
    notifyListeners();
  }
}

final selectedVersesNotifier =
    ChangeNotifierProvider((ref) => SelectedVersesNotifier());
