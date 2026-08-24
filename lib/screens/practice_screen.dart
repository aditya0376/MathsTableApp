import 'dart:async';
import 'dart:math';

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
  final List<int>? tables; // for table practice (one or more tables)
  final List<String>? operations; // for table rush (+, -, x, /)
  final String? tableMode; // Sequential/Random/Reverse/FillBlank
  final String? higherTopic; // for higher order maths

  const PracticeScreen({
    super.key,
    required this.mode,
    this.difficulty = 'Easy',
    this.timerSeconds,
    this.tables,
    this.operations,
    this.tableMode,
    this.higherTopic,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final ScoringEngine _engine = ScoringEngine();
  final TextEditingController _answerController = TextEditingController();
  final Random _rng = Random();

  Problem? _current;
  Timer? _timer;
  int _timeLeft = 0;
  bool _finished = false;
  int _startTime = 0;
  String? _encouragement;
  Timer? _encouragementTimer;

  static const _encouragements = [
    'Wow!',
    'Superb!',
    'Genius!',
    'Mind blowing!',
    'Amazing!',
    'Outstanding!',
    'Brilliant!',
    'Incredible!',
  ];

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
    _encouragementTimer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _nextProblem() {
    setState(() {
      if (widget.tables != null && widget.tables!.isNotEmpty) {
        // Pick a random table from the selected list.
        final table = widget.tables![_rng.nextInt(widget.tables!.length)];
        // Pick an operation. In Random mode, mix all selected operations.
        final ops = widget.operations ?? const ['x'];
        final op = (widget.tableMode == 'Random' && ops.length > 1)
            ? ops[_rng.nextInt(ops.length)]
            : ops.first;
        _current = ProblemGenerator.tableRushProblem(
          table,
          op,
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
    final wasCorrect = _engine.evaluate(answer, _current!.answer) >= 0;
    if (wasCorrect && _engine.score > 50) {
      _showEncouragement();
    }
    _nextProblem();
  }

  void _showEncouragement() {
    _encouragementTimer?.cancel();
    setState(() {
      _encouragement = _encouragements[_rng.nextInt(_encouragements.length)];
    });
    _encouragementTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _encouragement = null);
    });
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
        child: Stack(
          children: [
            Column(
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
            if (_encouragement != null) _buildEncouragement(scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildEncouragement(ColorScheme scheme) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration, size: 90, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                _encouragement!,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 8),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Score: ${_engine.score}',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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