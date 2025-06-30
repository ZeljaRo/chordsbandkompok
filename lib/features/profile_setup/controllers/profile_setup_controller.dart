import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../common/services/profile_storage_service.dart';
import '../../profile_selector/screens/profile_selector_screen.dart';

class ProfileSetupController {
  Future<void> saveProfile(BuildContext context, String profileName) async {
    final baseDir = await getApplicationDocumentsDirectory();
    final profileDir = Directory('${baseDir.path}/profiles/$profileName');

    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    await ProfileStorageService.setCurrentProfileName(profileName);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSelectorScreen()),
      );
    }
  }

  Future<List<String>> loadProfileNames() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final profilesDir = Directory('${baseDir.path}/profiles');

    if (!await profilesDir.exists()) return [];

    final dirs = profilesDir.listSync().whereType<Directory>();
    return dirs.map((d) => d.path.split(Platform.pathSeparator).last).toList();
  }

  Future<void> loadProfile(BuildContext context, String name) async {
    await ProfileStorageService.setCurrentProfileName(name);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSelectorScreen()),
      );
    }
  }
}
