import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Draws a binocular vignette effect — two overlapping circles with dark outside.
/// Rendered in viewport space so it stays fixed on screen while camera pans.
class BinocularOverlay extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    // Use viewport dimensions (what the camera shows), not world dimensions
    size = Vector2(NeighborhoodWatchGame.gameWidth, NeighborhoodWatchGame.gameHeight);
    priority = 100; // Always on top
  }

  @override
  void render(ui.Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final radius = h * 0.48;
    final separation = w * 0.15;

    // Create a path that covers the whole viewport
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
      ui.Paint()..color = const ui.Color(0xEE000000),
    );

    // Circle borders for definition
    final borderPaint = ui.Paint()
      ..color = const ui.Color(0xFF222222)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(leftCenter, radius, borderPaint);
    canvas.drawCircle(rightCenter, radius, borderPaint);

    // Inner ring detail
    final innerRing = ui.Paint()
      ..color = const ui.Color(0xFF1a1a1a)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(leftCenter, radius - 5, innerRing);
    canvas.drawCircle(rightCenter, radius - 5, innerRing);

    // Radial gradient on edges for depth / vignette
    final gradientPaint = ui.Paint()
      ..shader = RadialGradient(
        colors: const [ui.Color(0x00000000), ui.Color(0x55000000)],
        stops: const [0.65, 1.0],
      ).createShader(ui.Rect.fromCircle(center: leftCenter, radius: radius));
    canvas.drawCircle(leftCenter, radius, gradientPaint);

    final gradientPaint2 = ui.Paint()
      ..shader = RadialGradient(
        colors: const [ui.Color(0x00000000), ui.Color(0x55000000)],
        stops: const [0.65, 1.0],
      ).createShader(ui.Rect.fromCircle(center: rightCenter, radius: radius));
    canvas.drawCircle(rightCenter, radius, gradientPaint2);

    // Subtle green tint on lens edges (CRT feel)
    final greenTint = ui.Paint()
      ..shader = RadialGradient(
        colors: const [ui.Color(0x00000000), ui.Color(0x08FFAA00)],
        stops: const [0.7, 1.0],
      ).createShader(ui.Rect.fromCircle(center: leftCenter, radius: radius));
    canvas.drawCircle(leftCenter, radius, greenTint);

    final greenTint2 = ui.Paint()
      ..shader = RadialGradient(
        colors: const [ui.Color(0x00000000), ui.Color(0x08FFAA00)],
        stops: const [0.7, 1.0],
      ).createShader(ui.Rect.fromCircle(center: rightCenter, radius: radius));
    canvas.drawCircle(rightCenter, radius, greenTint2);
  }
}
