import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:mg_common_game/core/assets/asset_types.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'flappy_game.dart';
import 'pipe.dart';
import 'ground.dart';
import 'effects/score_particle.dart';
import 'skin_manager.dart';
// import 'spine_config.dart';

// Rewriting properly to use SpriteAnimationComponent for better visual
class Bird extends SpriteAnimationComponent
    with HasGameReference<FlappyGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  final Vector2 initialPosition;

  static const double flapStrength = -400.0;
  static const double maxFallSpeed = 600.0;

  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _flapAnimation;

  /// Spine rendering component - disabled (MGSpineActor not available)
  // MGSpineActor? _spineActor;

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

    // Spine rendering disabled - MGSpineActor not available
    // if (kSpineEnabled) {
    //   final meta = _getMetaForSkin(skin);
    //   _spineActor = MGSpineActor(assetKey: meta.key, meta: meta);
    //   await add(_spineActor!);
    //   return;
    // }

    // Load sprite animation
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

  /// BirdSkin to SpineAssetMeta mapping - disabled
  // SpineAssetMeta _getMetaForSkin(BirdSkin skin) {
  //   switch (skin) {
  //     case BirdSkin.red:
  //       return kRedBirdMeta;
  //     case BirdSkin.blue:
  //       return kBlueBirdMeta;
  //     case BirdSkin.gold:
  //       return kGoldBirdMeta;
  //   }
  // }

  void flap() {
    velocity.y = flapStrength;
    // if (kSpineEnabled && _spineActor != null) {
    //   _spineActor!.playAnimation('flap');
    // } else {
      animation = _flapAnimation;
    // }
  }

  void reset() {
    position = initialPosition.clone();
    velocity = Vector2.zero();
    // if (kSpineEnabled && _spineActor != null) {
    //   _spineActor!.playAnimation('idle');
    // } else {
      animation = _idleAnimation;
    // }
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
    // if (kSpineEnabled && _spineActor != null) {
    //   if (velocity.y > 0) {
    //     _spineActor!.playAnimation('fall');
    //   }
    // } else {
      if (velocity.y > 0) {
        animation = _idleAnimation;
      } else {
        animation = _flapAnimation;
      }
    // }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe || other is Ground) {
      // if (kSpineEnabled && _spineActor != null) {
      //   _spineActor!.playAnimation('hit', loop: false);
      // }
      game.add(CollisionParticleEffect(position: position.clone()));
      game.endGame();
    }
  }
}

enum BirdState { idle, flapping }
