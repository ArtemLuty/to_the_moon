import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:math';

class Platform extends SpriteComponent with HasGameRef {
  static final Random _random = Random();

  Platform.random({double yOffset = 0})
      : super(
          size: Vector2(100.0 + _random.nextInt(100),
              20), // Width between 100 and 200 pixels
          position: Vector2(
            _random.nextDouble() * 300, // Random X position
            yOffset, // Y offset
          ),
        );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('platform_spritesheet.png');
    add(RectangleHitbox()); // Adding the hitbox for collision
  }

  @override
  void update(double dt) {
    super.update(dt);
    // You can add additional logic here if needed (like moving or disappearing platforms)
  }
}
