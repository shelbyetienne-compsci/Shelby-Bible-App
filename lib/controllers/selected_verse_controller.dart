import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedVersesNotifier extends ChangeNotifier {
  final Set<String> verses = <String>{};

  bool get isEmpty => verses.isEmpty;

  bool get isNotEmpty => verses.isNotEmpty;

  bool contains(String value) {
    return verses.contains(value);
  }

  void addVerse(String value) {
    if (verses.contains(value)) return;
    verses.add(value);
    updateListeners();
  }

  void removeVerse(String value) {
    verses.remove(value);
    updateListeners();
  }

  void removeAll() {
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
