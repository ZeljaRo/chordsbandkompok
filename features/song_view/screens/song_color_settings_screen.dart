import 'package:flutter/material.dart';

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
  late Color textColor;
  late Color chordColor;

  @override
  void initState() {
    super.initState();
    textColor = widget.initialTextColor;
    chordColor = widget.initialChordColor;
  }

  void _save() {
    Navigator.of(context).pop({
      'textColor': textColor,
      'chordColor': chordColor,
    });
  }

  Widget _colorOption(Color color, bool isSelected, void Function(Color) onSelect) {
    return GestureDetector(
      onTap: () => setState(() => onSelect(color)),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odabir boja'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Boja TEKSTA'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorOption(Colors.black, textColor == Colors.black, (c) => textColor = c),
                _colorOption(Colors.red, textColor == Colors.red, (c) => textColor = c),
                _colorOption(Colors.green, textColor == Colors.green, (c) => textColor = c),
                _colorOption(Colors.blue, textColor == Colors.blue, (c) => textColor = c),
                _colorOption(Colors.purple, textColor == Colors.purple, (c) => textColor = c),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Boja AKORDA'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorOption(Colors.blue, chordColor == Colors.blue, (c) => chordColor = c),
                _colorOption(Colors.red, chordColor == Colors.red, (c) => chordColor = c),
                _colorOption(Colors.green, chordColor == Colors.green, (c) => chordColor = c),
                _colorOption(Colors.orange, chordColor == Colors.orange, (c) => chordColor = c),
                _colorOption(Colors.lightBlueAccent, chordColor == Colors.lightBlueAccent, (c) => chordColor = c),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
