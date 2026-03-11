import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';

/// Red "MISSED!" text that appears when an NPC expires.
class MissedPopup extends PositionComponent with HasPaint {
  final Vector2 worldPosition;

  MissedPopup({required this.worldPosition}) : super(priority: 91);

  @override
  Future<void> onLoad() async {
    position = worldPosition.clone();

    // Rise up
    add(MoveEffect.by(
      Vector2(0, -30),
      EffectController(duration: 0.6),
    ));

    // Fade out
    add(OpacityEffect.to(
      0.0,
      EffectController(duration: 0.6),
      onComplete: () => removeFromParent(),
    ));
  }

  @override
  void render(ui.Canvas canvas) {
    final alpha = (paint.color.a * 255).round().clamp(0, 255);
    final painter = TextPainter(
      text: TextSpan(
        text: 'MISSED!',
        style: TextStyle(
          color: ui.Color.fromARGB(alpha, 255, 60, 60),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, ui.Offset(-painter.width / 2, -painter.height / 2));
  }
}
