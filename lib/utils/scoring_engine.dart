/// Scoring engine implementing the scoring rules from the requirements.
///
/// Correct answer: +10 points
/// Streak bonus: +2 per streak (max +10)
/// Wrong answer: -20 points (minimum score: 0)
class ScoringEngine {
  static const int correctPoints = 10;
  static const int wrongPenalty = 20;
  static const int streakBonusPer = 2;
  static const int streakBonusMax = 10;

  int _score = 0;
  int _streak = 0;
  int _longestStreak = 0;
  int _correct = 0;
  int _wrong = 0;
  int _total = 0;

  int get score => _score;
  int get streak => _streak;
  int get longestStreak => _longestStreak;
  int get correct => _correct;
  int get wrong => _wrong;
  int get total => _total;

  /// Evaluates an answer. Returns the points awarded (can be negative).
  int evaluate(String userAnswer, String correctAnswer) {
    _total++;
    final isCorrect = _answersMatch(userAnswer, correctAnswer);
    if (isCorrect) {
      _correct++;
      _streak++;
      if (_streak > _longestStreak) _longestStreak = _streak;
      var points = correctPoints;
      final bonus = (_streak ~/ 2) * streakBonusPer;
      points += bonus.clamp(0, streakBonusMax);
      _score += points;
      return points;
    } else {
      _wrong++;
      _streak = 0;
      _score = (_score - wrongPenalty).clamp(0, 1 << 30).toInt();
      return -wrongPenalty;
    }
  }

  double get accuracy =>
      _total == 0 ? 0 : (_correct / _total) * 100;

  /// Compares two answers, tolerating numeric formatting differences
  /// (e.g. "4" == "4.0", "1/2" == "0.5").
  bool _answersMatch(String user, String correct) {
    final u = user.trim();
    final c = correct.trim();
    if (u == c) return true;

    // Convert each side to a numeric value if possible (decimal or fraction).
    final uVal = _toNumeric(u);
    final cVal = _toNumeric(c);
    if (uVal != null && cVal != null) {
      return (uVal - cVal).abs() < 0.001;
    }

    return false;
  }

  /// Converts a decimal or fraction string to a double, or null if not numeric.
  double? _toNumeric(String s) {
    final asDouble = double.tryParse(s);
    if (asDouble != null) return asDouble;
    return _parseFraction(s);
  }

  /// Parses a fraction string like "3/4" into a double, or null if not a fraction.
  double? _parseFraction(String s) {
    final parts = s.split('/');
    if (parts.length != 2) return null;
    final num = double.tryParse(parts[0].trim());
    final den = double.tryParse(parts[1].trim());
    if (num == null || den == null || den == 0) return null;
    return num / den;
  }

  /// Performance rating based on accuracy.
  String get rating {
    final acc = accuracy;
    if (acc > 90) return 'Excellent';
    if (acc >= 70) return 'Good';
    return 'Needs Practice';
  }
}