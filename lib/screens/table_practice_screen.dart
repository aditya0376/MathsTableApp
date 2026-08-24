import 'package:flutter/material.dart';

import 'practice_screen.dart';

/// Table practice: select one or more tables and a mode, then start practice.
class TablePracticeScreen extends StatefulWidget {
  const TablePracticeScreen({super.key});

  @override
  State<TablePracticeScreen> createState() => _TablePracticeScreenState();
}

class _TablePracticeScreenState extends State<TablePracticeScreen> {
  final Set<int> _selectedTables = {7};
  String _mode = 'Random';
  int _timerSeconds = 60;

  static const _modes = ['Sequential', 'Random', 'Reverse', 'FillBlank'];
  static const _timerOptions = [30, 60, 120, 300, 600];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Table Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Select tables (one or more)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var t = 1; t <= 10; t++)
                FilterChip(
                  label: Text('$t'),
                  selected: _selectedTables.contains(t),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _selectedTables.add(t);
                    } else {
                      _selectedTables.remove(t);
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
                  _selectedTables.addAll(List.generate(10, (i) => i + 1));
                }),
                child: const Text('Select all'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _selectedTables.clear();
                }),
                child: const Text('Clear'),
              ),
            ],
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
            onPressed: _selectedTables.isEmpty
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(
                          mode: 'Table Practice',
                          tables: _selectedTables.toList(),
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