import "dart:io";
import "package:flutter/material.dart";
import "package:open_file/open_file.dart";
import "../../profile_setup/controllers/active_profile_controller.dart";
import "../controllers/song_settings_controller.dart";

class AttachmentButton extends StatefulWidget {
  final String? songName;

  const AttachmentButton({super.key, this.songName});

  @override
  State<AttachmentButton> createState() => _AttachmentButtonState();
}

class _AttachmentButtonState extends State<AttachmentButton> {
  String? currentFile;

  @override
  void initState() {
    super.initState();
    _refreshFile();
  }

  void _refreshFile() {
    if (widget.songName != null) {
      setState(() {
        currentFile = SongSettingsController.getAttachment(widget.songName!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: currentFile ?? "Nema pratećeg fajla",
      child: IconButton(
        icon: const Icon(Icons.attach_file),
        onPressed: () async {
          if (widget.songName == null) return;

          final profile = await ActiveProfileController.getActiveProfileData();
          if (profile == null || profile['mediaPath'] == null) return;

          final dir = Directory(profile['mediaPath']);
          if (!dir.existsSync()) return;

          if (currentFile != null) {
            final choice = await showDialog<String>(
              context: context,
              builder: (ctx) => SimpleDialog(
                title: const Text("Prateći fajl"),
                children: [
                  SimpleDialogOption(
                    child: const Text("Otvori fajl"),
                    onPressed: () => Navigator.pop(ctx, "open"),
                  ),
                  SimpleDialogOption(
                    child: const Text("Promijeni fajl"),
                    onPressed: () => Navigator.pop(ctx, "change"),
                  ),
                ],
              ),
            );

            if (choice == "open") {
              final fullPath = "${dir.path}${Platform.pathSeparator}$currentFile";
              if (await File(fullPath).exists()) {
                OpenFile.open(fullPath);
              }
              return;
            }

            if (choice != "change") return;
          }

          final files = dir
              .listSync()
              .whereType<File>()
              .map((f) => f.path.split(Platform.pathSeparator).last)
              .toList();

          if (files.isEmpty) return;

          final selected = await showDialog<String>(
            context: context,
            builder: (ctx) => SimpleDialog(
              title: const Text("Odaberi prateći fajl"),
              children: files.map((file) {
                return SimpleDialogOption(
                  child: Text(file),
                  onPressed: () => Navigator.pop(ctx, file),
                );
              }).toList(),
            ),
          );

          if (selected != null) {
            SongSettingsController.setAttachment(widget.songName!, selected);
            _refreshFile();
          }
        },
      ),
    );
  }
}
