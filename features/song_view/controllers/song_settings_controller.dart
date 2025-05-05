import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class SongSettingsController {
  static const String _filePath = 'settings.json';

  static Map<String, dynamic> _settings = {};

  static Future<void> loadSettings() async {
    final file = File(_filePath);
    if (file.existsSync()) {
      final content = await file.readAsString();
      _settings = jsonDecode(content);
    }
  }

  static Future<void> saveSettings() async {
    final file = File(_filePath);
    await file.writeAsString(jsonEncode(_settings));
  }

  static double getFontSize(String songName) {
    return _settings[songName]?['fontSize'] ?? 18.0;
  }

  static void setFontSize(String songName, double size) {
    _settings[songName] ??= {};
    _settings[songName]['fontSize'] = size;
    saveSettings();
  }

  static Color getTextColor(String songName) {
    final hex = _settings[songName]?['textColor'] ?? '#000000';
    return _colorFromHex(hex);
  }

  static Color getChordColor(String songName) {
    final hex = _settings[songName]?['chordColor'] ?? '#0000FF';
    return _colorFromHex(hex);
  }

  static void setTextColor(String songName, Color color) {
    _settings[songName] ??= {};
    _settings[songName]['textColor'] = _colorToHex(color);
    saveSettings();
  }

  static void setChordColor(String songName, Color color) {
    _settings[songName] ??= {};
    _settings[songName]['chordColor'] = _colorToHex(color);
    saveSettings();
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  static Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'ff$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
