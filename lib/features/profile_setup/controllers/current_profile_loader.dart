import 'dart:convert';
import 'dart:io';

class CurrentProfileLoader {
  static Future<Map<String, dynamic>?> loadLastProfile() async {
    final file = File('profiles.json');
    if (!file.existsSync()) return null;

    final content = await file.readAsString();
    final profiles = List<Map<String, dynamic>>.from(jsonDecode(content));

    // Vraæa zadnji spremljeni (zadnji u listi)
    if (profiles.isEmpty) return null;
    return profiles.last;
  }
}
