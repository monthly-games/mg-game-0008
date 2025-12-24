import 'package:flutter/material.dart';
import 'ui/main_menu.dart';

import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/systems/progression/progression_manager.dart';
import 'package:mg_common_game/systems/progression/upgrade_manager.dart';
import 'package:mg_common_game/systems/progression/achievement_manager.dart';
import 'package:mg_common_game/systems/progression/prestige_manager.dart';
import 'package:mg_common_game/systems/quests/daily_quest.dart';
import 'package:mg_common_game/systems/quests/weekly_challenge.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/systems/settings/settings_manager.dart';
import 'package:mg_common_game/systems/stats/statistics_manager.dart';
import 'package:mg_common_game/core/systems/save_manager_helper.dart';
import 'game/skin_manager.dart';
import 'game/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDI();
  runApp(const FlappyBirdApp());
}

Future<void> _setupDI() async {
  // 1. Audio Manager
  if (!GetIt.I.isRegistered<AudioManager>()) {
    final audioManager = AudioManager();
    GetIt.I.registerSingleton<AudioManager>(audioManager);
    await audioManager.initialize();
  }

  // 2. Progression Manager
  if (!GetIt.I.isRegistered<ProgressionManager>()) {
    final progressionManager = ProgressionManager();
    GetIt.I.registerSingleton(progressionManager);

    progressionManager.onLevelUp = (newLevel) {
      if (GetIt.I.isRegistered<SettingsManager>()) {
        GetIt.I<SettingsManager>().triggerVibration(
          intensity: VibrationIntensity.heavy,
        );
      }
    };
  }

  // 3. Upgrade Manager
  if (!GetIt.I.isRegistered<UpgradeManager>()) {
    final upgradeManager = UpgradeManager();
    upgradeManager.registerUpgrade(
      Upgrade(
        id: 'flap_power',
        name: 'Flap Boost',
        description: 'Increases flap height by 5%',
        maxLevel: 10,
        baseCost: 200,
        costMultiplier: 1.5,
        valuePerLevel: 0.05,
      ),
    );

    upgradeManager.registerUpgrade(
      Upgrade(
        id: 'pipe_gap',
        name: 'Pipe Gap',
        description: 'Increases pipe gap slightly',
        maxLevel: 5,
        baseCost: 500,
        costMultiplier: 1.8,
        valuePerLevel: 0.02,
      ),
    );

    upgradeManager.registerUpgrade(
      Upgrade(
        id: 'score_multiplier',
        name: 'Score Boost',
        description: 'Increases score by 10%',
        maxLevel: 10,
        baseCost: 300,
        costMultiplier: 1.5,
        valuePerLevel: 0.1,
      ),
    );
    GetIt.I.registerSingleton(upgradeManager);
  }

  // 4. Achievement Manager
  if (!GetIt.I.isRegistered<AchievementManager>()) {
    final achievementManager = AchievementManager();
    achievementManager.registerAchievement(
      Achievement(
        id: 'first_10',
        title: 'First Flight',
        description: 'Score 10 points',
        iconAsset: 'assets/images/icon_bird.png',
      ),
    );
    achievementManager.registerAchievement(
      Achievement(
        id: 'flappy_50',
        title: 'Skilled Flyer',
        description: 'Score 50 points',
        iconAsset: 'assets/images/icon_star.png',
      ),
    );
    achievementManager.registerAchievement(
      Achievement(
        id: 'flappy_100',
        title: 'Master Flapper',
        description: 'Score 100 points',
        iconAsset: 'assets/images/icon_crown.png',
      ),
    );
    achievementManager.registerAchievement(
      Achievement(
        id: 'hard_mode_50',
        title: 'Hard Mode Hero',
        description: 'Score 50 in Hard Mode',
        iconAsset: 'assets/images/icon_flash.png',
      ),
    );

    achievementManager.onAchievementUnlocked = (achievement) {
      if (GetIt.I.isRegistered<SettingsManager>()) {
        GetIt.I<SettingsManager>().triggerVibration(
          intensity: VibrationIntensity.heavy,
        );
      }
    };

    GetIt.I.registerSingleton(achievementManager);
  }

  // 5. Prestige Manager
  if (!GetIt.I.isRegistered<PrestigeManager>()) {
    final prestigeManager = PrestigeManager();

    prestigeManager.registerPrestigeUpgrade(
      PrestigeUpgrade(
        id: 'prestige_xp_boost',
        name: 'XP Accelerator',
        description: '+20% XP gain per level',
        maxLevel: 10,
        costPerLevel: 1,
        bonusPerLevel: 0.2,
      ),
    );

    prestigeManager.registerPrestigeUpgrade(
      PrestigeUpgrade(
        id: 'prestige_gold_boost',
        name: 'Golden Wings',
        description: '+15% gold income per level',
        maxLevel: 10,
        costPerLevel: 1,
        bonusPerLevel: 0.15,
      ),
    );

    prestigeManager.registerPrestigeUpgrade(
      PrestigeUpgrade(
        id: 'prestige_flap_boost',
        name: 'Sky Master',
        description: '+5% flap power per level',
        maxLevel: 15,
        costPerLevel: 2,
        bonusPerLevel: 0.05,
      ),
    );

    GetIt.I.registerSingleton(prestigeManager);

    await prestigeManager.loadPrestigeData();
    GetIt.I<ProgressionManager>().setPrestigeManager(prestigeManager);
  }

  // 6. Daily Quest Manager
  if (!GetIt.I.isRegistered<DailyQuestManager>()) {
    final questManager = DailyQuestManager();

    questManager.registerQuest(
      DailyQuest(
        id: 'flappy_play_5',
        title: 'Daily Flapper',
        description: 'Play 5 games',
        targetValue: 5,
        goldReward: 100,
        xpReward: 50,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'flappy_score_50',
        title: 'Score Seeker',
        description: 'Score 50 total points',
        targetValue: 50,
        goldReward: 120,
        xpReward: 60,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'flappy_normal_30',
        title: 'Normal Navigator',
        description: 'Score 30 in Normal mode',
        targetValue: 30,
        goldReward: 150,
        xpReward: 75,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'flappy_hard_20',
        title: 'Hard Mode Survivor',
        description: 'Score 20 in Hard mode',
        targetValue: 20,
        goldReward: 200,
        xpReward: 100,
      ),
    );

    GetIt.I.registerSingleton(questManager);

    questManager.loadQuestData();
    questManager.checkAndResetIfNeeded();
  }

  // 7. Weekly Challenge Manager
  if (!GetIt.I.isRegistered<WeeklyChallengeManager>()) {
    final challengeManager = WeeklyChallengeManager();

    challengeManager.onChallengeCompleted = (challenge) {
      if (GetIt.I.isRegistered<SettingsManager>()) {
        GetIt.I<SettingsManager>().triggerVibration(
          intensity: VibrationIntensity.heavy,
        );
      }
    };

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_flappy_play_30',
        title: 'Frequent Flyer',
        description: 'Play 30 games',
        targetValue: 30,
        goldReward: 500,
        xpReward: 250,
        tier: ChallengeTier.bronze,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_flappy_score_500',
        title: 'Point Collector',
        description: 'Score 500 total points',
        targetValue: 500,
        goldReward: 750,
        xpReward: 400,
        tier: ChallengeTier.silver,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_flappy_normal_100',
        title: 'Normal Master',
        description: 'Score 100 in Normal mode',
        targetValue: 100,
        goldReward: 1000,
        xpReward: 500,
        tier: ChallengeTier.silver,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_flappy_hard_50',
        title: 'Hard Mode Champion',
        description: 'Score 50 in Hard mode',
        targetValue: 50,
        goldReward: 1500,
        xpReward: 800,
        prestigePointReward: 1,
        tier: ChallengeTier.gold,
      ),
    );

    challengeManager.registerChallenge(
      WeeklyChallenge(
        id: 'weekly_flappy_legend',
        title: 'Flappy Legend',
        description: 'Score 200 in any mode',
        targetValue: 200,
        goldReward: 2000,
        xpReward: 1000,
        prestigePointReward: 2,
        tier: ChallengeTier.platinum,
      ),
    );

    GetIt.I.registerSingleton(challengeManager);

    await challengeManager.loadChallengeData();
    await challengeManager.checkAndResetIfNeeded();
  }

  // 8. Gold Manager
  if (!GetIt.I.isRegistered<GoldManager>()) {
    GetIt.I.registerSingleton(GoldManager());
  }

  // 9. Settings Manager
  if (!GetIt.I.isRegistered<SettingsManager>()) {
    final settingsManager = SettingsManager();
    GetIt.I.registerSingleton(settingsManager);

    if (GetIt.I.isRegistered<AudioManager>()) {
      settingsManager.setAudioManager(GetIt.I<AudioManager>());
    }

    await settingsManager.loadSettings();
  }

  // 10. Statistics Manager
  if (!GetIt.I.isRegistered<StatisticsManager>()) {
    final statisticsManager = StatisticsManager();
    GetIt.I.registerSingleton(statisticsManager);

    await statisticsManager.loadStats();
    statisticsManager.startSession();
  }

  // 11. Save Manager
  await SaveManagerHelper.setupSaveManager(
    autoSaveEnabled: true,
    autoSaveIntervalSeconds: 30,
  );

  await SaveManagerHelper.legacyLoadAll();

  // 12. Skin Manager
  if (!GetIt.I.isRegistered<SkinManager>()) {
    final skinManager = SkinManager();
    await skinManager.load();
    GetIt.I.registerSingleton(skinManager);
  }

  // 13. Theme Manager
  if (!GetIt.I.isRegistered<ThemeManager>()) {
    final themeManager = ThemeManager();
    await themeManager.load();
    GetIt.I.registerSingleton(themeManager);
  }
}

class FlappyBirdApp extends StatelessWidget {
  const FlappyBirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF87CEEB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainMenu(),
    );
  }
}
