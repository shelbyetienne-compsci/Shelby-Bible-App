import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../databases/note_db.dart';
import '../models/book.dart';
import '../models/chapter.dart';
import 'iq_bible_repository.dart';

final chaptersProvider =
    FutureProvider.family.autoDispose<Chapter, ChapterInfo>((ref, info) async {
  final bibleProvider = ref.read(bibleRepository);
  final chapter =
      bibleProvider.getChapter(info.bookNumber + 1, info.chapterNumber);
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

final totalChaptersProvider =
    FutureProvider.autoDispose.family<int, int>((ref, bookNumber) async {
  return ref.read(bibleRepository).getChapterCount(bookNumber);
});

final currentNote =
    FutureProvider.autoDispose.family<Notes?, Notes?>((ref, note) async {
  if (note == null) {
    final all = await ref.watch(notesTableProvider).read();
    return all?.first;
  }
  return note;
});
