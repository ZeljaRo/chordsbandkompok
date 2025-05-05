import "../screens/song_settings_screen.dart";
import "package:flutter/material.dart";

class SongControlsWidget extends StatelessWidget {
  final VoidCallback? onTransposeUp;
  final VoidCallback? onTransposeDown;

  const SongControlsWidget({
    super.key,
    this.onTransposeUp,
    this.onTransposeDown,
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
            IconButton(icon: const Icon(Icons.remove), onPressed: onTransposeDown),  // Transpose -
            IconButton(icon: const Icon(Icons.add), onPressed: onTransposeUp),       // Transpose +
            IconButton(icon: const Icon(Icons.lock), onPressed: () {}),
            ElevatedButton(onPressed: () {}, child: const Text("OUT")),
            IconButton(icon: const Icon(Icons.zoom_out), onPressed: () {}),
            IconButton(icon: const Icon(Icons.zoom_in), onPressed: () {}),
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongSettingsScreen(
                      textFontSize: 18,
                      chordFontSize: 20,
                      textColor: Colors.black,
                      chordColor: Colors.blue,
                    ),
                  ),
                );
                if (result != null) {
                  // Ovdje æeš kasnije upisivati povratne vrijednosti
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
