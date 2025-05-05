import 'package:flutter/material.dart';
import 'dart:io';
import '../controllers/song_editor_controller.dart';

class SongEditScreen extends StatefulWidget {
  final String filePath;

  const SongEditScreen({super.key, required this.filePath});

  @override
  State<SongEditScreen> createState() => _SongEditScreenState();
}

class _SongEditScreenState extends State<SongEditScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    final file = File(widget.filePath);
    if (await file.exists()) {
      _controller.text = await file.readAsString();
    }
    setState(() {});
  }

  Future<void> _save() async {
    await SongEditorController.saveEditedSong(widget.filePath, _controller.text);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uredi tekst'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
