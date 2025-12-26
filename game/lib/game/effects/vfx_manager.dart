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
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.white.withOpacity(0.7),
        particleCount: 6,
        duration: 0.25,
        spreadRadius: 15.0,
      ),
    );
  }

  /// Show pipe pass score effect
  void showScore(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.green,
        particleCount: 10,
        duration: 0.4,
        spreadRadius: 25.0,
      ),
    );
  }

  /// Show collision effect
  void showCollision(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.red,
        particleCount: 20,
        duration: 0.5,
        spreadRadius: 35.0,
      ),
    );
  }

  /// Show milestone celebration
  void showMilestone(Vector2 position, int score) {
    final color = score >= 100 ? Colors.purple :
                  score >= 50 ? Colors.amber : Colors.yellow;
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: color,
        particleCount: 25,
        duration: 0.7,
        spreadRadius: 45.0,
      ),
    );
  }

  /// Show feather trail effect
  void showFeatherTrail(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.yellow.shade200,
        particleCount: 4,
        duration: 0.3,
        spreadRadius: 10.0,
      ),
    );
  }

  /// Show new high score effect
  void showHighScore(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.amber,
        particleCount: 40,
        duration: 1.0,
        spreadRadius: 60.0,
      ),
    );
  }
}
