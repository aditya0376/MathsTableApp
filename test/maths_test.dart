import 'package:flutter_test/flutter_test.dart';
import 'package:maths_tables_app/utils/problem_generator.dart';
import 'package:maths_tables_app/utils/scoring_engine.dart';

void main() {
  group('ProblemGenerator', () {
    test('addition produces correct answer', () {
      for (var i = 0; i < 100; i++) {
        final p = ProblemGenerator.addition(10);
        final parts = p.question.split(' ');
        final a = int.parse(parts[0]);
        final b = int.parse(parts[2]);
        expect(p.answer, '${a + b}');
      }
    });

    test('subtraction never produces negative results', () {
      for (var i = 0; i < 100; i++) {
        final p = ProblemGenerator.subtraction(50);
        final parts = p.question.split(' ');
        final a = int.parse(parts[0]);
        final b = int.parse(parts[2]);
        expect(a - b, greaterThanOrEqualTo(0));
        expect(p.answer, '${a - b}');
      }
    });

    test('division always has whole number answers', () {
      for (var i = 0; i < 100; i++) {
        final p = ProblemGenerator.division(10);
        expect(p.answer, isNot(contains('.')));
      }
    });
  });

  group('ScoringEngine', () {
    test('correct answer adds points', () {
      final engine = ScoringEngine();
      final points = engine.evaluate('5', '5');
      expect(points, greaterThanOrEqualTo(10));
      expect(engine.correct, 1);
    });

    test('wrong answer subtracts points', () {
      final engine = ScoringEngine();
      engine.evaluate('5', '5');
      final points = engine.evaluate('3', '5');
      expect(points, lessThan(0));
      expect(engine.wrong, 1);
    });

    test('score never goes below zero', () {
      final engine = ScoringEngine();
      for (var i = 0; i < 10; i++) {
        engine.evaluate('1', '999');
      }
      expect(engine.score, greaterThanOrEqualTo(0));
    });

    test('accuracy is computed correctly', () {
      final engine = ScoringEngine();
      engine.evaluate('5', '5');
      engine.evaluate('3', '5');
      expect(engine.accuracy, 50.0);
    });
  });
}