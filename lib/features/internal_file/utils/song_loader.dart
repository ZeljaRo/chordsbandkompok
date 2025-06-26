import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../profile_setup/controllers/active_profile_controller.dart';

class SongLoader {
  static Future<List<File>> loadTxtFiles() async {
    final profile = await ActiveProfileController.getActiveProfileData();
    if (profile == null) return [];

    final txtPath = profile['lyricsPath'];
    if (txtPath == null) return [];

    final txtDir = Directory(txtPath);
    if (!await txtDir.exists()) return [];

    final List<FileSystemEntity> allFiles = await txtDir.list().toList();
    return allFiles
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.txt'))
        .toList();
  }

  static Future<String> loadFromInternalPath(String path) async {
    final file = File(path);
    return await file.readAsString();
  }
}
