import 'dart:math';

class LeaderboardEntry {
  final String name;
  final int score;
  final bool isPlayer;

  LeaderboardEntry({
    required this.name,
    required this.score,
    this.isPlayer = false,
  });
}

class MockLeaderboard {
  static List<LeaderboardEntry> generate(int playerScore, String mode) {
    final List<LeaderboardEntry> entries = [];
    final random = Random();

    // Add Player
    entries.add(
      LeaderboardEntry(name: 'YOU', score: playerScore, isPlayer: true),
    );

    // Add Mock High Scores (Fixed)
    if (mode == 'normal') {
      entries.add(LeaderboardEntry(name: 'FlappyKing', score: 150));
      entries.add(LeaderboardEntry(name: 'PixelBird', score: 80));
      entries.add(LeaderboardEntry(name: 'SkyHigh', score: 45));
    } else {
      entries.add(LeaderboardEntry(name: 'ProGamer', score: 50));
      entries.add(LeaderboardEntry(name: 'HardCore', score: 30));
    }

    // Add Random Filler
    for (int i = 0; i < 5; i++) {
      entries.add(
        LeaderboardEntry(
          name: 'Guest${random.nextInt(9999)}',
          score: max(
            5,
            playerScore + random.nextInt(40) - 20,
          ), // Around player score
        ),
      );
    }

    // Sort descending
    entries.sort((a, b) => b.score.compareTo(a.score));

    return entries.take(10).toList(); // Top 10
  }
}
