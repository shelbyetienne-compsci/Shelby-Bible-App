import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/chapter_controller.dart';
import 'package:se_bible_project/models/chapter.dart';
import 'package:se_bible_project/ui/book_button_widget.dart';
import 'package:se_bible_project/ui/verse_widget.dart';

import '../models/book.dart';
import '../repository/iq_bible_repository.dart';

class BibleReader extends ConsumerStatefulWidget {
  const BibleReader({Key? key}) : super(key: key);

  @override
  ConsumerState<BibleReader> createState() => _BibleReaderState();
}

class _BibleReaderState extends ConsumerState<BibleReader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapterState =
        ref.watch(chapterStateNotifierProvider(Testaments.allBooks));
    final bookId = chapterState.currentBook;
    final chapter = chapterState.currentChapter;

    final chapters = ref.read(chaptersProvider(ChapterInfo(bookId, chapter)));
    return Scaffold(
      appBar: AppBar(
        title: const BookButtonWidget(),
      ),
      body: chapters.when(
        data: (chapter) {
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
