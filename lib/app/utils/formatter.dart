class Formatter {
  static String formatScanValue(String rawValue) {
    return rawValue.replaceAll(RegExp(r'^!'), '').replaceAll(RegExp(r'\?$'), '');
  }
}
