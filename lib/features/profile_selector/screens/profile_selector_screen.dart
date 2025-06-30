import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../profile_setup/controllers/active_profile_controller.dart';
import '../../../profile_setup/screens/profile_setup_screen.dart';

class ProfileSelectorScreen extends StatefulWidget {
  const ProfileSelectorScreen({super.key});

  @override
  State<ProfileSelectorScreen> createState() => _ProfileSelectorScreenState();
}

class _ProfileSelectorScreenState extends State<ProfileSelectorScreen> {
  List<String> profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final profilesDir = Directory("${baseDir.path}/profiles");

    if (await profilesDir.exists()) {
      final dirs = profilesDir.listSync().whereType<Directory>().toList();
      final names = dirs.map((d) => d.path.split(Platform.pathSeparator).last).toList();
      setState(() {
        profiles = names;
      });
    }
  }

  void _selectProfile(String name) async {
    await ActiveProfileController.setActiveProfile(name);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
      );
    }
  }

  void _deleteProfile(String name) async {
    final baseDir = await getApplicationDocumentsDirectory();
    final target = Directory("${baseDir.path}/profiles/$name");

    if (await target.exists()) {
      await target.delete(recursive: true);
      _loadProfiles(); // refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Odabir profila")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Primjer testnog ograničenja širine za unos imena profila (ako postoji)
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Unesi ime profila',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: profiles.isNotEmpty
                  ? ListView.builder(
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(profiles[index]),
                          onTap: () => _selectProfile(profiles[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProfile(profiles[index]),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("Nema profila")),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
                );
              },
              child: const Text("Novi profil"),
            ),
          ],
        ),
      ),
    );
  }
}
