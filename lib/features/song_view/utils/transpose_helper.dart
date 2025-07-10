class TransposeHelper {
  static const Map<String, String> _plusOneMap = {
    'C': 'CIS', 'CIS': 'D',
    'D': 'DIS', 'DIS': 'E',
    'E': 'F',
    'F': 'FIS', 'FIS': 'G',
    'G': 'GIS', 'GIS': 'A',
    'A': 'B', 'B': 'H',
    'H': 'C'
  };

  static const Map<String, String> _minusOneMap = {
    'C': 'H', 'H': 'B', 'B': 'A',
    'A': 'GIS', 'GIS': 'G',
    'G': 'FIS', 'FIS': 'F',
    'F': 'E',
    'E': 'DIS', 'DIS': 'D',
    'D': 'CIS', 'CIS': 'C'
  };

  static String transpose(String line, int steps) {
    final regex = RegExp(r'\(([^\)]+)\)');
    return line.replaceAllMapped(regex, (match) {
      final original = match.group(1)!;

      // Podrška za više akorda unutar iste zagrade, odvojenih zarezima
      final chords = original.split(',').map((e) => e.trim()).toList();
      final transposedChords =
          chords.map((chord) => _transposeChord(chord, steps)).toList();
      return '(${transposedChords.join(',')})';
    });
  }

  static String _transposeChord(String chord, int steps) {
    final slashParts = chord.split('/');
    final mainPart = slashParts[0];
    final bassPart = slashParts.length > 1 ? slashParts[1] : null;

    final rootMatch = RegExp(r'^[A-Ha-h](IS|is|#)?').firstMatch(mainPart);
    if (rootMatch == null) return chord;

    final root = rootMatch.group(0)!;
    final suffix = mainPart.substring(root.length);

    final transposedRoot = _transposeRoot(root, steps);
    final transposedBass = bassPart != null ? _transposeRoot(bassPart, steps) : null;

    final fullChord = transposedRoot + suffix;
    return transposedBass != null ? '$fullChord/$transposedBass' : fullChord;
  }

  static String _transposeRoot(String input, int steps) {
    final normalized = input.toUpperCase().replaceAll('#', 'IS');

    final map = steps > 0 ? _plusOneMap : _minusOneMap;
    final stepCount = steps.abs();

    String result = normalized;
    for (int i = 0; i < stepCount; i++) {
      result = map[result] ?? result;
    }

    // Zadrži format originalnog unosa (case-sensitive)
    if (input == input.toLowerCase()) {
      return result.toLowerCase();
    } else if (input[0] == input[0].toLowerCase()) {
      return result[0].toLowerCase() + result.substring(1);
    }
    return result;
  }
}
