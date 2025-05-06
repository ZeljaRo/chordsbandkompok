class SettingsSanitizer {
  static double sanitizeFontSize(dynamic value) {
    if (value is num && value >= 10 && value <= 50) {
      return value.toDouble();
    }
    return 18.0;
  }

  static int sanitizeScrollLines(dynamic value) {
    if (value is int && value >= 1 && value <= 30) {
      return value;
    }
    return 3;
  }
}
