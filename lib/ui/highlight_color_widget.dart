import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/highlight_controller.dart';

class HighlightColorsWidget extends ConsumerWidget {
  final Function() clearHighlights;

  const HighlightColorsWidget({
    required this.clearHighlights,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            onTap: () {
              ref
                  .read(currentHighlightColorController.notifier)
                  .removeColor();
              clearHighlights();
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: const Center(child: Text('x')),
            ),
          ),
        ),

        for (final color in highlightColors)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              onTap: () {
                ref
                    .read(currentHighlightColorController.notifier)
                    .setColor(color.withOpacity(.75));
                clearHighlights();
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
              ),
            ),
          ),
      ],
    );
  }
}

final highlightColors = [
  Colors.blueGrey,
  Colors.teal,
  Colors.pinkAccent,
  Colors.lightGreen,
  Colors.blue,
];
