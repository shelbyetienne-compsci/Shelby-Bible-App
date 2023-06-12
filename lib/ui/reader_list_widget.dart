import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chapter.dart';
import '../repository/iq_bible_repository.dart';

class BibleReaderListWidget extends ConsumerWidget {
  final int chapterId;
  final int bookId;

  const BibleReaderListWidget({
    required this.chapterId,
    required this.bookId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(chaptersProvider(ChapterInfo(bookId, chapterId))).asData?.value;
    return const Text('data');
  }
}
