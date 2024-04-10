import 'package:flutter/cupertino.dart';

class SelectedVersesController extends ChangeNotifier {
  final Set<String> verses = <String>{};

  bool get isEmpty => verses.isEmpty;

  bool get isNotEmpty => verses.isNotEmpty;

  bool contains(String value){
    return verses.contains(value);
  }
  void addVerse(String value){
    if(verses.contains(value)) return;
    verses.add(value);
    notifyListeners();
  }

  void removeVerse(String value){
    verses.remove(value);
    notifyListeners();
  }

  void removeAll(){
    verses.clear();
    notifyListeners();
  }

}