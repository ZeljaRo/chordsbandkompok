import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../profile_setup/controllers/active_profile_controller.dart';
import '../utils/settings_sanitizer.dart';

class SongSettingsController {
  static Map<String, dynamic> _settings = {};

  static Future<File?> _getSettingsFile() async {
    final profile = await ActiveProfileController.getActiveProfileData();
    if (profile == null || profile['lyricsPath'] == null) return null;

    final settingsPath = '${profile['lyricsPath']}/../settings.json';
    final file = File(settingsPath);
    return file;
  }

  static Future<void> loadSettings() async {
    final file = await _getSettingsFile();
    if (file == null || !file.existsSync()) return;

    final content = await file.readAsString();
    _settings = jsonDecode(content);
  }

  static Future<void> saveSettings() async {
    final file = await _getSettingsFile();
    if (file == null) return;

    await file.writeAsString(jsonEncode(_settings));
  }

  static double getTextFontSize(String songName) {
    return SettingsSanitizer.sanitizeFontSize(_settings[songName]?['textFontSize']);
  }

  static double getChordFontSize(String songName) {
    return SettingsSanitizer.sanitizeFontSize(_settings[songName]?['chordFontSize']);
  }

  static void setTextFontSize(String songName, double size) {
    _settings[songName] ??= {};
    _settings[songName]['textFontSize'] = size;
    saveSettings();
  }

  static void setChordFontSize(String songName, double size) {
    _settings[songName] ??= {};
    _settings[songName]['chordFontSize'] = size;
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

  static String? getAttachment(String songName) {
    return _settings[songName]?['attachment'];
  }

  static void setAttachment(String songName, String fileName) {
    _settings[songName] ??= {};
    _settings[songName]['attachment'] = fileName;
    saveSettings();
  }

  static int getScrollUpLines(String songName) {
    return SettingsSanitizer.sanitizeScrollLines(_settings[songName]?['scrollUp']);
  }

  static int getScrollDownLines(String songName) {
    return SettingsSanitizer.sanitizeScrollLines(_settings[songName]?['scrollDown']);
  }

  static void setScrollUpLines(String songName, int value) {
    _settings[songName] ??= {};
    _settings[songName]['scrollUp'] = value;
    saveSettings();
  }

  static void setScrollDownLines(String songName, int value) {
    _settings[songName] ??= {};
    _settings[songName]['scrollDown'] = value;
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
