import 'dart:math';

/// A single generated math problem.
class Problem {
  final String question;
  final String answer; // canonical string answer
  final String operation; // '+', '-', 'x', '/', or a label for higher maths

  const Problem({
    required this.question,
    required this.answer,
    required this.operation,
  });
}

/// Generates math problems for all modes and difficulty levels.
class ProblemGenerator {
  static final Random _rng = Random();

  // ---- Basic operations ----

  static Problem addition(int max) {
    final a = _rng.nextInt(max) + 1;
    final b = _rng.nextInt(max) + 1;
    return Problem(
      question: '$a + $b = ?',
      answer: '${a + b}',
      operation: '+',
    );
  }

  static Problem subtraction(int max) {
    final a = _rng.nextInt(max) + 1;
    final b = _rng.nextInt(a) + 1; // ensures non-negative result
    return Problem(
      question: '$a - $b = ?',
      answer: '${a - b}',
      operation: '-',
    );
  }

  static Problem multiplication(int tableMax) {
    final a = _rng.nextInt(tableMax) + 1;
    final b = _rng.nextInt(12) + 1;
    return Problem(
      question: '$a x $b = ?',
      answer: '${a * b}',
      operation: 'x',
    );
  }

  static Problem division(int divisorMax) {
    final divisor = _rng.nextInt(divisorMax) + 1;
    final quotient = _rng.nextInt(12) + 1;
    final dividend = divisor * quotient;
    return Problem(
      question: '$dividend / $divisor = ?',
      answer: '$quotient',
      operation: '/',
    );
  }

  /// Generates a problem for a given mode and difficulty.
  static Problem generate(String mode, String difficulty) {
    switch (mode) {
      case 'Addition':
        return addition(_rangeFor(difficulty));
      case 'Subtraction':
        return subtraction(_rangeFor(difficulty));
      case 'Multiplication':
        return multiplication(_tableMaxFor(difficulty));
      case 'Division':
        return division(_divisorMaxFor(difficulty));
      case 'Combined':
        final ops = ['Addition', 'Subtraction', 'Multiplication', 'Division'];
        return generate(ops[_rng.nextInt(ops.length)], difficulty);
      default:
        return addition(10);
    }
  }

  // ---- Table practice ----

  /// Generates a table practice problem for a specific table and mode.
  static Problem tableProblem(int table, String mode) {
    final n = _rng.nextInt(9) + 1; // 1..9
    switch (mode) {
      case 'Sequential':
        // handled by caller with explicit n; here random
        return Problem(
          question: '$table x $n = ?',
          answer: '${table * n}',
          operation: 'x',
        );
      case 'Reverse':
        final product = table * n;
        return Problem(
          question: '? x $table = $product',
          answer: '$n',
          operation: 'x',
        );
      case 'FillBlank':
        final product = table * n;
        return Problem(
          question: '$table x ? = $product',
          answer: '$n',
          operation: 'x',
        );
      default: // Random
        return Problem(
          question: '$table x $n = ?',
          answer: '${table * n}',
          operation: 'x',
        );
    }
  }

  // ---- Higher order maths ----

  static Problem higherMath(String topic) {
    switch (topic) {
      case 'Fractions':
        final d = _rng.nextInt(8) + 2;
        final a = _rng.nextInt(d - 1) + 1;
        final b = _rng.nextInt(d - 1) + 1;
        final num = a + b;
        final gcd = _gcd(num, d);
        final ansNum = num ~/ gcd;
        final ansDen = d ~/ gcd;
        return Problem(
          question: '$a/$d + $b/$d = ?',
          answer: ansDen == 1 ? '$ansNum' : '$ansNum/$ansDen',
          operation: 'Fractions',
        );
      case 'Powers':
        final base = _rng.nextInt(9) + 2;
        final exp = _rng.nextInt(3) + 2; // 2..4
        return Problem(
          question: '$base^$exp = ?',
          answer: '${pow(base, exp).toInt()}',
          operation: 'Powers',
        );
      case 'SquareRoots':
        final root = _rng.nextInt(9) + 1;
        return Problem(
          question: 'sqrt(${root * root}) = ?',
          answer: '$root',
          operation: 'SquareRoots',
        );
      case 'Percentages':
        final pct = (_rng.nextInt(9) + 1) * 10; // 10..90
        final base = _rng.nextInt(9) + 1;
        return Problem(
          question: '$pct% of $base = ?',
          answer: (pct * base / 100).toStringAsFixed(0),
          operation: 'Percentages',
        );
      case 'Algebra':
        final x = _rng.nextInt(9) + 1;
        final c = _rng.nextInt(9) + 1;
        final rhs = x + c;
        return Problem(
          question: 'x + $c = $rhs, x = ?',
          answer: '$x',
          operation: 'Algebra',
        );
      case 'Averages':
        final a = _rng.nextInt(9) + 1;
        final b = _rng.nextInt(9) + 1;
        final c = _rng.nextInt(9) + 1;
        final avg = ((a + b + c) / 3).toStringAsFixed(1);
        return Problem(
          question: 'Mean of $a, $b, $c = ?',
          answer: avg,
          operation: 'Averages',
        );
      default:
        return addition(10);
    }
  }

  // ---- Helpers ----

  static int _rangeFor(String difficulty) {
    switch (difficulty) {
      case 'Medium':
        return 50;
      case 'Hard':
        return 100;
      default:
        return 10;
    }
  }

  static int _tableMaxFor(String difficulty) {
    switch (difficulty) {
      case 'Tables 1-5':
        return 5;
      case 'Tables 6-10':
        return 10;
      case 'Tables 1-12':
        return 12;
      default:
        return 9;
    }
  }

  static int _divisorMaxFor(String difficulty) {
    switch (difficulty) {
      case 'Medium':
        return 10;
      case 'Hard':
        return 12;
      default:
        return 5;
    }
  }

  static int _gcd(int a, int b) {
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }
}