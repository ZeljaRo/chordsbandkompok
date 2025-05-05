import 'dart:io';

class SongEditorController {
  static Future<void> saveEditedSong(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
  }
}
