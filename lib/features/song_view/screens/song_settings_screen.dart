import 'package:flutter/material.dart';

class SongSettingsScreen extends StatefulWidget {
  final double textFontSize;
  final double chordFontSize;
  final Color textColor;
  final Color chordColor;
  final int scrollUp;
  final int scrollDown;

  const SongSettingsScreen({
    super.key,
    required this.textFontSize,
    required this.chordFontSize,
    required this.textColor,
    required this.chordColor,
    required this.scrollUp,
    required this.scrollDown,
  });

  @override
  State<SongSettingsScreen> createState() => _SongSettingsScreenState();
}

class _SongSettingsScreenState extends State<SongSettingsScreen> {
  late double _textFontSize;
  late double _chordFontSize;
  late Color _textColor;
  late Color _chordColor;
  late int _scrollUp;
  late int _scrollDown;

  final List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _textFontSize = widget.textFontSize;
    _chordFontSize = widget.chordFontSize;
    _textColor = widget.textColor;
    _chordColor = widget.chordColor;
    _scrollUp = widget.scrollUp;
    _scrollDown = widget.scrollDown;
  }

  Widget _buildColorPicker(String label, Color selectedColor, ValueChanged<Color> onColorSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _colors.map((color) {
            return GestureDetector(
              onTap: () => setState(() => onColorSelected(color)),
              child: CircleAvatar(
                backgroundColor: color,
                radius: 16,
                child: selectedColor == color ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Postavke prikaza')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Veli�ina teksta'),
            Slider(
              value: _textFontSize,
              min: 10,
              max: 40,
              divisions: 15,
              label: _textFontSize.toStringAsFixed(0),
              onChanged: (value) => setState(() => _textFontSize = value),
            ),
            const SizedBox(height: 16),
            const Text('Veli�ina akorda'),
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
            const SizedBox(height: 24),
            const Text('Redova po scroll UP'),
            Slider(
              value: _scrollUp.toDouble(),
              min: 1,
              max: 15,
              divisions: 14,
              label: _scrollUp.toString(),
              onChanged: (value) => setState(() => _scrollUp = value.toInt()),
            ),
            const SizedBox(height: 16),
            const Text('Redova po scroll DOWN'),
            Slider(
              value: _scrollDown.toDouble(),
              min: 1,
              max: 15,
              divisions: 14,
              label: _scrollDown.toString(),
              onChanged: (value) => setState(() => _scrollDown = value.toInt()),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'textFontSize': _textFontSize,
                    'chordFontSize': _chordFontSize,
                    'textColor': _textColor,
                    'chordColor': _chordColor,
                    'scrollUp': _scrollUp,
                    'scrollDown': _scrollDown,
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
}
