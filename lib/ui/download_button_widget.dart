import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/offline/download_bible.dart';

class DownloadButtonWidget extends ConsumerWidget {
  const DownloadButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<bool>(
      stream: OfflineDatabaseManager.isDatabaseDownloaded(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final fileExists = snapshot.data ?? false;
          return fileExists
              ? const SizedBox(
                  width: 50,
                )
              : TextButton(
                  onPressed: () async {
                    await OfflineDatabaseManager.downloadDatabase(
                        'https://github.com/shelbyetienne-compsci/BibleHub/raw/refs/heads/main/bible-kjv.db');
                  },
                  child: const Text("Download"),
                );
        }
        return const SizedBox(
          width: 50,
        );
      },
    );
  }
}
