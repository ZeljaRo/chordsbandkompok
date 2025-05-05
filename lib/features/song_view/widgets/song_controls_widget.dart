import "package:flutter/material.dart";
import "../screens/song_settings_screen.dart";
import "../controllers/song_settings_controller.dart";
import "../screens/song_edit_screen.dart";

class SongControlsWidget extends StatelessWidget {
  final VoidCallback? onTransposeUp;
  final VoidCallback? onTransposeDown;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final String? songName;
  final String? filePath;
  final void Function()? onSettingsChanged;
  final void Function()? onSongEdited;

  const SongControlsWidget({
    super.key,
    this.onTransposeUp,
    this.onTransposeDown,
    this.onZoomIn,
    this.onZoomOut,
    this.songName,
    this.filePath,
    this.onSettingsChanged,
    this.onSongEdited,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.remove), onPressed: onTransposeDown),
            IconButton(icon: const Icon(Icons.add), onPressed: onTransposeUp),
            IconButton(icon: const Icon(Icons.lock), onPressed: () {}),
            ElevatedButton(onPressed: () {}, child: const Text("OUT")),
            IconButton(icon: const Icon(Icons.zoom_out), onPressed: onZoomOut),
            IconButton(icon: const Icon(Icons.zoom_in), onPressed: onZoomIn),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                if (filePath == null) return;
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongEditScreen(filePath: filePath!),
                  ),
                );
                if (result == true && onSongEdited != null) {
                  onSongEdited!();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                if (songName == null) return;

                final currentTextSize = SongSettingsController.getTextFontSize(songName!);
                final currentChordSize = SongSettingsController.getChordFontSize(songName!);
                final currentTextColor = SongSettingsController.getTextColor(songName!);
                final currentChordColor = SongSettingsController.getChordColor(songName!);

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongSettingsScreen(
                      textFontSize: currentTextSize,
                      chordFontSize: currentChordSize,
                      textColor: currentTextColor,
                      chordColor: currentChordColor,
                    ),
                  ),
                );

                if (result != null && result is Map) {
                  SongSettingsController.setTextFontSize(songName!, result['textFontSize']);
                  SongSettingsController.setChordFontSize(songName!, result['chordFontSize']);
                  SongSettingsController.setTextColor(songName!, result['textColor']);
                  SongSettingsController.setChordColor(songName!, result['chordColor']);
                  if (onSettingsChanged != null) onSettingsChanged!();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
