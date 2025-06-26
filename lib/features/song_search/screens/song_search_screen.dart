import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chordsbandkompok/features/song_view/screens/song_view_screen.dart';

class SongSearchScreen extends StatefulWidget {
  const SongSearchScreen({Key? key}) : super(key: key);

  @override
  State<SongSearchScreen> createState() => _SongSearchScreenState();
}

class _SongSearchScreenState extends State<SongSearchScreen> {
  List<File> _txtFiles = [];
  List<File> _filteredFiles = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTxtFiles();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadTxtFiles() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory txtDir = Directory('${appDir.path}/txt');

    if (await txtDir.exists()) {
      final allFiles = txtDir.listSync();
      final txtFiles = allFiles
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.txt'))
          .toList();

      setState(() {
        _txtFiles = txtFiles;
        _filteredFiles = txtFiles;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFiles = _txtFiles
          .where((file) => file.path.toLowerCase().contains(query))
          .toList();
    });
  }

  void _openSong(File file) {
    final String fileName = file.uri.pathSegments.last;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SongViewScreen(fileName: fileName),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popis pjesama'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Pretraži pjesme...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredFiles.isEmpty
                ? const Center(child: Text('Nema pjesama'))
                : ListView.builder(
                    itemCount: _filteredFiles.length,
                    itemBuilder: (context, index) {
                      final file = _filteredFiles[index];
                      final fileName = file.uri.pathSegments.last;
                      return ListTile(
                        title: Text(fileName),
                        onTap: () => _openSong(file),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
