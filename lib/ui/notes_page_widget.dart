import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesPageWidget extends ConsumerWidget {
  const NotesPageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // number of items in each row
        mainAxisSpacing: 8.0, // spacing between rows
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        return null;
      },
    );
  }
}
