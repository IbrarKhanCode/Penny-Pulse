class ExpenseTextValidator {
  static const int minMeaningfulWords = 2;
  static const int minChars = 10;
  static const String invalidPredictionMessage =
      'Please describe the expense in more detail';

  static const Set<String> _fillerWords = {
    'hello',
    'test',
    'okay',
    'hmm',
    'yes',
    'no',
    'acha',
    'haan',
  };

  static String normalize(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    return trimmed.replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isValidForPrediction(String input) {
    final normalized = normalize(input);
    if (normalized.isEmpty) {
      return false;
    }
    if (_isOnlyNumbersOrSymbols(normalized)) {
      return false;
    }

    final words = _extractWords(normalized);
    final meaningfulWords = _meaningfulWords(words);
    if (words.isNotEmpty && meaningfulWords.isEmpty) {
      return false;
    }
    final hasMeaningfulWords = meaningfulWords.length >= minMeaningfulWords;
    final hasMinChars = normalized.length >= minChars;

    return hasMeaningfulWords || hasMinChars;
  }

  static bool _isOnlyNumbersOrSymbols(String input) {
    return !RegExp(r'[A-Za-z]').hasMatch(input);
  }

  static List<String> _extractWords(String input) {
    return input
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map((word) => word.replaceAll(RegExp(r'[^a-z]'), ''))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  static List<String> _meaningfulWords(List<String> words) {
    return words.where((word) => !_fillerWords.contains(word)).toList();
  }
}
