import 'package:flutter/material.dart';

class SongSettingsScreen extends StatefulWidget {
  const SongSettingsScreen({super.key});

  @override
  State<SongSettingsScreen> createState() => _SongSettingsScreenState();
}

class _SongSettingsScreenState extends State<SongSettingsScreen> {
  double _textFontSize = 18;
  double _chordFontSize = 20;
  Color _textColor = Colors.black;
  Color _chordColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Postavke pjesme')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Velièina teksta'),
            Slider(
              value: _textFontSize,
              min: 10,
              max: 40,
              divisions: 15,
              label: _textFontSize.toStringAsFixed(0),
              onChanged: (value) => setState(() => _textFontSize = value),
            ),
            const SizedBox(height: 16),
            const Text('Velièina akorda'),
            Slider(
              value: _chordFontSize,
              min: 10,
              max: 40,
              divisions: 15,
              label: _chordFontSize.toStringAsFixed(0),
              onChanged: (value) => setState(() => _chordFontSize = value),
            ),
            const SizedBox(height: 24),
            _buildColorPicker('Boja teksta', _textColor, (color) => _textColor = color),
            const SizedBox(height: 16),
            _buildColorPicker('Boja akorda', _chordColor, (color) => _chordColor = color),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'textFontSize': _textFontSize,
                    'chordFontSize': _chordFontSize,
                    'textColor': _textColor,
                    'chordColor': _chordColor,
                  });
                },
                child: const Text('Spremi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(String label, Color color, ValueChanged<Color> onColorChanged) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () async {
            final picked = await showDialog<Color>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Odaberi boju'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: color,
                    onColorChanged: (newColor) {
                      Navigator.of(context).pop(newColor);
                    },
                  ),
                ),
              ),
            );
            if (picked != null) {
              setState(() {
                onColorChanged(picked);
              });
            }
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class BlockPicker extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const BlockPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.black, Colors.white, Colors.red, Colors.green, Colors.blue,
      Colors.orange, Colors.purple, Colors.brown, Colors.grey,
    ];

    return Wrap(
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            margin: const EdgeInsets.all(4),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: pickerColor == color ? Colors.black : Colors.transparent,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
