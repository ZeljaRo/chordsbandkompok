import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../controllers/profile_controller.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedTextFolder;
  String? _selectedMediaFolder;
  String? _selectedConnection;

  List<Map<String, dynamic>> _profiles = [];
  Map<String, dynamic>? _selectedProfile;

  Future<void> _loadProfiles() async {
    final loaded = await ProfileController.loadProfiles();
    setState(() {
      _profiles = loaded;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<String?> _copyToInternal(String? path, String folderName) async {
    if (path == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final newPath = '${dir.path}/$folderName';
    final newDir = Directory(newPath);
    if (!await newDir.exists()) {
      await newDir.create(recursive: true);
    }

    final sourceDir = Directory(path);
    final files = sourceDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.txt'))
        .toList();

    for (var file in files) {
      final fileName = file.uri.pathSegments.last;
      final newFile = File('$newPath/$fileName');
      if (!await newFile.exists()) {
        await file.copy(newFile.path);
      }
    }
    return newPath;
  }

  Future<void> _pickTextFolder() async {
    final result = await getDirectoryPath();
    if (result != null) {
      final copiedPath = await _copyToInternal(result, 'txt');
      setState(() {
        _selectedTextFolder = copiedPath;
      });
    }
  }

  Future<void> _pickMediaFolder() async {
    final result = await getDirectoryPath();
    if (result != null) {
      final copiedPath = await _copyToInternal(result, 'media');
      setState(() {
        _selectedMediaFolder = copiedPath;
      });
    }
  }

  void _saveProfile() async {
    final name = _nameController.text.trim();
    final text = _selectedTextFolder;
    final media = _selectedMediaFolder;
    final conn = _selectedConnection;

    if (name.isEmpty || text == null || media == null || conn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Molimo popunite sve podatke.')),
      );
      return;
    }

    await ProfileController.saveProfile(
      name: name,
      lyricsPath: text,
      mediaPath: media,
      connection: conn,
    );

    await _loadProfiles();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil spremljen.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Postavljanje profila')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ime profila (max 7 znakova):'),
              TextField(
                controller: _nameController,
                maxLength: 7,
                decoration: const InputDecoration(hintText: 'Unesi ime'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickTextFolder,
                child: Text(_selectedTextFolder ?? 'Odaberi mapu s tekstovima'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _pickMediaFolder,
                child: Text(_selectedMediaFolder ?? 'Odaberi prateću mapu'),
              ),
              const SizedBox(height: 20),
              const Text('Odaberi vezu:'),
              DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Veza'),
                value: _selectedConnection,
                items: const [
                  DropdownMenuItem(value: 'WiFi', child: Text('WiFi')),
                  DropdownMenuItem(value: 'Hotspot', child: Text('Hotspot')),
                  DropdownMenuItem(value: 'Bluetooth', child: Text('Bluetooth')),
                  DropdownMenuItem(value: 'Nema', child: Text('Bez veze')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedConnection = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('SPREMI PROFIL'),
              ),
              const Divider(height: 40),
              const Text('Dostupni profili:'),
              for (var p in _profiles)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedProfile = p;
                      });
                    },
                    child: Text(p['name']),
                  ),
                ),
              const SizedBox(height: 20),
              if (_selectedProfile != null)
                ElevatedButton(
                  onPressed: () {
                    context.go('/song-view');
                  },
                  child: const Text('ULAZ'),
                ),
              const SizedBox(height: 40),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 48,
                  onPressed: () {
                    context.go('/language');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
