import "dart:io";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../profile_setup/controllers/current_profile_loader.dart";
import "../utils/setlist_manager.dart";
import "../widgets/setlist_controls_widget.dart";

class SongSearchScreen extends StatefulWidget {
  const SongSearchScreen({super.key});

  @override
  State<SongSearchScreen> createState() => _SongSearchScreenState();
}

class _SongSearchScreenState extends State<SongSearchScreen> {
  List<String> allSongs = [];
  List<String> filteredSongs = [];
  String searchQuery = "";
  String? activeSetlistName;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final profile = await CurrentProfileLoader.loadLastProfile();
    final folderPath = profile?['text_folder'];

    if (folderPath == null) return;

    final folder = Directory(folderPath);
    if (!folder.existsSync()) return;

    final txtFiles = folder
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith(".txt"))
        .map((file) => file.uri.pathSegments.last)
        .toList();

    setState(() {
      allSongs = txtFiles;
      filteredSongs = txtFiles;
    });
  }

  void _filterSongs(String query) {
    setState(() {
      searchQuery = query;
      filteredSongs = allSongs
          .where((song) => song.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _setActiveSetlist(String name) {
    setState(() {
      activeSetlistName = name;
    });
  }

  void _addToSetlist(String song) {
    if (activeSetlistName == null) return;
    SetlistManager.addSong(song, activeSetlistName!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pretraga pjesama")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterSongs,
              decoration: const InputDecoration(
                labelText: "Pretraži...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SetlistControlsWidget(
              onSetlistCreated: _setActiveSetlist,
            ),
          ),
          if (activeSetlistName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Aktivna lista: $activeSetlistName"),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return ListTile(
                  title: Text(song),
                  onTap: () {
                    context.go("/song-view?file=$song");
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.playlist_add),
                    onPressed: () {
                      _addToSetlist(song);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
