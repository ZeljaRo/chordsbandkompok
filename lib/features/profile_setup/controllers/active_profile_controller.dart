import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ActiveProfileController {
  static Future<File> _getActiveProfileFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/active_profile.txt');
  }

  static Future<void> setActiveProfile(String name) async {
    final file = await _getActiveProfileFile();
    await file.writeAsString(name);
  }

  static Future<String?> getActiveProfileName() async {
    final file = await _getActiveProfileFile();
    if (!await file.exists()) return null;
    return await file.readAsString();
  }

  static Future<Map<String, dynamic>?> getActiveProfileData() async {
    final dir = await getApplicationDocumentsDirectory();
    final profileFile = File('${dir.path}/profiles.json');
    if (!await profileFile.exists()) return null;

    final content = await profileFile.readAsString();
    final profiles = List<Map<String, dynamic>>.from(jsonDecode(content));

    final activeName = await getActiveProfileName();
    if (activeName == null) return null;

    return profiles.firstWhere(
      (p) => p['name'] == activeName,
      orElse: () => {},
    );
  }
}
