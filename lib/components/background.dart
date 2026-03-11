import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show Alignment, LinearGradient;

import '../game.dart';

/// Draws a wider suburban street background (1920x800) at night.
/// Amit will replace this with proper art.
class BackgroundComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(
        NeighborhoodWatchGame.worldWidth, NeighborhoodWatchGame.worldHeight);
    position = Vector2.zero();
    priority = -10;
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Sky gradient — dark night
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0a0a1e), Color(0xFF16213e)],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.45));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.45), skyPaint);

    // Stars
    final starPaint = Paint()..color = const Color(0x88FFFFFF);
    final dimStar = Paint()..color = const Color(0x44FFFFFF);
    final stars = [
      const Offset(50, 30), const Offset(150, 60), const Offset(280, 20),
      const Offset(420, 50), const Offset(550, 15), const Offset(680, 45),
      const Offset(800, 25), const Offset(950, 55), const Offset(1100, 20),
      const Offset(1250, 40), const Offset(1400, 30), const Offset(1550, 50),
      const Offset(1700, 15), const Offset(1850, 35),
      const Offset(100, 80), const Offset(350, 90), const Offset(600, 70),
      const Offset(900, 85), const Offset(1200, 75), const Offset(1500, 95),
      const Offset(1800, 65),
    ];
    for (var i = 0; i < stars.length; i++) {
      canvas.drawCircle(stars[i], i % 3 == 0 ? 1.5 : 1.0,
          i % 2 == 0 ? starPaint : dimStar);
    }

    // Moon
    canvas.drawCircle(
        const Offset(1600, 60), 25, Paint()..color = const Color(0x33FFFFCC));
    canvas.drawCircle(
        const Offset(1600, 60), 22, Paint()..color = const Color(0x55FFFFDD));

    // Distant treeline silhouette
    for (var x = 0.0; x < w; x += 25) {
      final treeH = 20.0 + (x.hashCode % 18);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x + 12, h * 0.35 - treeH / 2 + 5),
          width: 24,
          height: treeH,
        ),
        Paint()..color = const Color(0xFF0e1e0e),
      );
    }

    // Grass — dark night green
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.45, w, h * 0.55),
      Paint()..color = const Color(0xFF1a2e1a),
    );

    // Upper sidewalk
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.52, w, h * 0.04),
      Paint()..color = const Color(0xFF3a3a34),
    );
    canvas.drawLine(
      Offset(0, h * 0.52), Offset(w, h * 0.52),
      Paint()..color = const Color(0xFF2a2a24)..strokeWidth = 1,
    );

    // Street
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.56, w, h * 0.10),
      Paint()..color = const Color(0xFF252525),
    );
    for (var x = 0.0; x < w; x += 40) {
      canvas.drawRect(
        Rect.fromLTWH(x, h * 0.608, 20, 3),
        Paint()..color = const Color(0xFF665518),
      );
    }

    // Lower sidewalk
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.66, w, h * 0.04),
      Paint()..color = const Color(0xFF3a3a34),
    );

    // Lower grass
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.70, w, h * 0.30),
      Paint()..color = const Color(0xFF152415),
    );

    // --- Houses (6 across the scene) ---
    _drawHouse(canvas, 40, 120, 200, 230, const Color(0xFF5a4a3a),
        const Color(0xFF3a2218));
    _drawHouse(canvas, 300, 100, 210, 250, const Color(0xFF504838),
        const Color(0xFF321a10));
    _drawHouse(canvas, 600, 130, 190, 220, const Color(0xFF5a5040),
        const Color(0xFF3a2218));
    _drawHouse(canvas, 880, 110, 220, 240, const Color(0xFF4a4030),
        const Color(0xFF321a10));
    _drawHouse(canvas, 1180, 125, 200, 225, const Color(0xFF584838),
        const Color(0xFF3a2018));
    _drawHouse(canvas, 1480, 105, 230, 245, const Color(0xFF504838),
        const Color(0xFF321810));

    // Fences
    _drawFence(canvas, 250, h * 0.48, 40, 35);
    _drawFence(canvas, 520, h * 0.48, 70, 35);
    _drawFence(canvas, 810, h * 0.48, 60, 35);
    _drawFence(canvas, 1110, h * 0.48, 60, 35);
    _drawFence(canvas, 1400, h * 0.48, 70, 35);
    _drawFence(canvas, 1720, h * 0.48, 50, 35);

    // Bushes
    _drawBush(canvas, 30, h * 0.46, 24);
    _drawBush(canvas, 245, h * 0.46, 20);
    _drawBush(canvas, 500, h * 0.46, 26);
    _drawBush(canvas, 590, h * 0.47, 18);
    _drawBush(canvas, 800, h * 0.46, 22);
    _drawBush(canvas, 870, h * 0.47, 20);
    _drawBush(canvas, 1100, h * 0.46, 24);
    _drawBush(canvas, 1170, h * 0.47, 18);
    _drawBush(canvas, 1390, h * 0.46, 22);
    _drawBush(canvas, 1710, h * 0.46, 26);
    _drawBush(canvas, 1870, h * 0.46, 20);

    // Mailboxes
    _drawMailbox(canvas, 270, h * 0.50);
    _drawMailbox(canvas, 570, h * 0.50);
    _drawMailbox(canvas, 850, h * 0.50);
    _drawMailbox(canvas, 1150, h * 0.50);
    _drawMailbox(canvas, 1450, h * 0.50);

    // Street lamps with glow
    _drawStreetLamp(canvas, 200, h * 0.42);
    _drawStreetLamp(canvas, 550, h * 0.42);
    _drawStreetLamp(canvas, 900, h * 0.42);
    _drawStreetLamp(canvas, 1300, h * 0.42);
    _drawStreetLamp(canvas, 1700, h * 0.42);
  }

  void _drawHouse(Canvas canvas, double x, double y, double w, double h,
      Color wallColor, Color roofColor) {
    canvas.drawRect(Rect.fromLTWH(x, y, w, h), Paint()..color = wallColor);
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()
        ..color = const Color(0x22000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final roofPath = Path()
      ..moveTo(x - 15, y)
      ..lineTo(x + w / 2, y - 50)
      ..lineTo(x + w + 15, y)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = roofColor);

    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + w / 2 - 15, y + h - 60, 30, 60),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF2a1a0a),
    );
    canvas.drawCircle(
      Offset(x + w / 2 + 8, y + h - 30), 3,
      Paint()..color = const Color(0xFF665010),
    );

    // Windows (warm glow at night)
    _drawWindow(canvas, x + 20, y + 30, 35, 30);
    _drawWindow(canvas, x + w - 55, y + 30, 35, 30);
    if (h > 200) {
      _drawWindow(canvas, x + 20, y + 90, 35, 30);
      _drawWindow(canvas, x + w - 55, y + 90, 35, 30);
    }
  }

  void _drawWindow(Canvas canvas, double x, double y, double w, double h) {
    // Warm interior glow
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFF665020),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()
        ..color = const Color(0xFF777777)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(x + w / 2, y), Offset(x + w / 2, y + h),
      Paint()..color = const Color(0xFF777777)..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(x, y + h / 2), Offset(x + w, y + h / 2),
      Paint()..color = const Color(0xFF777777)..strokeWidth = 1.5,
    );
  }

  void _drawFence(Canvas canvas, double x, double y, double w, double h) {
    final paint = Paint()..color = const Color(0xFF3a3a2e);
    final darkPaint = Paint()..color = const Color(0xFF2e2e22);
    for (var fx = x; fx <= x + w; fx += 12) {
      canvas.drawRect(Rect.fromLTWH(fx, y - h, 4, h), paint);
      final path = Path()
        ..moveTo(fx, y - h)
        ..lineTo(fx + 2, y - h - 6)
        ..lineTo(fx + 4, y - h)
        ..close();
      canvas.drawPath(path, paint);
    }
    canvas.drawRect(Rect.fromLTWH(x, y - h * 0.7, w, 3), darkPaint);
    canvas.drawRect(Rect.fromLTWH(x, y - h * 0.3, w, 3), darkPaint);
  }

  void _drawBush(Canvas canvas, double x, double y, double r) {
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: r * 2, height: r * 1.2),
        Paint()..color = const Color(0xFF0e2a0e));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x - r * 0.5, y + 2),
            width: r * 1.2, height: r * 0.9),
        Paint()..color = const Color(0xFF0a200a));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x + r * 0.5, y + 2),
            width: r * 1.2, height: r * 0.9),
        Paint()..color = const Color(0xFF123012));
  }

  void _drawMailbox(Canvas canvas, double x, double y) {
    canvas.drawRect(
      Rect.fromLTWH(x + 4, y, 4, 20),
      Paint()..color = const Color(0xFF333333),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 2, y - 8, 16, 10),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF1a1a44),
    );
  }

  void _drawStreetLamp(Canvas canvas, double x, double y) {
    // Pole
    canvas.drawRect(
      Rect.fromLTWH(x - 2, y, 4, 80),
      Paint()..color = const Color(0xFF444444),
    );
    // Lamp head
    canvas.drawRect(
      Rect.fromLTWH(x - 8, y - 4, 16, 6),
      Paint()..color = const Color(0xFF555555),
    );
    // Light glow (concentric circles)
    canvas.drawCircle(
      Offset(x, y + 4), 40,
      Paint()..color = const Color(0x0AFFDD88),
    );
    canvas.drawCircle(
      Offset(x, y + 4), 20,
      Paint()..color = const Color(0x15FFDD88),
    );
    // Bulb
    canvas.drawCircle(
      Offset(x, y + 2), 3,
      Paint()..color = const Color(0x66FFDD88),
    );
  }
}
