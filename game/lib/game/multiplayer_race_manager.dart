import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum RaceStatus { waiting, racing, completed }

class RaceParticipant {
  final String playerId;
  final String playerName;
  final String avatar;
  int score;
  int pipesPassed;
  final DateTime joinTime;

  RaceParticipant({
    required this.playerId,
    required this.playerName,
    required this.avatar,
    this.score = 0,
    this.pipesPassed = 0,
    DateTime? joinTime,
  }) : joinTime = joinTime ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'avatar': avatar,
      'score': score,
      'pipesPassed': pipesPassed,
      'joinTime': joinTime.millisecondsSinceEpoch,
    };
  }

  factory RaceParticipant.fromJson(Map<String, dynamic> json) {
    return RaceParticipant(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      avatar: json['avatar'] as String,
      score: json['score'] as int,
      pipesPassed: json['pipesPassed'] as int,
      joinTime: DateTime.fromMillisecondsSinceEpoch(json['joinTime'] as int),
    );
  }
}

class MultiplayerRace extends ChangeNotifier {
  final String raceId;
  final String roomId;
  final DateTime startTime;
  final int targetScore;
  final List<RaceParticipant> participants;
  RaceStatus status = RaceStatus.waiting;

  MultiplayerRace({
    required this.raceId,
    required this.roomId,
    required this.startTime,
    this.targetScore = 20,
    List<RaceParticipant>? participants,
  }) : participants = participants ?? [];

  void updateParticipantScore(String playerId, int newScore, int pipesPassed) {
    final participant = participants.firstWhere(
      (p) => p.playerId == playerId,
      orElse: () => RaceParticipant(
        playerId: playerId,
        playerName: 'Unknown',
        avatar: 'default',
      ),
    );

    participant.score = newScore;
    participant.pipesPassed = pipesPassed;

    // Check for race completion
    if (newScore >= targetScore && status == RaceStatus.racing) {
      status = RaceStatus.completed;
    }

    notifyListeners();
  }

  int getPlayerPosition(String playerId) {
    final sortedParticipants = List<RaceParticipant>.from(participants)
      ..sort((a, b) => b.score.compareTo(a.score));

    for (int i = 0; i < sortedParticipants.length; i++) {
      if (sortedParticipants[i].playerId == playerId) {
        return i + 1;
      }
    }
    return participants.length;
  }

  List<RaceParticipant> getLeaderboard() {
    final sorted = List<RaceParticipant>.from(participants)
      ..sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  Map<String, dynamic> toJson() {
    return {
      'raceId': raceId,
      'roomId': roomId,
      'startTime': startTime.millisecondsSinceEpoch,
      'targetScore': targetScore,
      'participants': participants.map((p) => p.toJson()).toList(),
      'status': status.index,
    };
  }

  factory MultiplayerRace.fromJson(Map<String, dynamic> json) {
    final race = MultiplayerRace(
      raceId: json['raceId'] as String,
      roomId: json['roomId'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int),
      targetScore: json['targetScore'] as int,
      participants: (json['participants'] as List)
          .map((p) => RaceParticipant.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
    race.status = RaceStatus.values[json['status'] as int];
    return race;
  }
}

class MultiplayerRaceManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  MultiplayerRace? _currentRace;
  Timer? _raceTimer;
  Timer? _leaderboardUpdateTimer;

  MultiplayerRace? get currentRace => _currentRace;

  String? _currentPlayerId;
  String? _currentPlayerName;

  List<MultiplayerRace> _availableRaces = [];
  List<MultiplayerRace> get availableRaces => _availableRaces;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  final Random _random = Random();

  void setCurrentPlayer(String playerId, String playerName) {
    _currentPlayerId = playerId;
    _currentPlayerName = playerName;
  }

  Future<MultiplayerRace> createRace(String roomId, int targetScore) async {
    final raceId = 'race_${DateTime.now().millisecondsSinceEpoch}';

    final race = MultiplayerRace(
      raceId: raceId,
      roomId: roomId,
      startTime: DateTime.now().add(const Duration(seconds: 10)), // Start in 10 seconds
      targetScore: targetScore,
    );

    // Add current player as host
    if (_currentPlayerId != null) {
      race.participants.add(RaceParticipant(
        playerId: _currentPlayerId!,
        playerName: _currentPlayerName ?? 'Player',
        avatar: 'default',
      ));
    }

    // Save to Firestore
    await _firestore.collection('races').doc(raceId).set(race.toJson());

    _currentRace = race;
    notifyListeners();

    return race;
  }

  Future<void> joinRace(String raceId) async {
    final doc = await _firestore.collection('races').doc(raceId).get();
    if (!doc.exists) return;

    final race = MultiplayerRace.fromJson(doc.data()!);

    // Add current player
    if (_currentPlayerId != null) {
      race.participants.add(RaceParticipant(
        playerId: _currentPlayerId!,
        playerName: _currentPlayerName ?? 'Player',
        avatar: 'default',
      ));

      await _firestore.collection('races').doc(raceId).update(race.toJson());
    }

    _currentRace = race;
    notifyListeners();

    // Listen for race updates
    _startListeningToRace(raceId);
  }

  Future<void> findQuickRace() async {
    _isSearching = true;
    notifyListeners();

    try {
      // Look for available races
      final snapshot = await _firestore
          .collection('races')
          .where('status', isEqualTo: RaceStatus.waiting.index)
          .limit(5)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Join the first available race
        final raceDoc = snapshot.docs.first;
        await joinRace(raceDoc.id);
      } else {
        // Create a new race if none available
        await createRace('room_${_random.nextInt(1000)}', 20);
      }
    } catch (e) {
      debugPrint('Error finding quick race: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void _startListeningToRace(String raceId) {
    _firestore.collection('races').doc(raceId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        _currentRace = MultiplayerRace.fromJson(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  void startRace() {
    if (_currentRace == null) return;

    _currentRace!.status = RaceStatus.racing;
    notifyListeners();

    // Update in Firestore
    _firestore
        .collection('races')
        .doc(_currentRace!.raceId)
        .update(_currentRace!.toJson());

    // Start race timer
    _raceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentRace!.status == RaceStatus.completed) {
        timer.cancel();
        _onRaceCompleted();
      }
    });

    // Start leaderboard update timer
    _leaderboardUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _updateLeaderboard();
    });
  }

  void updateScore(int score, int pipesPassed) {
    if (_currentRace == null || _currentPlayerId == null) return;

    _currentRace!.updateParticipantScore(_currentPlayerId!, score, pipesPassed);

    // Update in Firestore
    _firestore
        .collection('races')
        .doc(_currentRace!.raceId)
        .update(_currentRace!.toJson());
  }

  void _updateLeaderboard() {
    if (_currentRace == null) return;

    // Refresh from Firestore
    _firestore
        .collection('races')
        .doc(_currentRace!.raceId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        _currentRace = MultiplayerRace.fromJson(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  void _onRaceCompleted() {
    _raceTimer?.cancel();
    _leaderboardUpdateTimer?.cancel();

    // Calculate rewards based on position
    final position = _currentRace!.getPlayerPosition(_currentPlayerId!);
    final rewards = _calculateRaceRewards(position);

    notifyListeners();
  }

  Map<String, int> _calculateRaceRewards(int position) {
    switch (position) {
      case 1:
        return {'coins': 500, 'xp': 100};
      case 2:
        return {'coins': 300, 'xp': 75};
      case 3:
        return {'coins': 200, 'xp': 50};
      default:
        return {'coins': 100, 'xp': 25};
    }
  }

  Future<void> leaveRace() async {
    if (_currentRace == null) return;

    _raceTimer?.cancel();
    _leaderboardUpdateTimer?.cancel();

    // Remove player from race
    if (_currentPlayerId != null) {
      _currentRace!.participants.removeWhere((p) => p.playerId == _currentPlayerId);

      await _firestore
          .collection('races')
          .doc(_currentRace!.raceId)
          .update(_currentRace!.toJson());
    }

    _currentRace = null;
    notifyListeners();
  }

  Future<void> fetchAvailableRaces() async {
    try {
      final snapshot = await _firestore
          .collection('races')
          .where('status', isEqualTo: RaceStatus.waiting.index)
          .limit(10)
          .get();

      _availableRaces = snapshot.docs
          .map((doc) => MultiplayerRace.fromJson(doc.data()))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching available races: $e');
    }
  }

  @override
  void dispose() {
    _raceTimer?.cancel();
    _leaderboardUpdateTimer?.cancel();
    super.dispose();
  }
}
