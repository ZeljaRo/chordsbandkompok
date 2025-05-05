import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SongColorSettingsScreen extends StatefulWidget {
  final Color initialTextColor;
  final Color initialChordColor;

  const SongColorSettingsScreen({
    super.key,
    required this.initialTextColor,
    required this.initialChordColor,
  });

  @override
  State<SongColorSettingsScreen> createState() => _SongColorSettingsScreenState();
}

class _SongColorSettingsScreenState extends State<SongColorSettingsScreen> {
  late Color _textColor;
  late Color _chordColor;

  @override
  void initState() {
    super.initState();
    _textColor = widget.initialTextColor;
    _chordColor = widget.initialChordColor;
  }

  Future<void> _pickColor({
    required Color currentColor,
    required ValueChanged<Color> onColorSelected,
  }) async {
    final newColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odaberi boju'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: onColorSelected,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(currentColor),
            child: const Text('Zatvori'),
          ),
        ],
      ),
    );

    if (newColor != null) {
      onColorSelected(newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boje prikaza')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Boja teksta'),
            trailing: Container(
              width: 24,
              height: 24,
              color: _textColor,
            ),
            onTap: () => _pickColor(
              currentColor: _textColor,
              onColorSelected: (color) => setState(() => _textColor = color),
            ),
          ),
          ListTile(
            title: const Text('Boja akorda'),
            trailing: Container(
              width: 24,
              height: 24,
              color: _chordColor,
            ),
            onTap: () => _pickColor(
              currentColor: _chordColor,
              onColorSelected: (color) => setState(() => _chordColor = color),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'textColor': _textColor,
                  'chordColor': _chordColor,
                });
              },
              child: const Text('Spremi'),
            ),
          )
        ],
      ),
    );
  }
}
