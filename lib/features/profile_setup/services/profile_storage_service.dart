import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ProfileStorageService {
  static Future<String> _getProfilesFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profiles.json');
    return file.path;
  }

  static Future<void> saveProfile({
    required String name,
    required String lyricsPath,
    required String attachmentsPath,
  }) async {
    final path = await _getProfilesFilePath();
    final file = File(path);

    Map<String, dynamic> profileData = {
      'name': name,
      'lyricsPath': lyricsPath,
      'attachmentsPath': attachmentsPath,
    };

    List<Map<String, dynamic>> profiles = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      profiles = List<Map<String, dynamic>>.from(json.decode(content));
    }

    profiles.removeWhere((p) => p['name'] == name);
    profiles.add(profileData);

    await file.writeAsString(json.encode(profiles));
  }

  static Future<List<Map<String, dynamic>>> loadProfiles() async {
    final path = await _getProfilesFilePath();
    final file = File(path);

    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final profiles = List<Map<String, dynamic>>.from(json.decode(content));
    return profiles;
  }
}
