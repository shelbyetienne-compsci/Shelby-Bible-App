import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDatabaseManager {
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
        return savedFile;
      } else {
        throw Exception('Failed to download database');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Stream<bool> isDatabaseDownloaded() async* {
    final dir = await getApplicationDocumentsDirectory(); // Persistent location
    final dbPath = join(dir.path, _dbName);
    final file = File(dbPath);

    bool exists = await file.exists();
    yield exists;

    if (Platform.isAndroid) {
      await for (var event in file.parent.watch()) {
        bool newExists = await file.exists();
        if (newExists != exists) {
          exists = newExists;
          yield exists;
        }
      }
    } else {
      final controller = StreamController<bool>.broadcast();
      bool fileExists = await file.exists();
      if(!fileExists){
        Timer.periodic(const Duration(seconds: 1), (timer) async {
          bool newExists = await file.exists();
          if (newExists != exists) {
            exists = newExists;
            controller.add(exists);
          }
        });
      }
      controller.add(fileExists);
      yield* controller.stream;
    }
  }
}