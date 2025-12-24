import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BirdSkin {
  red,
  blue,
  gold;

  String get name {
    switch (this) {
      case BirdSkin.red:
        return 'Red Bird';
      case BirdSkin.blue:
        return 'Blue Bird';
      case BirdSkin.gold:
        return 'Golden Bird';
    }
  }

  int get cost {
    switch (this) {
      case BirdSkin.red:
        return 0; // Default
      case BirdSkin.blue:
        return 500;
      case BirdSkin.gold:
        return 1000;
    }
  }

  // Assuming sprite sheet layout: 3 rows, 3 frames per row. 32x32 size.
  // srcPosition will be calculated based on index.
  int get rowIndex => index;
}

enum PipeSkin {
  green,
  red,
  metallic;

  String get name {
    switch (this) {
      case PipeSkin.green:
        return 'Green Pipe';
      case PipeSkin.red:
        return 'Red Pipe';
      case PipeSkin.metallic:
        return 'Metallic Pipe';
    }
  }

  int get cost {
    switch (this) {
      case PipeSkin.green:
        return 0;
      case PipeSkin.red:
        return 500;
      case PipeSkin.metallic:
        return 800;
    }
  }

  // Assuming sprite sheet layout: 3 columns.
  int get colIndex => index;
}

class SkinManager extends ChangeNotifier {
  static const String _birdSkinKey = 'bird_skin';
  static const String _pipeSkinKey = 'pipe_skin';
  static const String _unlockedBirdsKey = 'unlocked_birds';
  static const String _unlockedPipesKey = 'unlocked_pipes';

  BirdSkin _currentBirdSkin = BirdSkin.red;
  PipeSkin _currentPipeSkin = PipeSkin.green;

  final Set<BirdSkin> _unlockedBirds = {BirdSkin.red};
  final Set<PipeSkin> _unlockedPipes = {PipeSkin.green};

  BirdSkin get currentBirdSkin => _currentBirdSkin;
  PipeSkin get currentPipeSkin => _currentPipeSkin;

  bool isBirdUnlocked(BirdSkin skin) => _unlockedBirds.contains(skin);
  bool isPipeUnlocked(PipeSkin skin) => _unlockedPipes.contains(skin);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Current Selection
    final birdIndex = prefs.getInt(_birdSkinKey) ?? 0;
    final pipeIndex = prefs.getInt(_pipeSkinKey) ?? 0;
    _currentBirdSkin =
        BirdSkin.values[birdIndex.clamp(0, BirdSkin.values.length - 1)];
    _currentPipeSkin =
        PipeSkin.values[pipeIndex.clamp(0, PipeSkin.values.length - 1)];

    // Load Unlocks
    final unlockedBirdsList = prefs.getStringList(_unlockedBirdsKey);
    if (unlockedBirdsList != null) {
      _unlockedBirds.clear();
      for (final indexStr in unlockedBirdsList) {
        final index = int.tryParse(indexStr) ?? 0;
        _unlockedBirds.add(
          BirdSkin.values[index.clamp(0, BirdSkin.values.length - 1)],
        );
      }
    } else {
      _unlockedBirds.add(BirdSkin.red);
    }

    final unlockedPipesList = prefs.getStringList(_unlockedPipesKey);
    if (unlockedPipesList != null) {
      _unlockedPipes.clear();
      for (final indexStr in unlockedPipesList) {
        final index = int.tryParse(indexStr) ?? 0;
        _unlockedPipes.add(
          PipeSkin.values[index.clamp(0, PipeSkin.values.length - 1)],
        );
      }
    } else {
      _unlockedPipes.add(PipeSkin.green);
    }

    notifyListeners();
  }

  Future<void> setBirdSkin(BirdSkin skin) async {
    if (!isBirdUnlocked(skin)) return;
    _currentBirdSkin = skin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_birdSkinKey, skin.index);
    notifyListeners();
  }

  Future<void> setPipeSkin(PipeSkin skin) async {
    if (!isPipeUnlocked(skin)) return;
    _currentPipeSkin = skin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pipeSkinKey, skin.index);
    notifyListeners();
  }

  Future<void> unlockBirdSkin(BirdSkin skin) async {
    if (_unlockedBirds.contains(skin)) return;
    _unlockedBirds.add(skin);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _unlockedBirdsKey,
      _unlockedBirds.map((e) => e.index.toString()).toList(),
    );
    notifyListeners();
  }

  Future<void> unlockPipeSkin(PipeSkin skin) async {
    if (_unlockedPipes.contains(skin)) return;
    _unlockedPipes.add(skin);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _unlockedPipesKey,
      _unlockedPipes.map((e) => e.index.toString()).toList(),
    );
    notifyListeners();
  }
}
