import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:get_it/get_it.dart';
import 'flappy_game.dart';
import 'skin_manager.dart';

class Pipe extends PositionComponent with HasGameReference<FlappyGame> {
  final bool isTop;
  bool scored = false;
  static const double speed = 150.0;

  Pipe({required super.position, required super.size, required this.isTop})
    : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());

    final skinManager = GetIt.I<SkinManager>();
    final skin = skinManager.currentPipeSkin;

    // Load image
    final image = await game.images.load('pipe_skins.png');
    final col = skin.index;
    final startX = col * 32.0;

    // Cap Sprite (Top 32px)
    final capSprite = Sprite(
      image,
      srcPosition: Vector2(startX, 0),
      srcSize: Vector2(32, 28), // 32x28 roughly for cap
    );

    // Body Sprite (Below cap, let's say 32x32 repeatable)
    final bodySprite = Sprite(
      image,
      srcPosition: Vector2(startX, 32),
      srcSize: Vector2(32, 32),
    );

    // Determine Cap and Body positions
    // If isTop: Body (stretched) then Cap at bottom.
    // If not isTop: Cap at top then Body (stretched).

    final capHeight = 32.0;

    if (isTop) {
      // Body Part (Top part of this top pipe)
      // Stretched sprite? Or Tiled?
      // Let's simply stretch for now as "pixel art pipe body" usually stretches okayish vertically
      // Or adds multiple body sprites.

      // Body
      add(
        SpriteComponent(
          sprite: bodySprite,
          position: Vector2(0, 0),
          size: Vector2(size.x, size.y - capHeight),
        ),
      );

      // Cap (Bottom of this top pipe)
      add(
        SpriteComponent(
          sprite: capSprite,
          position: Vector2(0, size.y - capHeight),
          size: Vector2(size.x, capHeight),
        ),
      );
    } else {
      // Cap (Top of this bottom pipe)
      add(
        SpriteComponent(
          sprite: capSprite,
          position: Vector2(0, 0),
          size: Vector2(size.x, capHeight),
        ),
      );

      // Body (Rest)
      add(
        SpriteComponent(
          sprite: bodySprite,
          position: Vector2(0, capHeight),
          size: Vector2(size.x, size.y - capHeight),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.gameStarted || game.gameOver) return;
    position.x -= speed * dt;
    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
