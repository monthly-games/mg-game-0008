import 'package:shared_preferences/shared_preferences.dart';
import '../game/flappy_game.dart';

class HighScoreManager {
  static Future<bool> saveHighScore(String modeName, int newScore) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'highscore_$modeName';
    final currentHighScore = prefs.getInt(key) ?? 0;

    if (newScore > currentHighScore) {
      await prefs.setInt(key, newScore);
      return true;
    }
    return false;
  }

  static Future<int> getHighScore(String modeName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'highscore_$modeName';
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> resetAllHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final keyNormal = 'highscore_${FlappyGameMode.normal.name}';
    final keyHard = 'highscore_${FlappyGameMode.hard.name}';
    await prefs.remove(keyNormal);
    await prefs.remove(keyHard);
  }
}
