import 'package:flutter/cupertino.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../databases/database.dart';
import '../helper.dart';
import '../models/book.dart';

import '../repository/iq_bible_repository.dart';
import '../repository/providers.dart';

@immutable
class ChapterState extends State {
  final int currentBook;
  final int currentChapter;
  final int chapters;
  final List<Book> books;

  ChapterState({
    required this.currentBook,
    required this.currentChapter,
    required this.chapters,
    required this.books,
  });

  ChapterState copyWith({
    int? currentBook,
    int? currentChapter,
    int? chapters,
    List<Book>? books,
  }) =>
      ChapterState(
        currentBook: currentBook ?? this.currentBook,
        currentChapter: currentChapter ?? this.currentChapter,
        chapters: chapters ?? this.chapters,
        books: books ?? this.books,
      );

}

const String _kBook = 'last.book';
const String _kChapter = 'last.chapter';

class ChapterStateController extends Controller<ChapterState> {
  final Ref ref;
  final Testaments testaments;
  final SharedPreferences _preferences;

  ChapterStateController(
    this.ref,
    this.testaments,
    super.state,
    SharedPreferences preferences,
  ) : _preferences = preferences;

  Future<void> setChapter(int chapter) async {
    if (!mounted) return;
    state = state.copyWith(currentChapter: chapter);
    _preferences.setInt(_kChapter, chapter);
  }

  Future<void> setBook(int book) async {
    if (!mounted) return;
    state = state.copyWith(
        currentBook: book - 1, chapters: await _fetchChapters(book));
    _preferences.setInt(_kBook, book - 1);
  }

  Future<int?> _fetchChapters(int bookId) async {
    final bookChapters = ref.read(bibleRepository).getChapterCount(bookId);
    return bookChapters;
  }

  Future<void> swipes(DragEndDetails details) async {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      // Right Swipe
      if (state.currentBook == 0 && state.currentChapter == 1) {
        return;
      } else if (state.currentBook > 0 && state.currentChapter == 1) {
        final bookChapters = await _fetchChapters(state.currentBook);
        if (!mounted) return;
        state = state.copyWith(
          currentBook: state.currentBook - 1,
          currentChapter: bookChapters,
          chapters: bookChapters,
        );
        _preferences.setInt(_kChapter, state.currentChapter);
        _preferences.setInt(_kBook, state.currentBook);
      } else {
        setChapter(state.currentChapter - 1);
      }
    } else if (details.velocity.pixelsPerSecond.dx < 0) {
      //Left Swipe
      if (state.currentBook == state.books.length - 1 &&
          state.currentChapter == state.chapters) {
        return;
      } else if (state.currentBook < state.books.length &&
          state.currentChapter == state.chapters) {
        if (!mounted) return;
        state = state.copyWith(
          currentBook: state.currentBook + 1,
          currentChapter: 1,
          chapters: await _fetchChapters(state.currentBook + 1),
        );
        _preferences.setInt(_kChapter, state.currentChapter);
        _preferences.setInt(_kBook, state.currentBook);
      } else {
        setChapter(state.currentChapter + 1);
      }
    }
  }
}

final initialChapterState = Provider.autoDispose<ChapterState>((ref) {
  final books = ref.watch(booksProvider(Testaments.allBooks)).asData?.value;
  if (books != null) {
    final pref = ref.watch(preferencesProvider);
    final initBook = pref.getInt(_kBook) ?? 0;
    final initChapter = pref.getInt(_kChapter) ?? 1;

    final initialBookChapters =
        ref.watch(totalChaptersProvider(initBook)).asData?.value;
    return ChapterState(
      currentBook: initBook,
      currentChapter: initChapter,
      chapters: initialBookChapters ?? 0,
      books: books,
    );
  } else {
    return ChapterState(
      currentBook: -1,
      currentChapter: -1,
      chapters: 0,
      books: const [],
    );
  }
});

final chapterStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<ChapterStateController, ChapterState, Testaments>(
        (ref, testament) {
  final initState = ref.watch(initialChapterState);
  return ChapterStateController(
    ref,
    testament,
    initState,
    ref.watch(preferencesProvider),
  );
});
