import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'flappy_game.dart';
import 'pipe.dart';
import 'ground.dart';
import 'effects/score_particle.dart';
import 'skin_manager.dart';

// Rewriting properly to use SpriteAnimationComponent for better visual
class Bird extends SpriteAnimationComponent
    with HasGameReference<FlappyGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  final Vector2 initialPosition;

  static const double flapStrength = -400.0;
  static const double maxFallSpeed = 600.0;

  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _flapAnimation;

  Bird({required Vector2 position})
    : initialPosition = position.clone(),
      super(position: position, size: Vector2(40, 40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(
      CircleHitbox(radius: 12, anchor: Anchor.center, position: size / 2),
    ); // Adjusted hitbox

    final skinManager = GetIt.I<SkinManager>();
    final skin = skinManager.currentBirdSkin;

    // Load image
    final image = await game.images.load('bird_skins.png');
    final row = skin.index;

    // Assuming 3 frames per row, 32x32 each
    final frameData = <Sprite>[];
    for (int i = 0; i < 3; i++) {
      // Guard against OOB
      if (i * 32 < image.width && row * 32 < image.height) {
        frameData.add(
          Sprite(
            image,
            srcPosition: Vector2(i * 32.0, row * 32.0),
            srcSize: Vector2(32, 32),
          ),
        );
      }
    }

    if (frameData.isEmpty) {
      // Fallback if image load fails or dims are wrong
      debugPrint('Bird assets invalid dimensions');
      return;
    }

    _idleAnimation = SpriteAnimation.spriteList([frameData[0]], stepTime: 0.1);

    _flapAnimation = SpriteAnimation.spriteList(
      frameData,
      stepTime: 0.1,
      loop: true,
    );

    animation = _idleAnimation;
  }

  void flap() {
    velocity.y = flapStrength;
    animation = _flapAnimation;
    // Reset to idle after short time?
    // Or just keep flapping animation while moving up?
  }

  void reset() {
    position = initialPosition.clone();
    velocity = Vector2.zero();
    animation = _idleAnimation;
    angle = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!game.gameStarted || game.gameOver) return;

    velocity.y += FlappyGame.gravity * dt;
    if (velocity.y > maxFallSpeed) velocity.y = maxFallSpeed;
    position += velocity * dt;

    if (position.y < size.y / 2) {
      position.y = size.y / 2;
      velocity.y = 0;
    }

    // Rotate
    angle = (velocity.y / maxFallSpeed) * 1.5;
    if (angle > 1.5) angle = 1.5;
    if (angle < -0.5) angle = -0.5;

    // Animation state
    if (velocity.y > 0) {
      // Falling
      animation = _idleAnimation; // Or glide frame
    } else {
      animation = _flapAnimation;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe || other is Ground) {
      game.add(CollisionParticleEffect(position: position.clone()));
      game.endGame();
    }
  }
}

enum BirdState { idle, flapping }
