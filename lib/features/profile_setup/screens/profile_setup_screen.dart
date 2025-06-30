import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import '../controllers/profile_controller.dart';
import '../controllers/active_profile_controller.dart';

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

  Future<String?> _copyFolderToProfile(String? sourcePath, String profileName, String subfolderName, String fileExtension) async {
    if (sourcePath == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final profilePath = '${appDir.path}/profiles/$profileName/$subfolderName';
    final profileDir = Directory(profilePath);

    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    final sourceDir = Directory(sourcePath);
    final files = sourceDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith(fileExtension))
        .toList();

    for (var file in files) {
      final fileName = file.uri.pathSegments.last;
      final newFile = File('$profilePath/$fileName');
      if (!await newFile.exists()) {
        await file.copy(newFile.path);
      }
    }

    return profilePath;
  }

  Future<void> _pickTextFolder() async {
    final result = await getDirectoryPath();
    if (result != null) {
      setState(() {
        _selectedTextFolder = result;
      });
    }
  }

  Future<void> _pickMediaFolder() async {
    final result = await getDirectoryPath();
    if (result != null) {
      setState(() {
        _selectedMediaFolder = result;
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

    final lyricsPath = await _copyFolderToProfile(text, name, 'txt', '.txt');
    final attachmentsPath = await _copyFolderToProfile(media, name, 'attachments', '');

    final appDir = await getApplicationDocumentsDirectory();
    final profileDir = Directory('${appDir.path}/profiles/$name');
    final settingsFile = File('${profileDir.path}/settings.json');
    if (!await settingsFile.exists()) {
      await settingsFile.writeAsString('{}');
    }

    await ProfileController.saveProfile(
      name: name,
      lyricsPath: lyricsPath ?? '',
      mediaPath: attachmentsPath ?? '',
      connection: conn,
    );

    await _loadProfiles();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil spremljen.')),
    );
  }

  Future<void> _confirmDelete(String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Potvrda'),
        content: Text('Želite li sigurno obrisati profil "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NE'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DA'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ProfileController.deleteProfile(name);
      await _loadProfiles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil obrisan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Postavljanje profila')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Ime profila (max 7 znakova):'),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _nameController,
                  maxLength: 7,
                  decoration: const InputDecoration(hintText: 'Unesi ime'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: _pickTextFolder,
                  child: Text(_selectedTextFolder ?? 'Odaberi mapu s tekstovima'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: _pickMediaFolder,
                  child: Text(_selectedMediaFolder ?? 'Odaberi prateću mapu'),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Odaberi vezu:'),
              SizedBox(
                width: 200,
                child: DropdownButton<String>(
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
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('SPREMI PROFIL'),
                ),
              ),
              const Divider(height: 40),
              const Text('Dostupni profili:'),
              const SizedBox(height: 10),
              for (var p in _profiles)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () async {
                            final name = p['name'];
                            await ActiveProfileController.setActiveProfile(name);

                            final appDir = await getApplicationDocumentsDirectory();
                            final profilePath = '${appDir.path}/profiles/$name';
                            final txtDir = Directory('$profilePath/txt');
                            final attachmentsDir = Directory('$profilePath/attachments');
                            final settingsFile = File('$profilePath/settings.json');

                            if (!await txtDir.exists()) await txtDir.create(recursive: true);
                            if (!await attachmentsDir.exists()) await attachmentsDir.create(recursive: true);
                            if (!await settingsFile.exists()) {
                              await settingsFile.writeAsString('{}');
                            }

                            setState(() {
                              _selectedProfile = p;
                            });
                          },
                          child: Text(p['name']),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(p['name']),
                      ),
                    ],
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
