import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/chapter_controller.dart';
import 'package:se_bible_project/ui/reader_list_widget.dart';

import '../models/book.dart';

class BibleReaderWidget extends ConsumerWidget {
  const BibleReaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterState =
        ref.watch(chapterStateNotifierProvider(Testaments.allBooks));
    final chapterController =
        ref.read(chapterStateNotifierProvider(Testaments.allBooks).notifier);
    return GestureDetector(
      onHorizontalDragEnd: (details) async {
        await chapterController.swipes(details);
      },
      child: BibleReaderListWidget(
        chapterState: chapterState,
      ),
    );
  }
}
