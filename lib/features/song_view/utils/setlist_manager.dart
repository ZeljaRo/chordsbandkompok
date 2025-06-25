import "dart:convert";
import "dart:io";
import "../../profile_setup/controllers/current_profile_loader.dart";

class SetlistManager {
  static Future<void> addSong(String songName, String setlistName) async {
    final profile = await CurrentProfileLoader.loadLastProfile();
    final folderPath = profile?['text_folder'];
    if (folderPath == null) return;

    final folder = Directory("$folderPath\\setlists");
    if (!folder.existsSync()) folder.createSync(recursive: true);

    final file = File("${folder.path}\\$setlistName.json");

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
