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
    final isCorrect = userAnswer.trim() == correctAnswer.trim();
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

  /// Performance rating based on accuracy.
  String get rating {
    final acc = accuracy;
    if (acc > 90) return 'Excellent';
    if (acc >= 70) return 'Good';
    return 'Needs Practice';
  }
}