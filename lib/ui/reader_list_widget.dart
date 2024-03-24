import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/ui/verse_widget.dart';

import '../controllers/chapter_controller.dart';
import '../models/chapter.dart';
import '../repository/providers.dart';

class BibleReaderListWidget extends ConsumerWidget {
  final ChapterState chapterState;

  const BibleReaderListWidget({
    required this.chapterState,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref
        .watch(
          chaptersProvider(
            ChapterInfo(
              chapterState.currentBook,
              chapterState.currentChapter,
            ),
          ),
        )
        .asData
        ?.value;

    if (chapter == null) {
      log('${chapterState.currentBook} and ${chapterState.currentChapter}');
      return const SizedBox.shrink();
    }

    final verses =
        chapter.verses.map((verse) => VerseSpan(verse: verse).build()).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text.rich(
        TextSpan(
          text: chapterState.currentBook != -1
              ? '${chapterState.books[chapterState.currentBook].name} ${chapterState.currentChapter}\n'
              : '',
          children: verses,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
