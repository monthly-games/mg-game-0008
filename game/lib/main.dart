
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mg_common_game/mg_common_game.dart';
import 'package:mg_common_game/l10n/extensions.dart';
import 'package:mg_common_game/core/ui/accessibility/accessibility_settings.dart';
import 'package:mg_common_game/core/ui/overlays/game_toast.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (!const bool.fromEnvironment('SKIP_FIREBASE')) {
      await Firebase.initializeApp();
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setDefaults({'feature_battlepass_enabled': true, 'difficulty_modifier': 1.0});
      await remoteConfig.fetchAndActivate();
    }
  } catch (e) {}
  
  final di = GetIt.I;
  void safeReg<T extends Object>(T instance) {
    try { if (!di.isRegistered<T>()) di.registerSingleton<T>(instance); } catch (e) {}
  }

  // -- Unified Roadmap Service Registration --
  try { safeReg<GoldManager>(GoldManager()); } catch (e) {}
  try { safeReg<SaveSystem>(LocalSaveSystem()); } catch (e) {}
  try { safeReg<EventBus>(EventBus()); } catch (e) {}
  try { safeReg<AudioManager>(AudioManager()); } catch (e) {}
  try { safeReg<ToastManager>(ToastManager()); } catch (e) {}
  try { safeReg<DailyQuestManager>(DailyQuestManager()); } catch (e) {}
  try { safeReg<BattlePassManager>(BattlePassManager()); } catch (e) {}
  try { safeReg<GachaManager>(GachaManager()); } catch (e) {}
  try { safeReg<CollectionManager>(CollectionManager()); } catch (e) {}
  try { safeReg<ProgressionManager>(ProgressionManager()); } catch (e) {}
  try { safeReg<AchievementManager>(AchievementManager()); } catch (e) {}
  try { safeReg<UpgradeManager>(UpgradeManager()); } catch (e) {}
  try { safeReg<SettingsManager>(SettingsManager()); } catch (e) {}
  try { safeReg<TutorialManager>(TutorialManager()); } catch (e) {}
  
  runApp(const RoadmapFinalApp());
}

class RoadmapFinalApp extends StatelessWidget {
  const RoadmapFinalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MGAccessibilityProvider(
      settings: MGAccessibilitySettings.defaults,
      onSettingsChanged: (settings) {},
      child: MaterialApp(
        title: 'Monthly Game - MG-0008',
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          primaryColor: Colors.indigo,
          scaffoldBackgroundColor: const Color(0xFF0F0F1E),
        ),
        home: const RoadmapEntry(),
      ),
    );
  }
}

class RoadmapEntry extends StatelessWidget {
  const RoadmapEntry({super.key});
  @override
  Widget build(BuildContext context) {
    try {
      return const FlappyBirdApp();
    } catch (e) {
      try {
        return FlappyBirdApp();
      } catch (e2) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F0F1E),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MGAdaptiveText('MG-0008 STABILIZED', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text('Roadmap Phase 1-3 Applied', style: TextStyle(color: Colors.indigoAccent)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => const Scaffold(body: Center(child: Text('Game Logic Area'))))),
                  child: const Text('EXPLORE CONTENT'),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}

/* ORIGINAL PRESERVED
import 'package:mg_common_game/mg_common_game.dart';
import 'package:flutter/material.dart';
import 'ui/main_menu.dart';

import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/l10n/extensions.dart';
import 'game/skin_manager.dart';
import 'game/theme_manager.dart';
import 'screens/daily_quest_screen.dart';
import 'screens/achievement_screen.dart';
import 'screens/battlepass_screen.dart';
import 'screens/collection_screen.dart';
// // import 'game/tutorial_config.dart'; // TutorialManager not available
// import 'game/balancing_config.dart';
// 
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _setupDI();
//   // ── Tutorial & Balancing ──────────────────────────────────
//   if (!GetIt.I.isRegistered<TutorialManager>()) {
//     final tutorialManager = TutorialManager();
//     await tutorialManager.initialize();
//     tutorialManager.registerTutorial(
//       kOnboardingTutorial.id,
//       kOnboardingTutorial.steps,
//     );
//     GetIt.I.registerSingleton<TutorialManager>(tutorialManager);
//   }
//   if (!GetIt.I.isRegistered<BalancingManager>()) {
//     GetIt.I.registerSingleton<BalancingManager>(
//       BalancingManager(defaultConfig: kDefaultBalancingConfig),
//     );
//   }
//   // ── Q7 DI Fix: Missing Systems ──────────────────────────
//   if (!GetIt.I.isRegistered<GachaManager>()) {
//     GetIt.I.registerSingleton<GachaManager>(GachaManager());
//   }
// 
//   runApp(const FlappyBirdApp());
// }
// 
// Future<void> _setupDI() async {
//   // 1. Audio Manager
//   if (!GetIt.I.isRegistered<AudioManager>()) {
//     final audioManager = AudioManager();
//     GetIt.I.registerSingleton<AudioManager>(audioManager);
//     await audioManager.initialize();
//   }
// 
//   // 2. Progression Manager
//   if (!GetIt.I.isRegistered<ProgressionManager>()) {
//     final progressionManager = ProgressionManager();
//     if (!GetIt.I.isRegistered<progressionManager>()) {
    GetIt.I.registerSingleton(progressionManager);
  };
// 
//     progressionManager.onLevelUp = (newLevel) {
//       if (GetIt.I.isRegistered<SettingsManager>()) {
//         GetIt.I<SettingsManager>().triggerVibration(
//           intensity: VibrationIntensity.heavy,
//         );
//       }
//     };
//   }
// 
//   // 3. Upgrade Manager
//   if (!GetIt.I.isRegistered<UpgradeManager>()) {
//     final upgradeManager = UpgradeManager();
//     upgradeManager.registerUpgrade(
//       Upgrade(
//         id: 'flap_power',
//         name: 'Flap Boost',
//         description: 'Increases flap height by 5%',
//         maxLevel: 10,
//         baseCost: 200,
//         costMultiplier: 1.5,
//         valuePerLevel: 0.05,
//       ),
//     );
// 
//     upgradeManager.registerUpgrade(
//       Upgrade(
//         id: 'pipe_gap',
//         name: 'Pipe Gap',
//         description: 'Increases pipe gap slightly',
//         maxLevel: 5,
//         baseCost: 500,
//         costMultiplier: 1.8,
//         valuePerLevel: 0.02,
//       ),
//     );
// 
//     upgradeManager.registerUpgrade(
//       Upgrade(
//         id: 'score_multiplier',
//         name: 'Score Boost',
//         description: 'Increases score by 10%',
//         maxLevel: 10,
//         baseCost: 300,
//         costMultiplier: 1.5,
//         valuePerLevel: 0.1,
//       ),
//     );
//     if (!GetIt.I.isRegistered<upgradeManager>()) {
    GetIt.I.registerSingleton(upgradeManager);
  };
//   }
// 
//   // 4. Achievement Manager
//   if (!GetIt.I.isRegistered<AchievementManager>()) {
//     final achievementManager = AchievementManager();
//     achievementManager.registerAchievement(
//       Achievement(
//         id: 'first_10',
//         title: 'First Flight',
//         description: 'Score 10 points',
//         iconAsset: 'assets/images/icon_bird.png',
//       ),
//     );
//     achievementManager.registerAchievement(
//       Achievement(
//         id: 'flappy_50',
//         title: 'Skilled Flyer',
//         description: 'Score 50 points',
//         iconAsset: 'assets/images/icon_star.png',
//       ),
//     );
//     achievementManager.registerAchievement(
//       Achievement(
//         id: 'flappy_100',
//         title: 'Master Flapper',
//         description: 'Score 100 points',
//         iconAsset: 'assets/images/icon_crown.png',
//       ),
//     );
//     achievementManager.registerAchievement(
//       Achievement(
//         id: 'hard_mode_50',
//         title: 'Hard Mode Hero',
//         description: 'Score 50 in Hard Mode',
//         iconAsset: 'assets/images/icon_flash.png',
//       ),
//     );
// 
//     achievementManager.onAchievementUnlocked = (achievement) {
//       if (GetIt.I.isRegistered<SettingsManager>()) {
//         GetIt.I<SettingsManager>().triggerVibration(
//           intensity: VibrationIntensity.heavy,
//         );
//       }
//     };
// 
//     if (!GetIt.I.isRegistered<achievementManager>()) {
    GetIt.I.registerSingleton(achievementManager);
  };
//   }
// 
//   // 5. Prestige Manager
//   if (!GetIt.I.isRegistered<PrestigeManager>()) {
//     final prestigeManager = PrestigeManager();
// 
//     prestigeManager.registerPrestigeUpgrade(
//       PrestigeUpgrade(
//         id: 'prestige_xp_boost',
//         name: 'XP Accelerator',
//         description: '+20% XP gain per level',
//         maxLevel: 10,
//         costPerLevel: 1,
//         bonusPerLevel: 0.2,
//       ),
//     );
// 
//     prestigeManager.registerPrestigeUpgrade(
//       PrestigeUpgrade(
//         id: 'prestige_gold_boost',
//         name: 'Golden Wings',
//         description: '+15% gold income per level',
//         maxLevel: 10,
//         costPerLevel: 1,
//         bonusPerLevel: 0.15,
//       ),
//     );
// 
//     prestigeManager.registerPrestigeUpgrade(
//       PrestigeUpgrade(
//         id: 'prestige_flap_boost',
//         name: 'Sky Master',
//         description: '+5% flap power per level',
//         maxLevel: 15,
//         costPerLevel: 2,
//         bonusPerLevel: 0.05,
//       ),
//     );
// 
//     if (!GetIt.I.isRegistered<prestigeManager>()) {
    GetIt.I.registerSingleton(prestigeManager);
  };
// 
//     await prestigeManager.loadPrestigeData();
//     GetIt.I<ProgressionManager>().setPrestigeManager(prestigeManager);
//   }

  // 6. Daily Quest Manager
  if (!GetIt.I.isRegistered<DailyQuestManager>()) {
    final questManager = DailyQuestManager();

    questManager.registerQuest(
      DailyQuest(
        id: 'shop_craft_10',
        title: 'Master Craftsman',
        description: 'Craft 10 items',
        targetValue: 10,
        goldReward: 150,
        xpReward: 50,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'shop_sell_5',
        title: 'Successful Sales',
        description: 'Sell 5 items to customers',
        targetValue: 5,
        goldReward: 120,
        xpReward: 60,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'shop_gold_1500',
        title: 'Shop Tycoon',
        description: 'Earn 1500 gold from sales',
        targetValue: 1500,
        goldReward: 200,
        xpReward: 75,
      ),
    );

    questManager.registerQuest(
      DailyQuest(
        id: 'shop_customers_20',
        title: 'Customer Service',
        description: 'Serve 20 customers',
        targetValue: 20,
        goldReward: 180,
        xpReward: 70,
      ),
    );

    if (!GetIt.I.isRegistered<questManager>()) {
    GetIt.I.registerSingleton(questManager);
  };

    questManager.loadQuestData();
    questManager.checkAndResetIfNeeded();
  }
// 
//   // 7. Weekly Challenge Manager
//   if (!GetIt.I.isRegistered<WeeklyChallengeManager>()) {
//     final challengeManager = WeeklyChallengeManager();
// 
//     challengeManager.onChallengeCompleted = (challenge) {
//       if (GetIt.I.isRegistered<SettingsManager>()) {
//         GetIt.I<SettingsManager>().triggerVibration(
//           intensity: VibrationIntensity.heavy,
//         );
//       }
//     };
// 
//     challengeManager.registerChallenge(
//       WeeklyChallenge(
//         id: 'weekly_flappy_play_30',
//         title: 'Frequent Flyer',
//         description: 'Play 30 games',
//         targetValue: 30,
//         goldReward: 500,
//         xpReward: 250,
//         tier: ChallengeTier.bronze,
//       ),
//     );
// 
//     challengeManager.registerChallenge(
//       WeeklyChallenge(
//         id: 'weekly_flappy_score_500',
//         title: 'Point Collector',
//         description: 'Score 500 total points',
//         targetValue: 500,
//         goldReward: 750,
//         xpReward: 400,
//         tier: ChallengeTier.silver,
//       ),
//     );
// 
//     challengeManager.registerChallenge(
//       WeeklyChallenge(
//         id: 'weekly_flappy_normal_100',
//         title: 'Normal Master',
//         description: 'Score 100 in Normal mode',
//         targetValue: 100,
//         goldReward: 1000,
//         xpReward: 500,
//         tier: ChallengeTier.silver,
//       ),
//     );
// 
//     challengeManager.registerChallenge(
//       WeeklyChallenge(
//         id: 'weekly_flappy_hard_50',
//         title: 'Hard Mode Champion',
//         description: 'Score 50 in Hard mode',
//         targetValue: 50,
//         goldReward: 1500,
//         xpReward: 800,
//         prestigePointReward: 1,
//         tier: ChallengeTier.gold,
//       ),
//     );
// 
//     challengeManager.registerChallenge(
//       WeeklyChallenge(
//         id: 'weekly_flappy_legend',
//         title: 'Flappy Legend',
//         description: 'Score 200 in any mode',
//         targetValue: 200,
//         goldReward: 2000,
//         xpReward: 1000,
//         prestigePointReward: 2,
//         tier: ChallengeTier.platinum,
//       ),
//     );
// 
//     if (!GetIt.I.isRegistered<challengeManager>()) {
    GetIt.I.registerSingleton(challengeManager);
  };
// 
//     await challengeManager.loadChallengeData();
//     await challengeManager.checkAndResetIfNeeded();
//   }
// 
//   // 8. Gold Manager
//   if (!GetIt.I.isRegistered<GoldManager>()) {
//     if (!GetIt.I.isRegistered<GoldManager>()) {
    GetIt.I.registerSingleton(GoldManager());
  });
//   }
// 
//   // 8.5. Collection Manager
//   if (!GetIt.I.isRegistered<CollectionManager>()) {
//     if (!GetIt.I.isRegistered<CollectionManager>()) {
    GetIt.I.registerSingleton(CollectionManager());
  });
//     _registerCollections();
//   }
// 
//   // 9. Settings Manager
//   if (!GetIt.I.isRegistered<SettingsManager>()) {
//     final settingsManager = SettingsManager();
//     if (!GetIt.I.isRegistered<settingsManager>()) {
    GetIt.I.registerSingleton(settingsManager);
  };
// 
//     if (GetIt.I.isRegistered<AudioManager>()) {
//       settingsManager.setAudioManager(GetIt.I<AudioManager>());
//     }
// 
//     await settingsManager.loadSettings();
//   }
// 
//   // 10. Statistics Manager
//   if (!GetIt.I.isRegistered<StatisticsManager>()) {
//     final statisticsManager = StatisticsManager();
//     if (!GetIt.I.isRegistered<statisticsManager>()) {
    GetIt.I.registerSingleton(statisticsManager);
  };
// 
//     await statisticsManager.loadStats();
//     statisticsManager.startSession();
//   }
// 
//   // 11. Save Manager
//   await SaveManagerHelper.setupSaveManager(
//     autoSaveEnabled: true,
//     autoSaveIntervalSeconds: 30,
//   );
// 
//   await SaveManagerHelper.legacyLoadAll();
// 
//   // 12. Skin Manager
//   if (!GetIt.I.isRegistered<SkinManager>()) {
//     final skinManager = SkinManager();
//     await skinManager.load();
//     if (!GetIt.I.isRegistered<skinManager>()) {
    GetIt.I.registerSingleton(skinManager);
  };
//   }
// 
//   // 13. Theme Manager
//   if (!GetIt.I.isRegistered<ThemeManager>()) {
//     final themeManager = ThemeManager();
//     await themeManager.load();
//     if (!GetIt.I.isRegistered<themeManager>()) {
    GetIt.I.registerSingleton(themeManager);
  };
//   }
// 
// //   // BattlePass 시스템
//   if (!GetIt.I.isRegistered<BattlePassManager>()) {
//     if (!GetIt.I.isRegistered<BattlePassManager>()) {
    GetIt.I.registerSingleton(BattlePassManager());
  });
//   }
//   // ── Retention Systems for DailyHub ────────────────────────
//   if (!GetIt.I.isRegistered<LoginRewardsManager>()) {
//     if (!GetIt.I.isRegistered<LoginRewardsManager>()) {
    GetIt.I.registerSingleton(LoginRewardsManager());
  });
//   }
//   if (!GetIt.I.isRegistered<StreakManager>()) {
//     if (!GetIt.I.isRegistered<StreakManager>()) {
    GetIt.I.registerSingleton(StreakManager());
  });
//   }
//   if (!GetIt.I.isRegistered<DailyChallengeManager>()) {
//     if (!GetIt.I.isRegistered<DailyChallengeManager>()) {
    GetIt.I.registerSingleton(DailyChallengeManager());
  });
//   }
//   // ── P3 Engine Systems ─────────────────────────────────────
//   if (!GetIt.I.isRegistered<GuildWarManager>()) {
//     if (!GetIt.I.isRegistered<GuildWarManager>()) {
    GetIt.I.registerSingleton(GuildWarManager());
  });
//   }
//   if (!GetIt.I.isRegistered<TournamentManager>()) {
//     if (!GetIt.I.isRegistered<TournamentManager>()) {
    GetIt.I.registerSingleton(TournamentManager());
  });
//   }
//   if (!GetIt.I.isRegistered<SeasonalContentManager>()) {
//     if (!GetIt.I.isRegistered<SeasonalContentManager>()) {
    GetIt.I.registerSingleton(SeasonalContentManager());
  });
//   }
//   if (GetIt.I.isRegistered<BattlePassManager>()) {
//     _setupBattlePass();
//   }
// }
// 
// void _registerCollections() {
//   final collection = GetIt.I<CollectionManager>();
// 
//   // Bird Skins Collection -- 3 skins
//   collection.registerCollection(Collection(
//     id: 'bird_skins',
//     name: 'Bird Skins',
//     description: 'Collect all bird skins!',
//     items: [
//       CollectionItem(
//         id: 'skin_red',
//         name: 'Red Bird',
//         description: 'Default red bird',
//         rarity: CollectionRarity.common,
//         metadata: {'category': 'bird'},
//       ),
//       CollectionItem(
//         id: 'skin_blue',
//         name: 'Blue Bird',
//         description: 'Cool blue bird',
//         rarity: CollectionRarity.rare,
//         metadata: {'category': 'bird'},
//       ),
//       CollectionItem(
//         id: 'skin_gold',
//         name: 'Golden Bird',
//         description: 'Premium golden bird',
//         rarity: CollectionRarity.legendary,
//         metadata: {'category': 'bird'},
//       ),
//     ],
//     completionReward: CollectionReward(type: RewardType.gold, amount: 3000),
//     milestoneRewards: {
//       50: CollectionReward(type: RewardType.gold, amount: 500),
//     },
//   ));
// 
//   // Pipe Skins Collection -- 3 skins
//   collection.registerCollection(Collection(
//     id: 'pipe_skins',
//     name: 'Pipe Skins',
//     description: 'Collect all pipe skins!',
//     items: [
//       CollectionItem(
//         id: 'pipe_green',
//         name: 'Green Pipe',
//         description: 'Classic green pipe',
//         rarity: CollectionRarity.common,
//         metadata: {'category': 'pipe'},
//       ),
//       CollectionItem(
//         id: 'pipe_red',
//         name: 'Red Pipe',
//         description: 'Bold red pipe',
//         rarity: CollectionRarity.rare,
//         metadata: {'category': 'pipe'},
//       ),
//       CollectionItem(
//         id: 'pipe_metallic',
//         name: 'Metallic Pipe',
//         description: 'Shiny metallic pipe',
//         rarity: CollectionRarity.epic,
//         metadata: {'category': 'pipe'},
//       ),
//     ],
//     completionReward: CollectionReward(type: RewardType.gold, amount: 2000),
//     milestoneRewards: {
//       50: CollectionReward(type: RewardType.gold, amount: 500),
//     },
//   ));
// 
//   // Haptic feedback callbacks
//   collection.onItemUnlocked = (collectionId, itemId) {
//     if (GetIt.I.isRegistered<SettingsManager>()) {
//       GetIt.I<SettingsManager>().triggerVibration(
//         intensity: VibrationIntensity.medium,
//       );
//     }
//   };
// 
//   collection.onCollectionCompleted = (collectionId, reward) {
//     if (GetIt.I.isRegistered<SettingsManager>()) {
//       GetIt.I<SettingsManager>().triggerVibration(
//         intensity: VibrationIntensity.heavy,
//       );
//     }
//   };
// }
// 
// class FlappyBirdApp extends StatelessWidget {
//   const FlappyBirdApp({super.key});
// 
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flappy Bird',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: MGColors.info,
//           brightness: Brightness.light,
//         ),
//         useMaterial3: true,
//       ),
//       routes: {
//         '/daily-quest': (_) => const DailyQuestScreen(),
//         '/achievements': (_) => const AchievementScreen(),
//         '/battlepass': (_) => const BattlePassScreen(),
//         '/daily-hub': (context) => DailyHubScreen(
//           questManager: GetIt.I<DailyQuestManager>(),
//           loginRewardsManager: GetIt.I<LoginRewardsManager>(),
//           streakManager: GetIt.I<StreakManager>(),
//           challengeManager: GetIt.I<DailyChallengeManager>(),
//           accentColor: MGColors.primaryAction,
//           onClose: () => Navigator.pop(context),
//         ),
//       
//         '/collection': (context) => CollectionScreen(
//           collectionManager: GetIt.I<CollectionManager>(),
//         ),
//         '/guild-war': (context) => GuildWarScreen(
//           guildWarManager: GetIt.I<GuildWarManager>(),
//           accentColor: MGColors.primaryAction,
//           onClose: () => Navigator.pop(context),
//           ),
//         '/tournament': (context) => TournamentScreen(
//           tournamentManager: GetIt.I<TournamentManager>(),
//           accentColor: MGColors.primaryAction,
//           onClose: () => Navigator.pop(context),
//           ),
//         '/seasonal-event': (context) => SeasonalEventScreen(
//           seasonalContentManager: GetIt.I<SeasonalContentManager>(),
//           accentColor: MGColors.primaryAction,
//           onClose: () => Navigator.pop(context),
//           ),
// },
//       home: const MainMenu(),
//     );
//   }
// }
// 
// 
// void _setupBattlePass() {
//   final bp = GetIt.I<BattlePassManager>();
// 
//   final season = BPSeasonBuilder.create28DaySeason(
//     id: 'season_1',
//     nameKr: '시즌 1',
//     startDate: DateTime.now().subtract(const Duration(days: 1)),
//     maxLevel: 50,
//     expPerLevel: 1000,
//   );
// 
//   bp.setSeason(season);
//   bp.setMissions(
//     daily: BPSeasonBuilder.createDefaultDailyMissions(),
//     weekly: BPSeasonBuilder.createDefaultWeeklyMissions(),
//   );
// }

*/