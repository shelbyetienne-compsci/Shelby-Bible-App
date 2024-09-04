import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/api/iq_bible_api.dart';
import 'package:se_bible_project/models/lexicon.dart';

import '../models/book.dart';
import '../models/chapter.dart';

class BibleRepository {
  final BibleApi _api;

  BibleRepository(
    BibleApi bibleApi,
  ) : _api = bibleApi;

  Future<List<Book>> getBooks() async {
    return _api.getBooks();
  }

  Future<List<Book>> getNTBooks() async {
    return _api.getNTBooks();
  }

  Future<List<Book>> getOTBooks() async {
    return _api.getOTBooks();
  }

  Future<Chapter> getChapter(int bookId, int chapterId) async {
    return _api.getChapter(bookId, chapterId);
  }

  Future<int> getChapterCount(int bookId) async {
    return _api.getChapterCount(bookId);
  }

  Future<int> getVerseCount(int bookId, int chapterId) async {
    return _api.getVerseCount(bookId, chapterId);
  }

  Future<List<Lexicon>> getConcordance(String verseId) async {
    return _api.getConcordance(verseId);
  }
}

final bibleRepository = Provider((ref) {
  final bibleApi = ref.read(bibleApiProvider);
  return BibleRepository(bibleApi);
});
