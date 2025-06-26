import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SongLoader {
  static Future<List<File>> loadTxtFiles() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory txtDir = Directory('${appDocDir.path}/txt');

    if (!await txtDir.exists()) {
      await txtDir.create(recursive: true);
      return [];
    }

    final List<FileSystemEntity> allFiles = await txtDir.list().toList();
    return allFiles
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.txt'))
        .toList();
  }
}
