import "package:flutter/material.dart";
import "dart:io";
import "package:path_provider/path_provider.dart";
import "../widgets/song_controls_widget.dart";
import "../utils/transpose_helper.dart";
import "../utils/rich_song_parser.dart";
import "../controllers/song_settings_controller.dart";
import '../widgets/scroll_control_widget.dart';
import '../../profile_setup/controllers/active_profile_controller.dart';

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

  int _scrollUpLines = 3;
  int _scrollDownLines = 5;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SongSettingsController.loadSettings().then((_) {
      _loadSongsFromProfile();
    });
  }

  Future<void> _loadSongsFromProfile() async {
    final profile = await ActiveProfileController.getActiveProfileData();
    if (profile == null || profile['lyricsPath'] == null) return;

    final dir = Directory(profile['lyricsPath']);
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
      _scrollUpLines = SongSettingsController.getScrollUpLines(_songName!);
      _scrollDownLines = SongSettingsController.getScrollDownLines(_songName!);
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

  void _onSettingsChanged() {
    _loadSettingsForSong();
  }

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

  void _scrollUp() {
    final offset = (_scrollUpLines * 20).toDouble();
    _scrollController.animateTo(
      _scrollController.offset - offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollDown() {
    final offset = (_scrollDownLines * 20).toDouble();
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
        child: Stack(
          children: [
            Column(
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
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: _previousSong),
                      const SizedBox(width: 16),
                      IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _nextSong),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    _songName ?? 'Pjesma',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: _songLines.isEmpty
                      ? const Center(child: Text('Nema dostupnih pjesama.'))
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: RichText(text: TextSpan(children: spans)),
                          ),
                        ),
                ),
              ],
            ),
            ScrollControlWidget(
              onScrollUp: _scrollUp,
              onScrollDown: _scrollDown,
            ),
          ],
        ),
      ),
    );
  }
}
