import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';

/// Floating score text that rises and fades out.
class ScorePopup extends PositionComponent with HasPaint {
  final int points;
  final Vector2 worldPosition;

  ScorePopup({required this.points, required this.worldPosition})
      : super(priority: 90);

  @override
  Future<void> onLoad() async {
    position = worldPosition.clone();

    // Rise up
    add(MoveEffect.by(
      Vector2(0, -40),
      EffectController(duration: 0.8),
    ));

    // Fade out
    add(OpacityEffect.to(
      0.0,
      EffectController(duration: 0.8),
      onComplete: () => removeFromParent(),
    ));
  }

  @override
  void render(ui.Canvas canvas) {
    final alpha = (paint.color.a * 255).round().clamp(0, 255);
    final text = '+$points';
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: ui.Color.fromARGB(alpha, 255, 215, 0),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    painter.paint(canvas, ui.Offset(-painter.width / 2, -painter.height / 2));
  }
}
