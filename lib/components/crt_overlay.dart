import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../game.dart';

/// CRT/VCR effect overlay: scanlines, subtle tint, corner vignette.
/// Supports night vision mode and tension-reactive effects.
/// Rendered in viewport space at priority 150 (above binoculars, below HUD).
class CrtOverlay extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  bool nightVisionActive = false;
  bool thermalActive = false;

  double _elapsedTime = 0;
  final Random _noiseRng = Random();

  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, game.gameHeight);
    priority = 150;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
  }

  @override
  void render(ui.Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final tension = game.tension;

    // --- Scanline intensity based on tension ---
    double scanAlphaMultiplier = 1.0;
    if (tension >= 90) {
      scanAlphaMultiplier = 2.5;
    } else if (tension >= 60) {
      scanAlphaMultiplier = 2.0;
    } else if (tension >= 30) {
      scanAlphaMultiplier = 1.5;
    }

    // Night vision doubles scanline base intensity
    final baseScanAlpha = nightVisionActive ? 0x18 : 0x0C;
    final scanAlpha =
        (baseScanAlpha * scanAlphaMultiplier).round().clamp(0, 255);

    // Flicker effect at high tension — modulate alpha with sin wave
    double flickerFactor = 1.0;
    if (tension >= 60) {
      final flickerIntensity = tension >= 90 ? 0.3 : 0.15;
      flickerFactor = 1.0 + sin(_elapsedTime * 8.0) * flickerIntensity;
    }

    final effectiveScanAlpha =
        (scanAlpha * flickerFactor).round().clamp(0, 255);

    // Horizontal scanlines
    final scanPaint = ui.Paint()
      ..color = ui.Color.fromARGB(effectiveScanAlpha, 0, 0, 0);
    for (var y = 0.0; y < h; y += 3) {
      canvas.drawRect(ui.Rect.fromLTWH(0, y, w, 1.5), scanPaint);
    }

    // Tint wash — green for night vision, warm for thermal, orange normally
    if (nightVisionActive) {
      canvas.drawRect(
        ui.Rect.fromLTWH(0, 0, w, h),
        ui.Paint()..color = const ui.Color(0x1500FF00),
      );
    } else if (thermalActive) {
      // Thermal: warm purple-orange gradient wash
      canvas.drawRect(
        ui.Rect.fromLTWH(0, 0, w, h),
        ui.Paint()
          ..shader = ui.Gradient.linear(
            const ui.Offset(0, 0),
            ui.Offset(0, h),
            const [ui.Color(0x18FF4400), ui.Color(0x108800FF)],
          ),
      );
    } else {
      canvas.drawRect(
        ui.Rect.fromLTWH(0, 0, w, h),
        ui.Paint()..color = const ui.Color(0x06FFAA00),
      );
    }

    // Tension 90+: red tint creeping in from edges
    if (tension >= 90) {
      final redAlpha =
          (0.3 + sin(_elapsedTime * 3.0) * 0.1).clamp(0.0, 1.0);
      final redEdgePaint = ui.Paint()
        ..shader = ui.Gradient.radial(
          ui.Offset(w / 2, h / 2),
          w * 0.6,
          [
            const ui.Color(0x00000000),
            ui.Color.fromARGB((redAlpha * 100).round().clamp(0, 255), 200, 30, 10),
          ],
          const [0.4, 1.0],
        );
      canvas.drawRect(ui.Rect.fromLTWH(0, 0, w, h), redEdgePaint);
    }

    // Corner vignette
    if (nightVisionActive) {
      // Green vignette for night vision
      final vignettePaint = ui.Paint()
        ..shader = ui.Gradient.radial(
          ui.Offset(w / 2, h / 2),
          w * 0.6,
          const [ui.Color(0x00000000), ui.Color(0x2000FF00)],
          const [0.5, 1.0],
        );
      canvas.drawRect(ui.Rect.fromLTWH(0, 0, w, h), vignettePaint);
    } else if (thermalActive) {
      // Warm red-orange vignette for thermal
      final vignettePaint = ui.Paint()
        ..shader = ui.Gradient.radial(
          ui.Offset(w / 2, h / 2),
          w * 0.6,
          const [ui.Color(0x00000000), ui.Color(0x22FF4400)],
          const [0.5, 1.0],
        );
      canvas.drawRect(ui.Rect.fromLTWH(0, 0, w, h), vignettePaint);
    } else {
      final vignettePaint = ui.Paint()
        ..shader = ui.Gradient.radial(
          ui.Offset(w / 2, h / 2),
          w * 0.6,
          const [ui.Color(0x00000000), ui.Color(0x33000000)],
          const [0.5, 1.0],
        );
      canvas.drawRect(ui.Rect.fromLTWH(0, 0, w, h), vignettePaint);
    }

    // Night vision noise — sparse random green dots
    if (nightVisionActive) {
      final noisePaint = ui.Paint()..color = const ui.Color(0x2000FF00);
      for (var i = 0; i < 40; i++) {
        final nx = _noiseRng.nextDouble() * w;
        final ny = _noiseRng.nextDouble() * h;
        canvas.drawCircle(ui.Offset(nx, ny), 0.8, noisePaint);
      }
    }
  }
}
