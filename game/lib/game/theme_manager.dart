import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameTheme {
  day,
  night;

  String get name {
    switch (this) {
      case GameTheme.day:
        return 'Day Theme';
      case GameTheme.night:
        return 'Night Theme';
    }
  }

  int get cost {
    switch (this) {
      case GameTheme.day:
        return 0;
      case GameTheme.night:
        return 1000;
    }
  }
}

class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'game_theme';
  static const String _unlockedThemesKey = 'unlocked_themes';

  GameTheme _currentTheme = GameTheme.day;
  final Set<GameTheme> _unlockedThemes = {GameTheme.day};

  GameTheme get currentTheme => _currentTheme;
  bool isThemeUnlocked(GameTheme theme) => _unlockedThemes.contains(theme);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Current
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _currentTheme =
        GameTheme.values[themeIndex.clamp(0, GameTheme.values.length - 1)];

    // Load Unlocks
    final unlockedList = prefs.getStringList(_unlockedThemesKey);
    if (unlockedList != null) {
      _unlockedThemes.clear();
      for (final indexStr in unlockedList) {
        final index = int.tryParse(indexStr) ?? 0;
        _unlockedThemes.add(
          GameTheme.values[index.clamp(0, GameTheme.values.length - 1)],
        );
      }
    } else {
      _unlockedThemes.add(GameTheme.day);
    }

    notifyListeners();
  }

  Future<void> setTheme(GameTheme theme) async {
    if (!isThemeUnlocked(theme)) return;
    _currentTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
    notifyListeners();
  }

  Future<void> unlockTheme(GameTheme theme) async {
    if (_unlockedThemes.contains(theme)) return;
    _unlockedThemes.add(theme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _unlockedThemesKey,
      _unlockedThemes.map((e) => e.index.toString()).toList(),
    );
    notifyListeners();
  }
}
