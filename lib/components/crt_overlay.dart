import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../game.dart';

/// CRT/VCR effect overlay: scanlines, subtle green tint, corner vignette.
/// Rendered in viewport space at priority 150 (above binoculars, below HUD).
class CrtOverlay extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(
        NeighborhoodWatchGame.gameWidth, NeighborhoodWatchGame.gameHeight);
    priority = 150;
  }

  @override
  void render(ui.Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Horizontal scanlines
    final scanPaint = ui.Paint()..color = const ui.Color(0x0C000000);
    for (var y = 0.0; y < h; y += 3) {
      canvas.drawRect(ui.Rect.fromLTWH(0, y, w, 1.5), scanPaint);
    }

    // Very subtle green tint wash
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, w, h),
      ui.Paint()..color = const ui.Color(0x06FFAA00),
    );

    // Corner vignette (darken edges)
    final vignetteRect = ui.Rect.fromLTWH(0, 0, w, h);
    final vignettePaint = ui.Paint()
      ..shader = ui.Gradient.radial(
        ui.Offset(w / 2, h / 2),
        w * 0.6,
        const [ui.Color(0x00000000), ui.Color(0x33000000)],
        const [0.5, 1.0],
      );
    canvas.drawRect(vignetteRect, vignettePaint);
  }
}
