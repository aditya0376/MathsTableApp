/// Represents a single practice session saved to the local database.
class Session {
  final int? id;
  final DateTime date;
  final String mode; // e.g. 'Addition', 'Multiplication', 'Table 7', 'Higher'
  final String difficulty;
  final int score;
  final double accuracy; // 0-100
  final int totalProblems;
  final int correct;
  final int wrong;
  final int durationSeconds;

  const Session({
    this.id,
    required this.date,
    required this.mode,
    required this.difficulty,
    required this.score,
    required this.accuracy,
    required this.totalProblems,
    required this.correct,
    required this.wrong,
    required this.durationSeconds,
  });

  /// Performance rating based on accuracy.
  String get rating {
    if (accuracy > 90) return 'Excellent';
    if (accuracy >= 70) return 'Good';
    return 'Needs Practice';
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mode': mode,
      'difficulty': difficulty,
      'score': score,
      'accuracy': accuracy,
      'totalProblems': totalProblems,
      'correct': correct,
      'wrong': wrong,
      'durationSeconds': durationSeconds,
    };
  }

  factory Session.fromMap(Map<String, Object?> map) {
    return Session(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      mode: map['mode'] as String,
      difficulty: map['difficulty'] as String,
      score: map['score'] as int,
      accuracy: (map['accuracy'] as num).toDouble(),
      totalProblems: map['totalProblems'] as int,
      correct: map['correct'] as int,
      wrong: map['wrong'] as int,
      durationSeconds: map['durationSeconds'] as int,
    );
  }
}