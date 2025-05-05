import 'package:flutter/material.dart';

class RichSongParser {
  static List<TextSpan> parseSong(
    String text, {
    double scaleFactor = 1.0,
    double textFontSize = 18,
    double chordFontSize = 20,
    Color textColor = Colors.black,
    Color chordColor = Colors.blue,
  }) {
    List<TextSpan> spans = [];
    final regex = RegExp(r'(\(.*?\))');
    final lines = text.split('\n');

    for (var line in lines) {
      final matches = regex.allMatches(line);
      int lastMatchEnd = 0;

      for (final match in matches) {
        if (match.start > lastMatchEnd) {
          final normalText = line.substring(lastMatchEnd, match.start);
          spans.add(TextSpan(
            text: normalText,
            style: TextStyle(
              color: textColor,
              fontSize: textFontSize * scaleFactor,
            ),
          ));
        }

        final chordText = match.group(0)!;
        spans.add(TextSpan(
          text: chordText,
          style: TextStyle(
            color: chordColor,
            fontWeight: FontWeight.bold,
            fontSize: chordFontSize * scaleFactor,
          ),
        ));

        lastMatchEnd = match.end;
      }

      if (lastMatchEnd < line.length) {
        final normalText = line.substring(lastMatchEnd);
        spans.add(TextSpan(
          text: normalText,
          style: TextStyle(
            color: textColor,
            fontSize: textFontSize * scaleFactor,
          ),
        ));
      }

      spans.add(const TextSpan(text: '\n'));
    }

    return spans;
  }
}
