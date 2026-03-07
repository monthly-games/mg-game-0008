/// VFX Manager for MG-0008 Flappy Bird
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mg_common_game/core/engine/effects/flame_effects.dart';

class VfxManager extends Component {
  VfxManager();

  Component? _gameRef;

  void setGame(Component game) {
    _gameRef = game;
  }

  void _addEffect(Component effect) {
    _gameRef?.add(effect);
  }

  /// Show flap effect
  void showFlap(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.white.withValues(alpha: 0.7),
          radius: 15.0,
        ),
    );
  }

  /// Show pipe pass score effect
  void showScore(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.green,
          radius: 25.0,
        ),
    );
  }

  /// Show collision effect
  void showCollision(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.red,
          radius: 35.0,
        ),
    );
  }

  /// Show milestone celebration
  void showMilestone(Vector2 position, int score) {
    final color = score >= 100 ? Colors.purple :
                  score >= 50 ? Colors.amber : Colors.yellow;
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: color,
          radius: 45.0,
        ),
    );
  }

  /// Show feather trail effect
  void showFeatherTrail(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.yellow.shade200,
          radius: 10.0,
        ),
    );
  }

  /// Show new high score effect
  void showHighScore(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.amber,
          radius: 60.0,
        ),
    );
  }
}
