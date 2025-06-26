import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CurrentProfileLoader {
  static Future<Map<String, dynamic>?> loadLastProfile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profiles.json');
    if (!file.existsSync()) return null;

    final content = await file.readAsString();
    final profiles = List<Map<String, dynamic>>.from(jsonDecode(content));

    if (profiles.isEmpty) return null;
    return profiles.last;
  }
}
