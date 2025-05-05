import "package:flutter/material.dart";

class RichSongParser {
  static List<TextSpan> parseSong(
    String text, {
    double textFontSize = 18,
    double chordFontSize = 20,
    Color textColor = Colors.black,
    Color chordColor = Colors.blue,
  }) {
    final regex = RegExp(r'(\(.*?\))');
    final spans = <TextSpan>[];

    text.split('\n').forEach((line) {
      final matches = regex.allMatches(line);
      int lastMatchEnd = 0;

      for (final match in matches) {
        if (match.start > lastMatchEnd) {
          spans.add(TextSpan(
            text: line.substring(lastMatchEnd, match.start),
            style: TextStyle(
              fontSize: textFontSize,
              color: textColor,
            ),
          ));
        }

        spans.add(TextSpan(
          text: match.group(0),
          style: TextStyle(
            fontSize: chordFontSize,
            color: chordColor,
            fontWeight: FontWeight.bold,
          ),
        ));

        lastMatchEnd = match.end;
      }

      if (lastMatchEnd < line.length) {
        spans.add(TextSpan(
          text: line.substring(lastMatchEnd),
          style: TextStyle(
            fontSize: textFontSize,
            color: textColor,
          ),
        ));
      }

      spans.add(const TextSpan(text: '\n'));
    });

    return spans;
  }
}
