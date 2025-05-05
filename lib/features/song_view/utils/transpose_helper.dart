class TransposeHelper {
  static final List<String> _notes = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  static String transpose(String line, int steps) {
    final regex = RegExp(r'\(([A-G][#b]?[^)]*)\)');
    return line.replaceAllMapped(regex, (match) {
      final full = match.group(0)!;
      final chord = match.group(1)!;
      final transposed = _transposeChord(chord, steps);
      return '($transposed)';
    });
  }

  static String _transposeChord(String chord, int steps) {
    for (final note in _notes) {
      if (chord.startsWith(note)) {
        final index = _notes.indexOf(note);
        final newIndex = (index + steps) % 12;
        final transposedNote = _notes[newIndex < 0 ? newIndex + 12 : newIndex];
        return transposedNote + chord.substring(note.length);
      }
    }
    return chord;
  }
}
