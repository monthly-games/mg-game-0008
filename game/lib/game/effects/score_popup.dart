import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Animated score popup that appears when passing through pipes
class ScorePopup extends PositionComponent {
  final int score;
  double _elapsed = 0;
  static const double _duration = 1.0;
  static const double _riseSpeed = 50.0;

  ScorePopup({
    required Vector2 position,
    required this.score,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;

    // Rise upward
    position.y -= _riseSpeed * dt;

    // Remove after duration
    if (_elapsed >= _duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate opacity based on elapsed time
    final progress = _elapsed / _duration;
    final opacity = 1.0 - progress;

    // Create fading text paint
    final fadingPaint = TextPaint(
      style: TextStyle(
        color: Colors.white.withValues(alpha: opacity),
        fontSize: 48,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: const Offset(2, 2),
            blurRadius: 4,
            color: Colors.black.withValues(alpha: opacity),
          ),
        ],
      ),
    );

    fadingPaint.render(
      canvas,
      '+1',
      Vector2.zero(),
      anchor: Anchor.center,
    );
  }
}
