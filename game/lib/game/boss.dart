import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'flappy_game.dart';
import 'bird.dart';
import 'effects/screen_shake.dart';

enum BossType { midBoss, mainBoss }

enum BossPhase { phase1, phase2, phase3 }

class BossAttack {
  final String name;
  final String description;
  final double duration;
  final VoidCallback onExecute;

  BossAttack({
    required this.name,
    required this.description,
    required this.duration,
    required this.onExecute,
  });
}

class Boss extends PositionComponent with HasGameReference<FlappyGame> {
  final BossType type;

  BossPhase currentPhase = BossPhase.phase1;
  double phaseTimer = 0;
  double attackTimer = 0;
  int health = 100;
  bool isDefeated = false;

  List<BossAttack> currentAttacks = [];
  int currentAttackIndex = 0;

  static const double bossSpeed = 150.0;
  static const double attackInterval = 3.0;

  Boss({required this.type, required Vector2 position})
    : super(position: position, size: Vector2(80, 80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox.relativeToParent(this));
    _initializeBoss();
    _initializeAttacks();
  }

  void _initializeBoss() {
    switch (type) {
      case BossType.midBoss:
        health = 50;
        size = Vector2(60, 60);
        break;
      case BossType.mainBoss:
        health = 100;
        size = Vector2(100, 100);
        break;
    }
  }

  void _initializeAttacks() {
    final attacks = <BossAttack>[];

    switch (type) {
      case BossType.midBoss:
        attacks.addAll([
          BossAttack(
            name: 'Wind Gust',
            description: 'Pushes bird downward',
            duration: 1.5,
            onExecute: _executeWindGust,
          ),
          BossAttack(
            name: 'Pipe Barrage',
            description: 'Spawns extra pipes',
            duration: 2.0,
            onExecute: _executePipeBarrage,
          ),
        ]);
        break;
      case BossType.mainBoss:
        attacks.addAll([
          BossAttack(
            name: 'Gravity Storm',
            description: 'Increases gravity temporarily',
            duration: 2.0,
            onExecute: _executeGravityStorm,
          ),
          BossAttack(
            name: 'Wave Attack',
            description: 'Creates moving wave of obstacles',
            duration: 2.5,
            onExecute: _executeWaveAttack,
          ),
          BossAttack(
            name: 'Phase Shift',
            description: 'Teleports and changes pattern',
            duration: 1.0,
            onExecute: _executePhaseShift,
          ),
        ]);
        break;
    }

    currentAttacks = attacks;
  }

  void _executeWindGust() {
    final bird = game.bird;
    bird.velocity.y += 200;
  }

  void _executePipeBarrage() {
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (game.gameOver) return;
        game._spawnPipes();
      });
    }
  }

  void _executeGravityStorm() {
    final originalGravity = FlappyGame.gravity;
    // Temporarily increase gravity
    Future.delayed(const Duration(milliseconds: 100), () {
      // This is a simplified version - in a full implementation,
      // you'd have a gravity modifier system
    });
  }

  void _executeWaveAttack() {
    // Spawn a wave of obstacles
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (game.gameOver) return;
        game._spawnPipes();
      });
    }
  }

  void _executePhaseShift() {
    // Teleport boss and change attack pattern
    position = Vector2(
      game.size.x - 100,
      100 + (game.size.y - 200) * (phaseTimer % 2),
    );
    currentAttackIndex = (currentAttackIndex + 1) % currentAttacks.length;
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0 && !isDefeated) {
      isDefeated = true;
      _onDefeated();
    } else if (health <= 30 && currentPhase == BossPhase.phase1) {
      currentPhase = BossPhase.phase2;
      _onPhaseChange();
    } else if (health <= 10 && currentPhase == BossPhase.phase2) {
      currentPhase = BossPhase.phase3;
      _onPhaseChange();
    }
  }

  void _onPhaseChange() {
    phaseTimer = 0;
    game.add(ScreenShakeEffect(game: game, intensity: 8.0, duration: 0.3));
  }

  void _onDefeated() {
    // Give rewards and clean up
    removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isDefeated || !game.gameStarted || game.gameOver) return;

    // Move boss
    phaseTimer += dt;
    attackTimer += dt;

    // Movement pattern based on phase
    final movementSpeed = bossSpeed * (1 + currentPhase.index * 0.3);
    position.y = 100 + (game.size.y - 200) * (0.5 + 0.3 * sin(phaseTimer * 2));

    // Execute attacks
    if (attackTimer >= attackInterval) {
      attackTimer = 0;
      _executeNextAttack();
    }
  }

  void _executeNextAttack() {
    if (currentAttacks.isEmpty) return;

    final attack = currentAttacks[currentAttackIndex];
    attack.onExecute();

    currentAttackIndex = (currentAttackIndex + 1) % currentAttacks.length;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw boss body
    final paint = Paint()..color = _getBossColor();
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
      paint,
    );

    // Draw boss eyes
    final eyePaint = Paint()..color = MGColors.textHighEmphasis;
    canvas.drawCircle(const Offset(-15, -10), 8, eyePaint);
    canvas.drawCircle(const Offset(15, -10), 8, eyePaint);

    // Draw pupils
    final pupilPaint = Paint()..color = MGColors.error;
    canvas.drawCircle(const Offset(-15, -10), 4, pupilPaint);
    canvas.drawCircle(const Offset(15, -10), 4, pupilPaint);

    // Draw health bar
    _drawHealthBar(canvas);
  }

  Color _getBossColor() {
    switch (type) {
      case BossType.midBoss:
        return currentPhase == BossPhase.phase1
          ? const Color(0xFFFF6B35) // Orange
          : currentPhase == BossPhase.phase2
            ? const Color(0xFFFF8C42) // Lighter orange
            : const Color(0xFFFFB347); // Even lighter
      case BossType.mainBoss:
        return currentPhase == BossPhase.phase1
          ? const Color(0xFF8B0000) // Dark red
          : currentPhase == BossPhase.phase2
            ? const Color(0xFFDC143C) // Crimson
            : const Color(0xFFFF0000); // Red
    }
  }

  void _drawHealthBar(Canvas canvas) {
    const barWidth = 100.0;
    const barHeight = 10.0;
    const barY = -20.0;

    // Background
    final bgPaint = Paint()..color = MGColors.backgroundDark.withOpacity(0.8);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(0, barY), width: barWidth, height: barHeight),
      bgPaint,
    );

    // Health
    final healthPaint = Paint()..color = MGColors.success;
    final healthWidth = (health / (type == BossType.midBoss ? 50 : 100)) * barWidth;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(-barWidth / 2 + healthWidth / 2, barY),
        width: healthWidth,
        height: barHeight,
      ),
      healthPaint,
    );
  }

  int getRewardScore() {
    switch (type) {
      case BossType.midBoss:
        return 25;
      case BossType.mainBoss:
        return 50;
    }
  }

  int getRewardCoins() {
    switch (type) {
      case BossType.midBoss:
        return 100;
      case BossType.mainBoss:
        return 250;
    }
  }
}
