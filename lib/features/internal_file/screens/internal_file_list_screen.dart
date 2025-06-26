import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chordsbandkompok/features/internal_file/utils/song_loader.dart';

class InternalFileListScreen extends StatefulWidget {
  const InternalFileListScreen({super.key});

  @override
  State<InternalFileListScreen> createState() => _InternalFileListScreenState();
}

class _InternalFileListScreenState extends State<InternalFileListScreen> {
  List<File> _txtFiles = [];

  @override
  void initState() {
    super.initState();
    _loadTxtFiles();
  }

  Future<void> _loadTxtFiles() async {
    final files = await SongLoader.loadTxtFiles();
    setState(() {
      _txtFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popis pjesama'),
      ),
      body: ListView.builder(
        itemCount: _txtFiles.length,
        itemBuilder: (context, index) {
          final fileName = _txtFiles[index].uri.pathSegments.last;
          return ListTile(
            title: Text(fileName),
            onTap: () {
              context.push('/song', extra: fileName);
            },
          );
        },
      ),
    );
  }
}
