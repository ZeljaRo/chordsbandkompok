import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SongLoader {
  static Future<List<String>> loadSongs() async {
    final dir = await getApplicationDocumentsDirectory();
    final txtDir = Directory('${dir.path}/txt');

    if (!await txtDir.exists()) return [];

    final files = txtDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.txt'))
        .toList();

    files.sort((a, b) => a.path.compareTo(b.path));

    return files.map((f) => f.path).toList();
  }

  static Future<String> loadSongContent(String path) async {
    final file = File(path);
    return await file.readAsString();
  }
}
