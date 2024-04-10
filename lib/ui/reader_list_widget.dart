import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/highlight_controller.dart';
import 'package:se_bible_project/controllers/verse_action_controller.dart';

import '../controllers/chapter_controller.dart';
import '../models/chapter.dart';
import '../models/verse.dart';
import '../repository/providers.dart';
import 'highlight_color_widget.dart';

class BibleReaderListWidget extends ConsumerStatefulWidget {
  final ChapterState chapterState;

  const BibleReaderListWidget({
    required this.chapterState,
    super.key,
  });

  @override
  ConsumerState<BibleReaderListWidget> createState() =>
      _BibleReaderListWidgetState();
}

class _BibleReaderListWidgetState extends ConsumerState<BibleReaderListWidget> {
  Color? highlightColor;
  Set<String> selectedVerses = {};
  bool isOpen = false;

  void clearHighlights({required bool shouldPop}) {
    setState(() {
      selectedVerses = {};
      isOpen = false;
    });
    if (shouldPop) {
      Navigator.pop(context);
    }
  }

  void onVerseTap(Verse verse) {
    if (selectedVerses.contains(verse.id)) {
      setState(() {
        selectedVerses.remove(verse.id);
      });
      if (selectedVerses.isEmpty && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        selectedVerses.add(verse.id);
      });
    }
    if (isOpen == false && selectedVerses.isNotEmpty) {
      isOpen = true;
      Scaffold.of(context)
          .showBottomSheet(
            (context) => DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.32,
              initialChildSize: 0.32,
              maxChildSize: 0.32,
              builder: (context, controller) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          ref
                              .read(currentHighlightColorController.notifier)
                              .removeSelected();
                          clearHighlights(shouldPop: true);
                        },
                        child: const Text('X'),
                      ),
                    ),
                    Flexible(
                      child: HighlightColorsWidget(
                        clearHighlights: () {
                          clearHighlights(shouldPop: true);
                        },
                        selectedVerses: selectedVerses,
                      ),
                    ),
                  ],
                );
              },
            ),
          )
          .closed
          .whenComplete(() {

        clearHighlights(shouldPop: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapterState = widget.chapterState;
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

    final verses = chapter.verses.map((verse) {
      final verseSpan = ref.watch(
        verseActionStateNotifierProvider(
          VerseTap(
            verse: verse,
            onTap: () {
              log('hello');
              onVerseTap(verse);
            },
          ),
        ),
      );
      return verseSpan.textSpan ?? const WidgetSpan(child: SizedBox.shrink());
    }).toList();

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
