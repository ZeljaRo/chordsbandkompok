import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../profile_setup/controllers/active_profile_controller.dart';

class SongSearchScreen extends StatefulWidget {
  const SongSearchScreen({super.key});

  @override
  State<SongSearchScreen> createState() => _SongSearchScreenState();
}

class _SongSearchScreenState extends State<SongSearchScreen> {
  List<String> allSongs = [];
  List<String> filteredSongs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSongs();
    _searchController.addListener(_filterSongs);
  }

  Future<void> _loadSongs() async {
    final profile = await ActiveProfileController.getActiveProfileData();
    final lyricsPath = profile?['lyricsPath'];
    if (lyricsPath == null) return;

    final dir = Directory(lyricsPath);
    if (!dir.existsSync()) return;

    final files = dir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.txt'))
        .toList();

    final songNames = files.map((f) => f.uri.pathSegments.last).toList();

    setState(() {
      allSongs = songNames;
      filteredSongs = songNames;
    });
  }

  void _filterSongs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredSongs = allSongs
          .where((song) => song.toLowerCase().contains(query))
          .toList();
    });
  }

  void _openSong(String fileName) {
    context.go('/song-view?file=$fileName');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pretraga pjesama')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pretraži pjesme...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return ListTile(
                  title: Text(song),
                  onTap: () => _openSong(song),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
