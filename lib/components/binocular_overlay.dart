import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Draws a realistic binocular vignette — two soft-edged circles with blurred
/// falloff, bright centers, and natural overlap. No hard borders.
class BinocularOverlay extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, game.gameHeight);
    priority = 100;
  }

  @override
  void render(ui.Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final shortSide = w < h ? w : h;
    final radius = shortSide * 0.52;
    final separation = w * 0.12;

    final leftCenter = ui.Offset(w / 2 - separation, h / 2);
    final rightCenter = ui.Offset(w / 2 + separation, h / 2);
    final fullRect = ui.Rect.fromLTWH(0, 0, w, h);

    // Use saveLayer for compositing: draw dark overlay, then punch soft holes
    canvas.saveLayer(fullRect, ui.Paint());

    // Dark surrounding overlay
    canvas.drawRect(fullRect, ui.Paint()..color = const ui.Color(0xF0000000));

    // Punch out left lens with soft radial gradient (dstOut erases the dark layer)
    final lensGradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: const [
        ui.Color(0xFFFFFFFF), // fully erase center
        ui.Color(0xFFFFFFFF),
        ui.Color(0xAAFFFFFF), // start fading
        ui.Color(0x00FFFFFF), // fully transparent = dark stays
      ],
      stops: const [0.0, 0.45, 0.7, 1.0],
    );
    canvas.drawCircle(
      leftCenter,
      radius,
      ui.Paint()
        ..shader = lensGradient
            .createShader(ui.Rect.fromCircle(center: leftCenter, radius: radius))
        ..blendMode = ui.BlendMode.dstOut,
    );

    // Punch out right lens
    canvas.drawCircle(
      rightCenter,
      radius,
      ui.Paint()
        ..shader = lensGradient
            .createShader(ui.Rect.fromCircle(center: rightCenter, radius: radius))
        ..blendMode = ui.BlendMode.dstOut,
    );

    canvas.restore();

    // Subtle brightness boost in center of each lens (bright center effect)
    final brightGradient = RadialGradient(
      colors: const [ui.Color(0x0DFFFFFF), ui.Color(0x00FFFFFF)],
      stops: const [0.0, 0.4],
    );
    canvas.drawCircle(
      leftCenter,
      radius,
      ui.Paint()
        ..shader = brightGradient
            .createShader(ui.Rect.fromCircle(center: leftCenter, radius: radius)),
    );
    canvas.drawCircle(
      rightCenter,
      radius,
      ui.Paint()
        ..shader = brightGradient
            .createShader(ui.Rect.fromCircle(center: rightCenter, radius: radius)),
    );

    // Very subtle warm tint on the glass (barely visible)
    final tintGradient = RadialGradient(
      colors: const [ui.Color(0x00000000), ui.Color(0x06FFE8C0)],
      stops: const [0.5, 1.0],
    );
    canvas.drawCircle(
      leftCenter,
      radius,
      ui.Paint()
        ..shader = tintGradient
            .createShader(ui.Rect.fromCircle(center: leftCenter, radius: radius)),
    );
    canvas.drawCircle(
      rightCenter,
      radius,
      ui.Paint()
        ..shader = tintGradient
            .createShader(ui.Rect.fromCircle(center: rightCenter, radius: radius)),
    );
  }
}
