import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// App-wide state: current theme, kid's name, and persisted settings.
class AppState extends ChangeNotifier {
  AppTheme _theme = AppTheme.light;
  bool _soundEnabled = true;
  String _kidName = '';

  AppTheme get theme => _theme;
  bool get soundEnabled => _soundEnabled;
  String get kidName => _kidName;
  bool get hasKidName => _kidName.trim().isNotEmpty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('theme') ?? AppTheme.light.name;
    _theme = AppTheme.values.firstWhere(
      (t) => t.name == themeName,
      orElse: () => AppTheme.light,
    );
    _soundEnabled = prefs.getBool('sound') ?? true;
    _kidName = prefs.getString('kidName') ?? '';
    notifyListeners();
  }

  Future<void> setTheme(AppTheme theme) async {
    _theme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme.name);
  }

  Future<void> setSound(bool enabled) async {
    _soundEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', enabled);
  }

  Future<void> setKidName(String name) async {
    _kidName = name.trim();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kidName', _kidName);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.load();
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const MathsTablesApp(),
    ),
  );
}

class MathsTablesApp extends StatelessWidget {
  const MathsTablesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return MaterialApp(
      title: 'Maths Tables Practice',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(appState.theme),
      home: const HomeScreen(),
    );
  }
}