import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "../../profile_setup/controllers/current_profile_loader.dart";

class SetlistControlsWidget extends StatefulWidget {
  final void Function(String)? onSetlistCreated;

  const SetlistControlsWidget({super.key, this.onSetlistCreated});

  @override
  State<SetlistControlsWidget> createState() => _SetlistControlsWidgetState();
}

class _SetlistControlsWidgetState extends State<SetlistControlsWidget> {
  final TextEditingController _controller = TextEditingController();
  String? activeSetlistName;

  void _createSetlist() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final profile = await CurrentProfileLoader.loadLastProfile();
    final folder = Directory("${profile?['text_folder']}\\setlists");
    if (!folder.existsSync()) folder.createSync(recursive: true);

    final file = File("${folder.path}\\$name.json");
    if (!file.existsSync()) {
      file.writeAsStringSync(jsonEncode([]));
    }

    setState(() {
      activeSetlistName = name;
    });

    if (widget.onSetlistCreated != null) {
      widget.onSetlistCreated!(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Unesi ime nove set liste",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _createSetlist,
              child: const Text("Kreiraj"),
            ),
          ],
        ),
        if (activeSetlistName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("Aktivna set lista: $activeSetlistName"),
          ),
      ],
    );
  }
}
