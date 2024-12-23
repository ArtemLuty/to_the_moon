import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:math';

import 'package:to_the_moon/components/platform.dart';

class Character extends SpriteComponent with HasGameRef, CollisionCallbacks {
  bool isJumping = false;
  double gravity = 200; // Gravity force
  double velocityY = 0; // Vertical velocity
  double velocityX = 0; // Horizontal velocity
  double initialY = 600; // Starting Y position (ground level)
  double initialX = 100; // Starting X position

  // Screen boundaries for the character
  double minX = 0;
  double maxX = 360; // Adjust based on your screen width
  double minY = 0;
  double maxY = 600; // Adjust based on your screen height

  Character() : super(size: Vector2(32, 64), position: Vector2(100, 600));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('character_spritesheet.png');
    add(RectangleHitbox()); // Add a hitbox for collision detection
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity (affecting only vertical velocity)
    if (isJumping) {
      velocityY += gravity * dt;
    }

    // Update position based on velocity
    position.y += velocityY * dt;
    position.x += velocityX * dt;

    // Ensure the character doesn't go outside the screen boundaries (left and right)
    if (position.x < minX) {
      position.x = minX; // Keep character within left boundary
      velocityX = 0; // Stop horizontal movement if out of bounds
    }
    if (position.x > maxX) {
      position.x = maxX; // Keep character within right boundary
      velocityX = 0; // Stop horizontal movement if out of bounds
    }

    // Ensure the character doesn't go below the ground (y-axis)
    if (position.y >= initialY) {
      position.y = initialY;
      isJumping = false;
      velocityY = 0; // Reset vertical velocity
    }

    // Ensure the character doesn't go above the screen (y-axis)
    if (position.y < minY) {
      position.y = minY; // Keep character within top boundary
      velocityY = 0; // Stop upward movement if out of bounds
    }
  }

  // Collision callback to handle collisions with platforms
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      // When the character hits any part of the platform, stop the falling motion
      if (velocityY > 0) {
        position.y =
            other.position.y - size.y; // Place character on top of platform
        velocityY = 0; // Stop vertical movement (reset velocity)
        isJumping = false; // Allow jumping again
      }
    }
  }

  void jump() {
    if (!isJumping) {
      velocityY = -300; // Initial jump velocity
      isJumping = true;
    }
  }

  void launch(double dragDistance, double dragAngle) {
    if (!isJumping) {
      // Vertical launch based on drag distance
      velocityY = -dragDistance * 1.9;

      // Horizontal velocity based on the angle of drag
      velocityX = dragDistance *
          1.0 *
          dragAngle; // Horizontal velocity is affected by the angle

      isJumping = true;
    }
  }
}
