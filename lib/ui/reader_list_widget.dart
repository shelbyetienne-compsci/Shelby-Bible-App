import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/verse_action_controller.dart';
import 'package:se_bible_project/databases/database.dart';

import '../controllers/chapter_controller.dart';
import '../controllers/selected_verse_controller.dart';
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
  late SelectedVersesNotifier selectedVerses;
  bool isOpen = false;
  final ScrollController _scrollController = ScrollController();
  final _kScroll = 'last.scroll';

  @override
  void initState() {
    super.initState();
    selectedVerses = ref.read(selectedVersesNotifier);
  }

  void clearSelected({required bool shouldPop}) {
    selectedVerses.removeAll();
    setState(() {
      isOpen = false;
    });
    if (shouldPop) {
      Navigator.pop(context);
    }
  }

  void onVerseTap(Verse verse) {
    if (selectedVerses.contains(verse.id)) {
      selectedVerses.removeVerse(verse.id);
      if (selectedVerses.isEmpty && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      selectedVerses.addVerse(verse.id);
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
                          clearSelected(shouldPop: true);
                        },
                        child: const Text('X'),
                      ),
                    ),
                    Flexible(
                      child: HighlightColorsWidget(
                        clearSelected: () {
                          clearSelected(shouldPop: true);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          )
          .closed
          .whenComplete(() {
        clearSelected(shouldPop: false);
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
              onVerseTap(verse);
            },
          ),
        ),
      );
      return verseSpan.textSpan ?? const WidgetSpan(child: SizedBox.shrink());
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        final pref = ref.read(preferencesProvider);
        if (pref.containsKey(_kScroll)) {
          final list = pref.getStringList(_kScroll);
          if (list != null) {
            if (int.parse(list[0]) == chapterState.currentBook &&
                int.parse(list[1]) == chapterState.currentChapter) {
              _scrollController.jumpTo(
                double.parse(list[2]),
              );
            } else {
              pref.remove(_kScroll);
            }
          }
        }
        _scrollController.position.isScrollingNotifier.addListener(() {
          if (!_scrollController.position.isScrollingNotifier.value) {
            pref.setStringList(
              _kScroll,
              <String>[
                chapterState.currentBook.toString(),
                chapterState.currentChapter.toString(),
                _scrollController.offset.toString(),
              ],
            );
          }
        });
      }
    });

    return SingleChildScrollView(
      controller: _scrollController,
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
