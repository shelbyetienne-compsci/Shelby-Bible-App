import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/chapter_controller.dart';
import 'package:se_bible_project/ui/book_button_widget.dart';
import 'package:se_bible_project/ui/reader_list_widget.dart';

import '../models/book.dart';

class BibleReaderPageWidget extends ConsumerStatefulWidget {
  const BibleReaderPageWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<BibleReaderPageWidget> createState() => _BibleReaderPageState();
}

class _BibleReaderPageState extends ConsumerState<BibleReaderPageWidget> {
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
        ref.read(chapterStateNotifierProvider(Testaments.allBooks));
    final bookId = chapterState.currentBook;
    final chapter = chapterState.currentChapter;

    return Scaffold(
      appBar: AppBar(
        title: const BookButtonWidget(),
      ),
      body: BibleReaderListWidget(
        chapterId: chapter,
        bookId: bookId,
      ),
    );
  }
}
