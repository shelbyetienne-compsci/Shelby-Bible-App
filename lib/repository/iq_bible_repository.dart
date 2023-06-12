import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/api/iq_bible_api.dart';

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
}

final bibleRepository = Provider((ref) {
  final bibleApi = ref.read(bibleApiProvider);
  return BibleRepository(bibleApi);
});

final chaptersProvider =
    FutureProvider.family.autoDispose<Chapter, ChapterInfo>((ref, info) async {
  final bibleProvider = ref.read(bibleRepository);
  final chapter = await bibleProvider.getChapter(info.bookId + 1, info.chapterId);
  return chapter;
});

final booksProvider = FutureProvider.autoDispose
    .family<List<Book>, Testaments>((ref, testament) async {
  final bibleProvider = ref.read(bibleRepository);
  switch (testament) {
    case Testaments.newTestament:
      return bibleProvider.getNTBooks();
    case Testaments.oldTestament:
      return bibleProvider.getOTBooks();
    case Testaments.allBooks:
      return bibleProvider.getBooks();
  }
});

final chapterCountProvider =
    FutureProvider.autoDispose.family<int, int>((ref, bookId) async {
  return ref.read(bibleRepository).getChapterCount(bookId);
});
