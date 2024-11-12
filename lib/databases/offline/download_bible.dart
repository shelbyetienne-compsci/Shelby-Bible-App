import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDatabaseManager {
  static bool kjvIsDownloaded = false;
  static const String _dbName = 'offline-bible-kjv.db';

  static Future<Database> initOfflineDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, _dbName);

    if (!await File(dbPath).exists()) {
      throw Exception(
          'Database not found. Please download the database first.');
    }
    return openDatabase(dbPath);
  }

  static Future<File> downloadDatabase(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, _dbName);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Write the file to the device
        final file = File(dbPath);
        final savedFile = await file.writeAsBytes(response.bodyBytes);
        kjvIsDownloaded = true;
        return savedFile;
      } else {
        throw Exception('Failed to download database');
      }
    } catch (e) {
      kjvIsDownloaded = false;
      rethrow;
    }
  }

  static Future<void> isDatabaseDownloaded() async {
    final dir = await getApplicationDocumentsDirectory();  // Persistent location
    final dbPath = join(dir.path, _dbName);
    kjvIsDownloaded = await File(dbPath).exists();
  }
}


