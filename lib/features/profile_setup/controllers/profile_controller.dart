import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileController {
  static Future<void> saveProfile({
    required String name,
    required String lyricsPath,
    required String mediaPath,
    required String connection,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profiles.json');

    List<Map<String, dynamic>> profiles = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      final decoded = jsonDecode(content);
      profiles = List<Map<String, dynamic>>.from(decoded);
    }

    profiles.removeWhere((p) => p['name'] == name);

    profiles.add({
      'name': name,
      'lyricsPath': lyricsPath,
      'mediaPath': mediaPath,
      'connection': connection,
    });

    await file.writeAsString(jsonEncode(profiles));
  }

  static Future<List<Map<String, dynamic>>> loadProfiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profiles.json');

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();
    final decoded = jsonDecode(content);
    return List<Map<String, dynamic>>.from(decoded);
  }
}
