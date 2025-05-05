import 'package:flutter/material.dart';
import '../screens/song_edit_screen.dart';
import '../screens/song_color_settings_screen.dart';
import '../controllers/song_settings_controller.dart';
import 'dart:io';

class SongControlsWidget extends StatefulWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final String? filePath;
  final VoidCallback onRefresh;

  const SongControlsWidget({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.filePath,
    required this.onRefresh,
  });

  @override
  State<SongControlsWidget> createState() => _SongControlsWidgetState();
}

class _SongControlsWidgetState extends State<SongControlsWidget> {
  Future<void> _openEditor() async {
    if (widget.filePath == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SongEditScreen(filePath: widget.filePath!)),
    );
    if (result == true) {
      widget.onRefresh();
    }
  }

  Future<void> _openSettings() async {
    print('>>> SETTINGS CLICKED');

    if (widget.filePath == null) return;
    final name = widget.filePath!.split(Platform.pathSeparator).last;

    final currentTextColor = SongSettingsController.getTextColor(name);
    final currentChordColor = SongSettingsController.getChordColor(name);

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => SongColorSettingsScreen(
          initialTextColor: currentTextColor,
          initialChordColor: currentChordColor,
        ),
      ),
    );

    if (result != null) {
      SongSettingsController.setTextColor(name, result['textColor']);
      SongSettingsController.setChordColor(name, result['chordColor']);
      widget.onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.remove), onPressed: () {}),
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            IconButton(icon: const Icon(Icons.lock), onPressed: () {}),
            ElevatedButton(onPressed: () {}, child: const Text('OUT')),
            IconButton(icon: const Icon(Icons.zoom_out), onPressed: widget.onZoomOut),
            IconButton(icon: const Icon(Icons.zoom_in), onPressed: widget.onZoomIn),
            IconButton(icon: const Icon(Icons.edit), onPressed: _openEditor),
            IconButton(icon: const Icon(Icons.settings), onPressed: _openSettings),
          ],
        ),
      ),
    );
  }
}

import '../../screens/song_settings_screen.dart';
