import 'dart:convert';
import 'dart:io';

class ProfileController {
  static const String fileName = 'profiles.json';

  static Future<void> saveProfile({
    required String name,
    required String textFolder,
    required String mediaFolder,
    required String connection,
  }) async {
    final profile = {
      'name': name,
      'text_folder': textFolder,
      'media_folder': mediaFolder,
      'connection': connection,
    };

    final file = File(fileName);
    List profiles = [];

    if (file.existsSync()) {
      final content = file.readAsStringSync();
      profiles = jsonDecode(content);
    }

    profiles.removeWhere((p) => p['name'] == name);
    profiles.add(profile);

    await file.writeAsString(jsonEncode(profiles));
  }

  static Future<List<Map<String, dynamic>>> loadProfiles() async {
    final file = File(fileName);
    if (!file.existsSync()) return [];
    final content = await file.readAsString();
    final data = jsonDecode(content);
    return List<Map<String, dynamic>>.from(data);
  }
}
