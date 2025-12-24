import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';
import '../game/flappy_game.dart';
import 'tutorial_overlay.dart';
import 'pause_overlay.dart';
import '../utils/high_score_manager.dart';
import 'shop_screen.dart';
import 'game_over_overlay.dart';
import 'leaderboard_screen.dart';
import 'package:mg_common_game/systems/progression/prestige_manager.dart';
import 'package:mg_common_game/systems/progression/progression_manager.dart';
import 'package:mg_common_game/core/ui/screens/prestige_screen.dart';
import 'package:mg_common_game/systems/quests/daily_quest.dart';
import 'package:mg_common_game/core/ui/screens/daily_quest_screen.dart';
import 'package:mg_common_game/systems/quests/weekly_challenge.dart';
import 'package:mg_common_game/core/ui/screens/weekly_challenge_screen.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/systems/stats/statistics_manager.dart';
import 'package:mg_common_game/core/ui/screens/statistics_screen.dart';
import 'package:mg_common_game/systems/progression/achievement_manager.dart';
import 'package:mg_common_game/systems/settings/settings_manager.dart';
import 'package:mg_common_game/core/ui/screens/settings_screen.dart' as common;
import 'hud/mg_flappy_hud.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky Blue
              Color(0xFF4A90E2), // Darker Blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Game Title
                        const Text(
                          'FLAPPY',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(4, 4),
                                blurRadius: 8,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'BIRD',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                            shadows: [
                              Shadow(
                                offset: Offset(4, 4),
                                blurRadius: 8,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),

                        const Text(
                          'SELECT MODE',
                          style: TextStyle(
                            color: Colors.white70,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Game Mode Cards
                        GameModeCard(
                          title: 'NORMAL MODE',
                          description: 'Classic pipe dodging action!',
                          icon: Icons.play_arrow,
                          color: Colors.green,
                          onTap: () =>
                              _startGame(context, FlappyGameMode.normal),
                          highScoreFuture: HighScoreManager.getHighScore(
                            FlappyGameMode.normal.name,
                          ),
                        ),
                        GameModeCard(
                          title: 'HARD MODE',
                          description: 'Narrower gaps, faster speed!',
                          icon: Icons.flash_on,
                          color: Colors.red,
                          onTap: () => _startGame(context, FlappyGameMode.hard),
                          highScoreFuture: HighScoreManager.getHighScore(
                            FlappyGameMode.hard.name,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Utilities Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // First row: Game utilities
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUtilityButton(
                          context,
                          Icons.emoji_events,
                          'Leaderboard',
                          () => _showLeaderboard(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.shopping_cart,
                          'Shop',
                          () => _showShopScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.stars,
                          'Weekly',
                          () => _showWeeklyChallengesScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.auto_awesome,
                          'Prestige',
                          () => _showPrestigeScreen(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Second row: Settings and stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUtilityButton(
                          context,
                          Icons.bar_chart,
                          'Stats',
                          () => _showStatisticsScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.assignment_turned_in,
                          'Daily',
                          () => _showDailyQuestsScreen(context),
                        ),
                        _buildUtilityButton(
                          context,
                          Icons.settings,
                          'Settings',
                          () => _showSettingsScreen(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUtilityButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white, size: 32),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _startGame(BuildContext context, FlappyGameMode mode) async {
    final hasSeenTutorial = await TutorialOverlay.hasSeenTutorial();

    if (!context.mounted) return;

    if (!hasSeenTutorial) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameScreen(showTutorial: true, mode: mode),
        ),
      );
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameScreen(showTutorial: false, mode: mode),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CustomLeaderboardScreen()),
    );
  }

  void _showShopScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ShopScreen()));
  }

  void _showPrestigeScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PrestigeScreen(
          prestigeManager: GetIt.I<PrestigeManager>(),
          progressionManager: GetIt.I<ProgressionManager>(),
          title: 'Flappy Bird Prestige',
          accentColor: const Color(0xFF87CEEB),
          onClose: () => Navigator.of(context).pop(),
          onPrestige: () => _performPrestige(context),
        ),
      ),
    );
  }

  void _performPrestige(BuildContext context) {
    final prestigeManager = GetIt.I<PrestigeManager>();
    final progressionManager = GetIt.I<ProgressionManager>();

    final pointsGained = prestigeManager.performPrestige(
      progressionManager.currentLevel,
    );

    progressionManager.reset();

    final goldManager = GetIt.I<GoldManager>();
    goldManager.trySpendGold(goldManager.currentGold);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Prestige successful! Gained $pointsGained prestige points!',
        ),
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() {});
  }

  void _showDailyQuestsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DailyQuestScreen(
          questManager: GetIt.I<DailyQuestManager>(),
          title: 'Daily Quests',
          accentColor: const Color(0xFF87CEEB),
          onClaimReward: (questId, goldReward, xpReward) {
            final goldManager = GetIt.I<GoldManager>();
            final progressionManager = GetIt.I<ProgressionManager>();

            goldManager.addGold(goldReward);
            progressionManager.addXp(xpReward);
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showWeeklyChallengesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WeeklyChallengeScreen(
          challengeManager: GetIt.I<WeeklyChallengeManager>(),
          title: 'Weekly Challenges',
          accentColor: Colors.amber,
          onClaimReward: (challengeId, goldReward, xpReward, prestigeReward) {
            final goldManager = GetIt.I<GoldManager>();
            final progressionManager = GetIt.I<ProgressionManager>();
            final prestigeManager = GetIt.I<PrestigeManager>();

            goldManager.addGold(goldReward);
            progressionManager.addXp(xpReward);
            if (prestigeReward > 0) {
              prestigeManager.addPrestigePoints(prestigeReward);
            }
          },
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showStatisticsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(
          statisticsManager: GetIt.I<StatisticsManager>(),
          progressionManager: GetIt.I<ProgressionManager>(),
          prestigeManager: GetIt.I<PrestigeManager>(),
          questManager: GetIt.I<DailyQuestManager>(),
          achievementManager: GetIt.I<AchievementManager>(),
          title: 'Statistics',
          accentColor: const Color(0xFF87CEEB),
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showSettingsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => common.SettingsScreen(
          settingsManager: GetIt.I<SettingsManager>(),
          title: 'Settings',
          accentColor: const Color(0xFF87CEEB),
          onClose: () => Navigator.of(context).pop(),
          version: '1.0.0',
        ),
      ),
    );
  }
}

class GameModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Future<int>? highScoreFuture;

  const GameModeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.highScoreFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // High Score
                if (highScoreFuture != null)
                  FutureBuilder<int>(
                    future: highScoreFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data! > 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                size: 16,
                                color: Colors.orange,
                              ),
                              Text(
                                '${snapshot.data}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final bool showTutorial;
  final FlappyGameMode mode;

  const GameScreen({super.key, required this.showTutorial, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FlappyGame _game;
  bool _showTutorial = false;
  bool _showPause = false;
  bool _showGameOver = false;
  int _bestScore = 0;

  @override
  void initState() {
    super.initState();
    _game = FlappyGame(mode: widget.mode, onGameOver: _handleGameOver);
    _showTutorial = widget.showTutorial;
  }

  void _handleGameOver() async {
    final best = await HighScoreManager.getHighScore(widget.mode.name);
    setState(() {
      _bestScore = best;
      _showGameOver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),

          // MG Flappy HUD Overlay (only during active gameplay)
          if (!_showTutorial && !_showPause && !_showGameOver)
            StreamBuilder<int>(
              stream: GetIt.I<GoldManager>().onGoldChanged,
              initialData: GetIt.I<GoldManager>().currentGold,
              builder: (context, snapshot) {
                return MGFlappyHud(
                  score: _game.score,
                  highScore: _bestScore,
                  coins: snapshot.data ?? 0,
                  isPaused: false,
                  onPause: () {
                    _game.togglePause();
                    setState(() => _showPause = true);
                  },
                  onResume: null,
                );
              },
            ),

          // 일시정지 오버레이
          if (_showPause)
            PauseOverlay(
              onResume: () {
                _game.resume();
                setState(() => _showPause = false);
              },
              onRestart: () {
                _game.restart();
                setState(() => _showPause = false);
              },
              onMainMenu: () {
                Navigator.of(context).pop();
              },
            ),

          // 튜토리얼 오버레이
          if (_showTutorial)
            TutorialOverlay(
              onComplete: () {
                setState(() => _showTutorial = false);
              },
            ),

          // Game Over Overlay
          if (_showGameOver)
            GameOverOverlay(
              score: _game.score,
              bestScore: _bestScore,
              onRestart: () {
                _game.restart();
                setState(() => _showGameOver = false);
              },
              onMainMenu: () {
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
