import 'package:flutter/material.dart';
import '../../utils/high_score_manager.dart';
import '../../utils/mock_leaderboard.dart';
import '../game/flappy_game.dart'; // For FlappyGameMode enum
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';

class CustomLeaderboardScreen extends StatefulWidget {
  const CustomLeaderboardScreen({super.key});

  @override
  State<CustomLeaderboardScreen> createState() =>
      _CustomLeaderboardScreenState();
}

class _CustomLeaderboardScreenState extends State<CustomLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Cache scores
  List<LeaderboardEntry> _normalScores = [];
  List<LeaderboardEntry> _hardScores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadScores();
  }

  Future<void> _loadScores() async {
    final normalBest = await HighScoreManager.getHighScore(
      FlappyGameMode.normal.name,
    );
    final hardBest = await HighScoreManager.getHighScore(
      FlappyGameMode.hard.name,
    );

    if (mounted) {
      setState(() {
        _normalScores = MockLeaderboard.generate(normalBest, 'normal');
        _hardScores = MockLeaderboard.generate(hardBest, 'hard');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MGColors.info,
      appBar: AppBar(
        title: const Text(
          'Leaderboards',
          style: TextStyle(color: MGColors.textHighEmphasis, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: MGColors.textHighEmphasis),
        bottom: TabBar(
          controller: _tabController,
          labelColor: MGColors.textHighEmphasis,
          unselectedLabelColor: MGColors.textMediumEmphasis,
          indicatorColor: MGColors.gold,
          tabs: const [
            Tab(text: 'Normal Mode', icon: Icon(Icons.play_arrow)),
            Tab(text: 'Hard Mode', icon: Icon(Icons.flash_on)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: MGColors.textHighEmphasis))
          : TabBarView(
              controller: _tabController,
              children: [_buildList(_normalScores), _buildList(_hardScores)],
            ),
    );
  }

  Widget _buildList(List<LeaderboardEntry> entries) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MGColors.textHighEmphasis,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: MGColors.backgroundDark.withValues(alpha: 0.26), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final rank = index + 1;

          // Highlight
          final isPlayer = entry.isPlayer;
          final color = isPlayer
              ? MGColors.gold.withValues(alpha: 0.2)
              : Colors.transparent;

          // Rank Color
          Color rankColor = MGColors.common;
          if (rank == 1) rankColor = MGColors.gold;
          if (rank == 2) rankColor = MGColors.common; // Silverish
          if (rank == 3) rankColor = MGColors.warning; // Bronze

          return Container(
            color: color,
            child: ListTile(
              leading: SizedBox(
                width: 40,
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              title: Text(
                entry.name,
                style: TextStyle(
                  fontWeight: isPlayer ? FontWeight.bold : FontWeight.normal,
                  color: isPlayer ? MGColors.info : MGColors.backgroundDark.withValues(alpha: 0.87),
                ),
              ),
              trailing: Text(
                '${entry.score}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
