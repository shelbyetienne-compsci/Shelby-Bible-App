import 'package:flutter/material.dart';

class VerseWidget extends StatelessWidget {
  final String verseId;
  final String verseNumber;
  final String verseText;

  const VerseWidget({
    required this.verseId,
    required this.verseNumber,
    required this.verseText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Text(
        '$verseNumber $verseText',
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
