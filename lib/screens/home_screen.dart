import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/cartoon_character_view.dart';
import 'dashboard_screen.dart';
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
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(appState.hasKidName
            ? 'Hi, ${appState.kidName}!'
            : 'Maths Tables Practice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            tooltip: 'Performance Dashboard',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            ),
          ),
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
          if (!appState.hasKidName)
            _NamePromptCard(onSave: (name) => appState.setKidName(name)),
          if (appState.theme.isKidsTheme) const _CharacterBanner(),
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

class _CharacterBanner extends StatelessWidget {
  const _CharacterBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CartoonCharacterView(
                type: CartoonType.robot, size: 64, primaryColor: scheme.primary),
            const CartoonCharacterView(
                type: CartoonType.sun, size: 64, primaryColor: Colors.amber),
            const CartoonCharacterView(
                type: CartoonType.cat, size: 64, primaryColor: Colors.brown),
            const CartoonCharacterView(
                type: CartoonType.rocket, size: 64, primaryColor: Colors.green),
          ],
        ),
      ),
    );
  }
}

class _NamePromptCard extends StatefulWidget {
  final ValueChanged<String> onSave;
  const _NamePromptCard({required this.onSave});

  @override
  State<_NamePromptCard> createState() => _NamePromptCardState();
}

class _NamePromptCardState extends State<_NamePromptCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome! What is your name?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  widget.onSave(_controller.text);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
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