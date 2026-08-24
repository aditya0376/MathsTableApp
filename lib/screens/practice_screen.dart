import 'dart:async';

import 'package:flutter/material.dart';

import '../models/session.dart';
import '../utils/problem_generator.dart';
import '../utils/scoring_engine.dart';
import 'results_screen.dart';

/// Practice screen with on-screen number pad, timer, and live scoring.
class PracticeScreen extends StatefulWidget {
  final String mode;
  final String difficulty;
  final int? timerSeconds; // null = no timer
  final int? table; // for table practice
  final String? tableMode; // Sequential/Random/Reverse/FillBlank
  final String? higherTopic; // for higher order maths

  const PracticeScreen({
    super.key,
    required this.mode,
    this.difficulty = 'Easy',
    this.timerSeconds,
    this.table,
    this.tableMode,
    this.higherTopic,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final ScoringEngine _engine = ScoringEngine();
  final TextEditingController _answerController = TextEditingController();

  Problem? _current;
  Timer? _timer;
  int _timeLeft = 0;
  bool _finished = false;
  int _startTime = 0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _nextProblem();
    if (widget.timerSeconds != null) {
      _timeLeft = widget.timerSeconds!;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          }
          if (_timeLeft == 0) {
            _finish();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _nextProblem() {
    setState(() {
      if (widget.table != null) {
        _current = ProblemGenerator.tableProblem(
          widget.table!,
          widget.tableMode ?? 'Random',
        );
      } else if (widget.higherTopic != null) {
        _current = ProblemGenerator.higherMath(widget.higherTopic!);
      } else {
        _current = ProblemGenerator.generate(widget.mode, widget.difficulty);
      }
      _answerController.clear();
    });
  }

  void _submit() {
    if (_current == null || _finished) return;
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;
    _engine.evaluate(answer, _current!.answer);
    _nextProblem();
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();
    final elapsed =
        (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000;
    final session = Session(
      date: DateTime.now(),
      mode: widget.mode,
      difficulty: widget.difficulty,
      score: _engine.score,
      accuracy: _engine.accuracy,
      totalProblems: _engine.total,
      correct: _engine.correct,
      wrong: _engine.wrong,
      durationSeconds: elapsed,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultsScreen(session: session)),
    );
  }

  void _appendDigit(String d) {
    if (_finished) return;
    setState(() {
      _answerController.text += d;
    });
  }

  void _deleteDigit() {
    if (_finished) return;
    setState(() {
      if (_answerController.text.isNotEmpty) {
        _answerController.text = _answerController.text
            .substring(0, _answerController.text.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Finish session',
            onPressed: _finish,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(scheme),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _current?.question ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _answerController,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Answer',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildNumberPad(scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatChip(
            icon: Icons.stars,
            label: '${_engine.score}',
            color: scheme.primary,
          ),
          if (widget.timerSeconds != null)
            _StatChip(
              icon: Icons.timer,
              label: '$_timeLeft s',
              color: _timeLeft <= 10 ? Colors.red : scheme.primary,
            ),
          _StatChip(
            icon: Icons.local_fire_department,
            label: '${_engine.streak}',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(ColorScheme scheme) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['DEL', '0', 'ENT'],
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final row in rows)
            Row(
              children: [
                for (final key in row)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: _padButton(key, scheme),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _padButton(String key, ColorScheme scheme) {
    final isDel = key == 'DEL';
    final isEnt = key == 'ENT';
    final Color bg;
    final Color fg;
    if (isEnt) {
      bg = scheme.primary;
      fg = scheme.onPrimary;
    } else if (isDel) {
      bg = scheme.errorContainer;
      fg = scheme.onErrorContainer;
    } else {
      bg = scheme.surfaceContainerHighest;
      fg = scheme.onSurface;
    }
    return SizedBox(
      height: 60,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          if (isDel) {
            _deleteDigit();
          } else if (isEnt) {
            _submit();
          } else {
            _appendDigit(key);
          }
        },
        child: Text(
          key,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}