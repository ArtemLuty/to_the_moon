import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'components/character.dart';
import 'components/platform.dart';
// For angle calculations

class PlatformerGame extends FlameGame
    with HasCollisionDetection, TapDetector, PanDetector {
  late Character _character;
  late ParallaxComponent _parallaxBackground;

  Vector2 _initialTouchPosition = Vector2.zero();
  bool _isDragging = false;
  double _dragDistance = 0;
  double _dragAngle = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load parallax background
    _parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('parallax_layer_2.png'),
        ParallaxImageData('parallax_layer_2.png'),
      ],
      baseVelocity: Vector2(0, -30),
      velocityMultiplierDelta: Vector2(1.0, 0.01),
    );
    add(_parallaxBackground);

    // Add character
    _character = Character();
    add(_character);

    // Add platforms
    addAll(List.generate(10, (i) => Platform.random(yOffset: i * 150)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Adjust background speed when character jumps
    if (_character.position.y < 300) {
      double additionalSpeed = (300 - _character.position.y) * 0.2;
      _parallaxBackground.parallax?.baseVelocity =
          Vector2(0, -30 - additionalSpeed);
    } else {
      _parallaxBackground.parallax?.baseVelocity = Vector2(0, -30);
    }
  }

  @override
  void onTap() {
    if (!_isDragging) {
      _character.jump();
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    _initialTouchPosition = info.eventPosition.global;
    _isDragging = true;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final dragVector = info.eventPosition.global - _initialTouchPosition;
    _dragDistance = dragVector.length;
    _dragAngle = atan2(dragVector.y, dragVector.x); // Calculate the angle
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (_isDragging) {
      _character.launch(_dragDistance,
          _dragAngle); // Pass both distance and angle to the launch
      _isDragging = false;
    }
  }
}
