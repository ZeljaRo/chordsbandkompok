import "package:flutter/material.dart";
import "dart:io";
import "../widgets/song_controls_widget.dart";
import "../../profile_setup/controllers/current_profile_loader.dart";
import "../utils/transpose_helper.dart";
import "../utils/rich_song_parser.dart";
import "../controllers/song_settings_controller.dart";
import '../widgets/attachment_button.dart';

class SongViewScreen extends StatefulWidget {
  const SongViewScreen({super.key});

  @override
  State<SongViewScreen> createState() => _SongViewScreenState();
}

class _SongViewScreenState extends State<SongViewScreen> {
  List<File> _allSongs = [];
  int _currentIndex = 0;
  List<String> _songLines = [];
  String? _songName;
  File? _currentFile;
  int _transposeSteps = 0;

  double _textFontSize = 18;
  double _chordFontSize = 20;
  Color _textColor = Colors.black;
  Color _chordColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    SongSettingsController.loadSettings().then((_) {
      _loadSongsFromProfile();
    });
  }

  Future<void> _loadSongsFromProfile() async {
    final profile = await CurrentProfileLoader.loadLastProfile();
    if (profile == null || profile['text_folder'] == null) return;

    final dir = Directory(profile['text_folder']);
    if (!dir.existsSync()) return;

    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.txt'))
        .toList();

    if (files.isEmpty) return;

    setState(() {
      _allSongs = files;
      _currentIndex = 0;
    });

    _loadSongAt(_currentIndex);
  }

  Future<void> _loadSongAt(int index) async {
    if (index < 0 || index >= _allSongs.length) return;

    final file = _allSongs[index];
    final lines = await file.readAsLines();
    final name = file.uri.pathSegments.last;

    setState(() {
      _songLines = lines;
      _songName = name;
      _currentFile = file;
      _transposeSteps = 0;
      _loadSettingsForSong();
    });
  }

  void _loadSettingsForSong() {
    if (_songName == null) return;
    setState(() {
      _textFontSize = SongSettingsController.getTextFontSize(_songName!);
      _chordFontSize = SongSettingsController.getChordFontSize(_songName!);
      _textColor = SongSettingsController.getTextColor(_songName!);
      _chordColor = SongSettingsController.getChordColor(_songName!);
    });
  }

  void _transposeUp() => setState(() => _transposeSteps++);
  void _transposeDown() => setState(() => _transposeSteps--);

  void _zoomIn() {
    if (_songName == null) return;
    setState(() {
      _textFontSize += 1;
      SongSettingsController.setTextFontSize(_songName!, _textFontSize);
    });
  }

  void _zoomOut() {
    if (_songName == null) return;
    setState(() {
      _textFontSize -= 1;
      if (_textFontSize < 10) _textFontSize = 10;
      SongSettingsController.setTextFontSize(_songName!, _textFontSize);
    });
  }

  void _onSettingsChanged() => _loadSettingsForSong();

  void _refreshCurrentSong() {
    _loadSongAt(_currentIndex);
  }

  void _nextSong() {
    if (_currentIndex < _allSongs.length - 1) {
      _currentIndex++;
      _loadSongAt(_currentIndex);
    }
  }

  void _previousSong() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _loadSongAt(_currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullText = _songLines.join('\n');
    final transposedText = fullText.split('\n').map((line) {
      return TransposeHelper.transpose(line, _transposeSteps);
    }).join('\n');

    final spans = RichSongParser.parseSong(
      transposedText,
      textFontSize: _textFontSize,
      chordFontSize: _chordFontSize,
      textColor: _textColor,
      chordColor: _chordColor,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SongControlsWidget(
              onTransposeUp: _transposeUp,
              onTransposeDown: _transposeDown,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              songName: _songName,
              filePath: _currentFile?.path,
              onSettingsChanged: _onSettingsChanged,
              onSongEdited: _refreshCurrentSong,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: _previousSong),
                  Text(_songName ?? 'Pjesma', style: const TextStyle(fontSize: 18)),
                  IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _nextSong),
                ],
              ),
            ),
            Expanded(
              child: _songLines.isEmpty
                  ? const Center(child: Text('Nema dostupnih pjesama.'))
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(text: TextSpan(children: spans)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
