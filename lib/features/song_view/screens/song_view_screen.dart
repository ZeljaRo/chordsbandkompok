import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/song_controls_widget.dart';
import '../../profile_setup/controllers/current_profile_loader.dart';

class SongViewScreen extends StatefulWidget {
  const SongViewScreen({super.key});

  @override
  State<SongViewScreen> createState() => _SongViewScreenState();
}

class _SongViewScreenState extends State<SongViewScreen> {
  List<String> _songLines = [];
  String? _songName;

  @override
  void initState() {
    super.initState();
    _loadFirstSongFromProfile();
  }

  Future<void> _loadFirstSongFromProfile() async {
    final profile = await CurrentProfileLoader.loadLastProfile();
    if (profile == null || profile['text_folder'] == null) return;

    final dir = Directory(profile['text_folder']);
    if (!dir.existsSync()) return;

    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.txt')).toList();
    if (files.isEmpty) return;

    final file = files.first;
    final lines = await file.readAsLines();

    setState(() {
      _songLines = lines;
      _songName = file.uri.pathSegments.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // KORIŠTENJE PRAVOG WIDGETA
            const SongControlsWidget(),

            const Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
                  Text(_songName ?? 'Pjesma', style: const TextStyle(fontSize: 18)),
                  IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () {}),
                ],
              ),
            ),

            Expanded(
              child: _songLines.isEmpty
                  ? const Center(child: Text('Nema dostupnih pjesama.'))
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView(
                        children: _songLines.map((line) {
                          return Text(line, style: const TextStyle(fontSize: 18));
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
