import 'package:flutter/material.dart';

import 'practice_screen.dart';

/// Higher order maths: select a topic and start practice.
class HigherMathScreen extends StatefulWidget {
  const HigherMathScreen({super.key});

  @override
  State<HigherMathScreen> createState() => _HigherMathScreenState();
}

class _HigherMathScreenState extends State<HigherMathScreen> {
  String _topic = 'Fractions';
  int _timerSeconds = 120;

  static const _topics = [
    'Fractions',
    'Powers',
    'SquareRoots',
    'Percentages',
    'Algebra',
    'Averages',
  ];
  static const _timerOptions = [60, 120, 300, 600];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Higher Order Maths')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Select a topic',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final topic in _topics)
            RadioListTile<String>(
              title: Text(topic),
              value: topic,
              groupValue: _topic,
              onChanged: (v) => setState(() => _topic = v!),
            ),
          const SizedBox(height: 24),
          const Text('Timer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final t in _timerOptions)
                ChoiceChip(
                  label: Text(t >= 60 ? '${t ~/ 60} min' : '$t s'),
                  selected: _timerSeconds == t,
                  onSelected: (_) => setState(() => _timerSeconds = t),
                ),
            ],
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Practice'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PracticeScreen(
                  mode: 'Higher: $_topic',
                  higherTopic: _topic,
                  timerSeconds: _timerSeconds,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}