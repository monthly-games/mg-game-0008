/// VFX Manager for MG-0008 Flappy Bird
library;
import 'package:flame/components.dart';
import 'package:mg_common_game/core/engine/effects/flame_effects.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';

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
          color: MGColors.textMediumEmphasis,
          radius: 15.0,
        ),
    );
  }

  /// Show pipe pass score effect
  void showScore(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: MGColors.success,
          radius: 25.0,
        ),
    );
  }

  /// Show collision effect
  void showCollision(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: MGColors.error,
          radius: 35.0,
        ),
    );
  }

  /// Show milestone celebration
  void showMilestone(Vector2 position, int score) {
    final color = score >= 100 ? MGColors.gem :
                  score >= 50 ? MGColors.gold : MGColors.gold;
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
          color: MGColors.gold,
          radius: 10.0,
        ),
    );
  }

  /// Show new high score effect
  void showHighScore(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: MGColors.gold,
          radius: 60.0,
        ),
    );
  }
}
