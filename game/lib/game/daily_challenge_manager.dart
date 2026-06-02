import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ChallengeType { score, pipes_passed, perfect_play, survival }

class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int targetValue;
  final int rewardCoins;
  final DateTime date;
  bool isCompleted;
  int currentProgress;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.rewardCoins = 100,
    required this.date,
    this.isCompleted = false,
    this.currentProgress = 0,
  });

  double get progressPercentage => targetValue > 0 ? currentProgress / targetValue : 0;
  bool get isExpired => date.day != DateTime.now().day;
}

class DailyChallengeManager extends ChangeNotifier {
  DailyChallenge? _activeChallenge;

  DailyChallenge? get activeChallenge => _activeChallenge;

  int totalCompletedChallenges = 0;
  int totalCoinsEarned = 0;

  DailyChallengeManager() {
    _loadOrGenerateChallenge();
  }

  Future<void> _loadOrGenerateChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = 'challenge_${today.year}_${today.month}_${today.day}';

    final savedData = prefs.getString(todayKey);
    if (savedData != null) {
      // Load existing challenge
      final parts = savedData.split('|');
      if (parts.length >= 4) {
        _activeChallenge = DailyChallenge(
          id: parts[0],
          title: parts[1],
          description: parts[2],
          type: ChallengeType.values[int.parse(parts[3])],
          targetValue: int.parse(parts[4]),
          rewardCoins: int.parse(parts[5]),
          date: today,
          isCompleted: parts[7] == 'true',
          currentProgress: int.parse(parts[8]),
        );
      }
    }

    // Generate new challenge if none exists or expired
    if (_activeChallenge == null || _activeChallenge!.isExpired) {
      _generateDailyChallenge();
    }

    totalCompletedChallenges = prefs.getInt('total_challenges_completed') ?? 0;
    totalCoinsEarned = prefs.getInt('total_challenges_coins') ?? 0;

    notifyListeners();
  }

  void _generateDailyChallenge() {
    final today = DateTime.now();
    final random = today.day % 5; // Deterministic based on day

    final challenges = [
      DailyChallenge(
        id: 'daily_score_$today',
        title: '점수 도전',
        description: '단일 게임에서 ${[10, 15, 20, 25, 30][random]}점 달성',
        type: ChallengeType.score,
        targetValue: [10, 15, 20, 25, 30][random],
        rewardCoins: 100 + (random * 20),
        date: today,
      ),
      DailyChallenge(
        id: 'daily_pipes_$today',
        title: '파이프 통과',
        description: '${[10, 15, 20, 25, 30][random]}개 파이프 통과',
        type: ChallengeType.pipes_passed,
        targetValue: [10, 15, 20, 25, 30][random],
        rewardCoins: 80 + (random * 15),
        date: today,
      ),
      DailyChallenge(
        id: 'daily_perfect_$today',
        title: '완벽한 플레이',
        description: '${[3, 5, 7, 10, 15][random]}개 파이프를 충돌 없이 통과',
        type: ChallengeType.perfect_play,
        targetValue: [3, 5, 7, 10, 15][random],
        rewardCoins: 150 + (random * 30),
        date: today,
      ),
      DailyChallenge(
        id: 'daily_survival_$today',
        title: '서바이벌',
        description: '${[2, 3, 4, 5, 6][random]}분 생존',
        type: ChallengeType.survival,
        targetValue: [2, 3, 4, 5, 6][random],
        rewardCoins: 120 + (random * 25),
        date: today,
      ),
    ];

    _activeChallenge = challenges[random];
    _saveChallenge();
  }

  Future<void> _saveChallenge() async {
    if (_activeChallenge == null) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = 'challenge_${today.year}_${today.month}_${today.day}';

    final data = '${_activeChallenge!.id}|'
        '${_activeChallenge!.title}|'
        '${_activeChallenge!.description}|'
        '${_activeChallenge!.type.index}|'
        '${_activeChallenge!.targetValue}|'
        '${_activeChallenge!.rewardCoins}|'
        '${_activeChallenge!.date.millisecondsSinceEpoch}|'
        '${_activeChallenge!.isCompleted}|'
        '${_activeChallenge!.currentProgress}';

    await prefs.setString(todayKey, data);
  }

  Future<void> updateProgress(int progress) async {
    if (_activeChallenge == null || _activeChallenge!.isCompleted) return;

    _activeChallenge!.currentProgress = progress;

    if (_activeChallenge!.currentProgress >= _activeChallenge!.targetValue) {
      _activeChallenge!.isCompleted = true;
      totalCompletedChallenges++;
      totalCoinsEarned += _activeChallenge!.rewardCoins;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('total_challenges_completed', totalCompletedChallenges);
      await prefs.setInt('total_challenges_coins', totalCoinsEarned);
    }

    await _saveChallenge();
    notifyListeners();
  }

  Future<int> claimReward() async {
    if (_activeChallenge == null || !_activeChallenge!.isCompleted) return 0;

    final reward = _activeChallenge!.rewardCoins;

    // Reset after claiming
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = 'challenge_${today.year}_${today.month}_${today.day}';
    await prefs.remove(todayKey);

    _activeChallenge = null;
    notifyListeners();

    return reward;
  }

  bool get hasActiveChallenge => _activeChallenge != null && !_activeChallenge!.isExpired;

  int getStreakDays() {
    // Calculate streak based on completed challenges
    return totalCompletedChallenges;
  }
}
