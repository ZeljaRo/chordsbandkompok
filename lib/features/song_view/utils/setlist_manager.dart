import "dart:convert";
import "dart:io";
import "../../profile_setup/controllers/active_profile_controller.dart";

class SetlistManager {
  static Future<void> addSong(String songName, String setlistName) async {
    final profile = await ActiveProfileController.getActiveProfileData();
    final basePath = profile?['lyricsPath'];
    if (basePath == null) return;

    final folder = Directory("$basePath/setlists");
    if (!folder.existsSync()) folder.createSync(recursive: true);

    final file = File("${folder.path}/$setlistName.json");

    List<String> songs = [];
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      songs = List<String>.from(jsonDecode(content));
    }

    if (!songs.contains(songName)) {
      songs.add(songName);
      file.writeAsStringSync(jsonEncode(songs));
    }
  }
}
