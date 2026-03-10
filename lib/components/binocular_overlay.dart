import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Draws a binocular vignette effect — two overlapping circles with dark outside.
class BinocularOverlay extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, NeighborhoodWatchGame.gameHeight);
    priority = 100; // Always on top
  }

  @override
  void render(ui.Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final radius = h * 0.48;
    final separation = w * 0.15;

    // Create a path that covers the whole screen
    final outerPath = ui.Path()..addRect(ui.Rect.fromLTWH(0, 0, w, h));

    // Cut out two circles (binocular shape)
    final leftCenter = ui.Offset(w / 2 - separation, h / 2);
    final rightCenter = ui.Offset(w / 2 + separation, h / 2);

    final holePath = ui.Path()
      ..addOval(ui.Rect.fromCircle(center: leftCenter, radius: radius))
      ..addOval(ui.Rect.fromCircle(center: rightCenter, radius: radius));

    // Combine: outer minus holes
    final combinedPath =
        ui.Path.combine(ui.PathOperation.difference, outerPath, holePath);

    canvas.drawPath(
      combinedPath,
      ui.Paint()..color = const ui.Color(0xDD000000),
    );

    // Thin circle borders for definition
    final borderPaint = ui.Paint()
      ..color = const ui.Color(0xFF333333)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(leftCenter, radius, borderPaint);
    canvas.drawCircle(rightCenter, radius, borderPaint);

    // Subtle gradient on the edges of circles for depth
    final gradientPaint = ui.Paint()
      ..shader = RadialGradient(
        colors: const [ui.Color(0x00000000), ui.Color(0x44000000)],
        stops: const [0.7, 1.0],
      ).createShader(ui.Rect.fromCircle(center: leftCenter, radius: radius));
    canvas.drawCircle(leftCenter, radius, gradientPaint);

    final gradientPaint2 = ui.Paint()
      ..shader = RadialGradient(
        colors: const [ui.Color(0x00000000), ui.Color(0x44000000)],
        stops: const [0.7, 1.0],
      ).createShader(ui.Rect.fromCircle(center: rightCenter, radius: radius));
    canvas.drawCircle(rightCenter, radius, gradientPaint2);
  }
}
