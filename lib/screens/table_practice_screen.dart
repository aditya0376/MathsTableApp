import 'package:flutter/material.dart';

import 'practice_screen.dart';

/// Maths Table Rush: select numbers, operations, mode, and timer, then start.
class TablePracticeScreen extends StatefulWidget {
  const TablePracticeScreen({super.key});

  @override
  State<TablePracticeScreen> createState() => _TablePracticeScreenState();
}

class _TablePracticeScreenState extends State<TablePracticeScreen> {
  final Set<int> _selectedNumbers = {7};
  final Set<String> _selectedOperations = {'x'};
  String _mode = 'Random';
  int _timerSeconds = 60;

  static const _modes = ['Sequential', 'Random', 'Reverse', 'FillBlank'];
  static const _operations = ['+', '-', 'x', '/'];
  static const _timerOptions = [30, 60, 120, 300, 600];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maths Table Rush')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Select numbers (one or more)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var t = 1; t <= 10; t++)
                FilterChip(
                  label: Text('$t'),
                  selected: _selectedNumbers.contains(t),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _selectedNumbers.add(t);
                    } else {
                      _selectedNumbers.remove(t);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _selectedNumbers.addAll(List.generate(10, (i) => i + 1));
                }),
                child: const Text('Select all'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _selectedNumbers.clear();
                }),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Operations (one or more)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final op in _operations)
                FilterChip(
                  label: Text(op,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  selected: _selectedOperations.contains(op),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _selectedOperations.add(op);
                    } else {
                      _selectedOperations.remove(op);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {
              _selectedOperations.addAll(_operations);
            }),
            child: const Text('Select all operations'),
          ),
          const SizedBox(height: 16),
          const Text('Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final m in _modes)
            RadioListTile<String>(
              title: Text(m),
              value: m,
              groupValue: _mode,
              onChanged: (v) => setState(() => _mode = v!),
            ),
          if (_mode == 'Random')
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                'Random mixes all selected operations for a tougher challenge.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
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
            label: const Text('Start Rush'),
            onPressed: _selectedNumbers.isEmpty || _selectedOperations.isEmpty
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(
                          mode: 'Maths Table Rush',
                          tables: _selectedNumbers.toList(),
                          operations: _selectedOperations.toList(),
                          tableMode: _mode,
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