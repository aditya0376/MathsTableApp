import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../theme/app_theme.dart';

/// Settings screen: theme selection and sound toggle.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final theme in AppTheme.values)
            RadioListTile<AppTheme>(
              title: Text(theme.label),
              value: theme,
              groupValue: appState.theme,
              onChanged: (value) {
                if (value != null) appState.setTheme(value);
              },
            ),
          const Divider(height: 32),
          SwitchListTile(
            title: const Text('Sound effects'),
            subtitle: const Text('Enable correct/wrong sounds'),
            value: appState.soundEnabled,
            onChanged: appState.setSound,
          ),
        ],
      ),
    );
  }
}