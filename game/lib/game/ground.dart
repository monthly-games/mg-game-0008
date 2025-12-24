import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart'; // for unique key if needed, or just debug print
import 'flappy_game.dart';
import 'theme_manager.dart';

class Ground extends PositionComponent with HasGameReference<FlappyGame> {
  Ground({required super.position, required super.size})
    : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());

    final themeManager = GetIt.I<ThemeManager>();
    final theme = themeManager.currentTheme;

    // Load ground spritesheet
    // Row 0: Green, Row 1: Snow, Row 2: Pavement
    final image = await game.images.load('ground_skins.png');
    final row = theme == GameTheme.day
        ? 0
        : 2; // Map Day->Green, Night->Pavement

    // Using Parallax for infinite scroll
    // Since ParallaxComponent is a Component, we add it as child.
    // However, ParallaxComponent usually covers full screen or specific size.
    // We want it to fill this Ground component.

    // We need to slice the image to get the specific row.
    // Assuming image width... usually 32 or 100? Pattern should be tileable.
    // Let's assume the whole width is tileable and reuse it.
    // But we need to crop the height.
    // Assuming 32x32 tiles or strips.
    // Let's assume the generated image is a set of vertical strips? Or horizontal strips?
    // Prompt: "A horizontal strip... Seamlessly tileable horizontally... 1) Green ... 2) Snow ... 3) Dark pavement"
    // So it's likely 3 rows.

    // We can't easily crop an image into a new image for Parallax in code without doing some work (e.g. Image composition).
    // Or we use `ParallaxImageData` which takes path. It doesn't take srcRect.
    // `ParallaxLayer` takes an `ParallaxRenderer`.
    // `ParallaxImage` is a renderer.

    // Simpler approach:
    // Ground is static in Y, moves in X.
    // Just use a TiledComponent or manual rendering with 2 sprites moving.
    // Let's use manual scrolling of two sprites for maximum control and simplicity with spritesheet slicing.

    final groundSprite = Sprite(
      image,
      srcPosition: Vector2(
        0,
        row * (image.height / 3),
      ), // Assuming 3 equal rows
      srcSize: Vector2(image.width.toDouble(), image.height / 3),
    );

    add(
      _ScrollingGroundVisual(groundSprite: groundSprite, moveSpeed: 150),
    ); // Sync with pipe speed?
  }

  // No render method needed as children will render
}

class _ScrollingGroundVisual extends PositionComponent
    with HasGameReference<FlappyGame> {
  final Sprite groundSprite;
  final double moveSpeed;

  _ScrollingGroundVisual({required this.groundSprite, required this.moveSpeed});

  @override
  void onMount() {
    super.onMount();
    // Set size to parent size?
    // We need to fill parent.
    size = key?.hashCode != null ? size : Vector2(0, 0); // Just dummy
  }

  double offset = 0;

  @override
  void render(Canvas canvas) {
    if (parent is! PositionComponent) return;
    final pSize = (parent as PositionComponent).size;

    // Draw sprite repeated
    // Sprite width scale to match aspect ratio?
    // Or just draw tile.
    // groundSprite.image is the texture.

    // We want to tile it horizontally.
    // The sprite size is defined by srcSize.
    // We draw it at destination size.

    // Let's just draw the sprite multiple times covering width + buffer.
    final tileWidth =
        pSize.y * (groundSprite.srcSize.x / groundSprite.srcSize.y);

    // If generated image is weird, this might stretch.
    // Let's assume square tiles or reasonable aspect.

    double currentX = -offset;
    while (currentX < pSize.x) {
      groundSprite.render(
        canvas,
        position: Vector2(currentX, 0),
        size: Vector2(tileWidth, pSize.y),
      );
      currentX += tileWidth;
    }
  }

  @override
  void update(double dt) {
    if (!game.gameStarted || game.gameOver) return;

    // Need to know tile width to wrap
    final pSize = (parent as PositionComponent).size;
    final tileWidth =
        pSize.y * (groundSprite.srcSize.x / groundSprite.srcSize.y);

    offset += moveSpeed * dt;
    while (offset >= tileWidth) {
      offset -= tileWidth;
    }
  }
}
