import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'bird.dart';
import 'pipe.dart';
import 'ground.dart';
import 'effects/score_particle.dart';
import 'effects/score_popup.dart';
import 'effects/screen_shake.dart';
import 'theme_manager.dart';

import 'package:mg_common_game/core/audio/audio_manager.dart';
import '../utils/high_score_manager.dart';

enum FlappyGameMode { normal, hard }

class FlappyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final FlappyGameMode mode;
  final VoidCallback? onGameOver;
  FlappyGame({this.mode = FlappyGameMode.normal, this.onGameOver});

  AudioManager get _audioManager => GetIt.I<AudioManager>();
  late Bird bird;
  late Ground ground;

  double pipeSpawnTimer = 0;
  double get pipeSpawnInterval => mode == FlappyGameMode.hard ? 1.5 : 2.0;
  static const double gravity = 980.0;

  int score = 0;
  bool gameOver = false;
  bool gameStarted = false;
  bool isNewRecord = false;

  // Theme
  late Sprite backgroundSprite;

  @override
  bool paused = false;

  @override
  Color backgroundColor() => const Color(0xFF000000); // Background component covers this

  @override
  Future<void> onLoad() async {
    final themeManager = GetIt.I<ThemeManager>();
    final theme = themeManager.currentTheme;

    // Load Background
    final bgImage = await images.load('background_themes.png');
    // Left half = Day, Right half = Night
    final halfWidth = bgImage.width / 2;
    final startX = theme == GameTheme.day ? 0.0 : halfWidth;

    backgroundSprite = Sprite(
      bgImage,
      srcPosition: Vector2(startX, 0),
      srcSize: Vector2(halfWidth, bgImage.height.toDouble()),
    );

    add(
      SpriteComponent(
        sprite: backgroundSprite,
        size: size,
        priority: -10, // Render behind everything
      ),
    );

    // 새 생성
    bird = Bird(position: Vector2(size.x * 0.3, size.y * 0.5));
    add(bird);

    // 땅 생성
    ground = Ground(
      position: Vector2(0, size.y - 100),
      size: Vector2(size.x, 100),
    );
    add(ground);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver || !gameStarted || paused) return;

    // 파이프 생성
    pipeSpawnTimer += dt;
    if (pipeSpawnTimer >= pipeSpawnInterval) {
      pipeSpawnTimer = 0;
      _spawnPipes();
    }

    // 점수 계산 (파이프를 지나갔는지 확인)
    _checkScore();
  }

  void _spawnPipes() {
    final gapSize = mode == FlappyGameMode.hard ? 160.0 : 200.0; // 파이프 사이 간격
    final minHeight = 100.0;
    final maxHeight = size.y - ground.size.y - gapSize - minHeight;

    // 랜덤 높이
    final topHeight =
        minHeight +
        (maxHeight - minHeight) * (0.3 + 0.4 * (bird.position.y / size.y));

    // 상단 파이프
    add(
      Pipe(
        position: Vector2(size.x, 0),
        size: Vector2(60, topHeight),
        isTop: true,
      ),
    );

    // 하단 파이프
    add(
      Pipe(
        position: Vector2(size.x, topHeight + gapSize),
        size: Vector2(60, size.y - ground.size.y - topHeight - gapSize),
        isTop: false,
      ),
    );
  }

  void _checkScore() {
    // 파이프들을 확인하여 새가 지나갔는지 체크
    final pipes = children.whereType<Pipe>();
    for (final pipe in pipes) {
      if (!pipe.scored && pipe.position.x + pipe.size.x < bird.position.x) {
        if (pipe.isTop) {
          // 상단 파이프만 카운트
          score++;
          pipe.scored = true;
          _audioManager.playSfx('score.wav');

          // Add visual effects for scoring
          final centerY = pipe.position.y + pipe.size.y + 100; // Center of gap
          add(ScoreParticleEffect(position: Vector2(bird.position.x, centerY)));
          add(
            ScorePopup(
              position: Vector2(bird.position.x, centerY),
              score: score,
            ),
          );
        }
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (paused) return;

    if (gameOver) {
      _restart();
      return;
    }

    if (!gameStarted) {
      gameStarted = true;
    }

    bird.flap();
    _audioManager.playSfx('jump.wav');
  }

  void togglePause() {
    paused = !paused;
  }

  void resume() {
    paused = false;
  }

  void restart() {
    _restart();
  }

  Future<void> endGame() async {
    if (!gameOver) {
      gameOver = true;
      _audioManager.playSfx('collision.wav');
      // Add screen shake effect on collision
      add(ScreenShakeEffect(game: this, intensity: 15.0, duration: 0.4));

      // Save High Score
      final newRecord = await HighScoreManager.saveHighScore(mode.name, score);
      if (newRecord) {
        isNewRecord = true;
        _audioManager.playSfx('score.wav');
      }

      onGameOver?.call();
    }
  }

  void _restart() {
    isNewRecord = false;
    // 모든 파이프 제거
    children.whereType<Pipe>().toList().forEach(
      (pipe) => pipe.removeFromParent(),
    );

    // 새 리셋
    bird.reset();

    // 상태 리셋
    score = 0;
    gameOver = false;
    gameStarted = false;
    pipeSpawnTimer = 0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 점수 표시 (게임 중일 때만, 혹은 항상? 오버레이가 가리면 됨)
    // Let's keep score during play.
    if (!gameOver) {
      final textPaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black),
          ],
        ),
      );

      textPaint.render(canvas, '$score', Vector2(size.x / 2 - 20, 50));
    }

    // 시작 전 안내
    if (!gameStarted && !gameOver) {
      final startPaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          shadows: [
            Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black),
          ],
        ),
      );

      startPaint.render(
        canvas,
        'Tap to start',
        Vector2(size.x / 2 - 90, size.y / 2),
      );
    }
  }
}
