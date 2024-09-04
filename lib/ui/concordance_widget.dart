import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/repository/providers.dart';

class ConcordanceWidget extends ConsumerWidget {
  final List<String> verses;

  const ConcordanceWidget({required this.verses, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final concordance = ref.watch(concordanceProvider(verses.first));
    return concordance.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Text(data[index].word);
            },
            itemCount: data.length,
          );
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }
}
