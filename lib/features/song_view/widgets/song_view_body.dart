import 'package:flutter/material.dart';
import '../../internal_file/utils/song_loader.dart';
import '../widgets/song_text_container.dart';

class SongViewBody extends StatefulWidget {
  final String filePath;

  const SongViewBody({super.key, required this.filePath});

  @override
  State<SongViewBody> createState() => _SongViewBodyState();
}

class _SongViewBodyState extends State<SongViewBody> {
  String _songText = '';
  String _filename = '';

  @override
  void initState() {
    super.initState();
    _loadSong();
  }

  Future<void> _loadSong() async {
    final content = await SongLoader.loadFromInternalPath(widget.filePath);
    setState(() {
      _songText = content;
      _filename = widget.filePath.split('/').last;
    });
    debugPrint('[SONG] Učitana pjesma: $_filename');
  }

  @override
  Widget build(BuildContext context) {
    return SongTextContainer(songText: _songText, songFilename: _filename);
  }
}
