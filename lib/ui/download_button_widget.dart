import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/offline/download_bible.dart';

class DownloadButtonWidget extends ConsumerWidget {
  const DownloadButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OfflineDatabaseManager.kjvIsDownloaded
        ? const SizedBox(
            width: 50,
          )
        : TextButton(
            onPressed: () async {

            },
            child: const Text("Download"),
          );
  }
}
