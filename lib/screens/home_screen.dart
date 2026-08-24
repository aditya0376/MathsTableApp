import 'package:flutter/material.dart';

import 'history_screen.dart';
import 'higher_math_screen.dart';
import 'practice_screen.dart';
import 'settings_screen.dart';
import 'table_practice_screen.dart';

/// Home screen: entry point with mode selection.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maths Tables Practice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Practice',
            subtitle: 'Addition, Subtraction, Multiplication, Division',
            icon: Icons.calculate,
            onTap: () => _openPractice(context),
          ),
          _SectionCard(
            title: 'Maths Table Rush',
            subtitle: 'Master tables with +, -, x, /',
            icon: Icons.grid_on,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TablePracticeScreen()),
            ),
          ),
          _SectionCard(
            title: 'Higher Order Maths',
            subtitle: 'Fractions, powers, algebra and more',
            icon: Icons.functions,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HigherMathScreen()),
            ),
          ),
        ],
      ),
    );
  }

  void _openPractice(BuildContext context) {
    // Simple mode picker dialog.
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final modes = [
          'Addition',
          'Subtraction',
          'Multiplication',
          'Division',
          'Combined',
        ];
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Choose an operation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final mode in modes)
                ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(mode),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(mode: mode),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: scheme.primaryContainer,
          child: Icon(icon, color: scheme.onPrimaryContainer, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}