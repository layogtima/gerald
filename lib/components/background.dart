import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show Alignment, LinearGradient;

import '../game.dart';

/// Draws a suburban street background with colored shapes.
/// Amit will replace this with proper art.
class BackgroundComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(
        NeighborhoodWatchGame.gameWidth, NeighborhoodWatchGame.gameHeight);
    position = Vector2.zero();
    priority = -10;
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Sky gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5BA3D9), Color(0xFFA8D8EA)],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.50));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.50), skyPaint);

    // Clouds
    _drawCloud(canvas, 80, 40, 1.0);
    _drawCloud(canvas, 350, 25, 0.7);
    _drawCloud(canvas, 650, 55, 1.2);
    _drawCloud(canvas, 870, 35, 0.6);

    // Distant treeline
    for (var x = 0.0; x < w; x += 30) {
      final treeH = 25.0 + (x.hashCode % 15);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x + 15, h * 0.38 - treeH / 2 + 5),
          width: 28,
          height: treeH,
        ),
        Paint()..color = const Color(0xFF5A8F3E),
      );
    }

    // Grass area
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.50, w, h * 0.50),
      Paint()..color = const Color(0xFF7EC850),
    );

    // Sidewalk
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.56, w, h * 0.04),
      Paint()..color = const Color(0xFFD0CFC4),
    );
    // Sidewalk edge line
    canvas.drawLine(
      Offset(0, h * 0.56),
      Offset(w, h * 0.56),
      Paint()
        ..color = const Color(0xFFB0AFA4)
        ..strokeWidth = 1,
    );

    // Street
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.60, w, h * 0.10),
      Paint()..color = const Color(0xFF606060),
    );
    // Street center dashes
    for (var x = 0.0; x < w; x += 40) {
      canvas.drawRect(
        Rect.fromLTWH(x, h * 0.648, 20, 3),
        Paint()..color = const Color(0xFFEEDD44),
      );
    }

    // Lower sidewalk
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.70, w, h * 0.04),
      Paint()..color = const Color(0xFFD0CFC4),
    );

    // Houses
    _drawHouse(canvas, 60, 120, 200, 220, const Color(0xFFF5DEB3),
        const Color(0xFFA0522D));
    _drawHouse(canvas, 320, 100, 200, 240, const Color(0xFFDEB887),
        const Color(0xFF8B4513));
    _drawHouse(canvas, 640, 130, 220, 210, const Color(0xFFE8D5B7),
        const Color(0xFF6B3A2A));

    // Fence between houses
    _drawFence(canvas, 270, h * 0.52, 40, 35);
    _drawFence(canvas, 530, h * 0.52, 100, 35);

    // Bushes near houses
    _drawBush(canvas, 50, h * 0.50, 30);
    _drawBush(canvas, 255, h * 0.50, 25);
    _drawBush(canvas, 520, h * 0.50, 28);
    _drawBush(canvas, 630, h * 0.51, 22);
    _drawBush(canvas, 860, h * 0.50, 30);

    // Mailbox
    _drawMailbox(canvas, 285, h * 0.54);
    _drawMailbox(canvas, 610, h * 0.54);
  }

  void _drawCloud(Canvas canvas, double x, double y, double scale) {
    final p = Paint()..color = const Color(0xDDFFFFFF);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x, y), width: 60 * scale, height: 25 * scale),
        p);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x + 20 * scale, y - 8 * scale),
            width: 40 * scale,
            height: 20 * scale),
        p);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x - 15 * scale, y + 2 * scale),
            width: 35 * scale,
            height: 18 * scale),
        p);
  }

  void _drawHouse(Canvas canvas, double x, double y, double w, double h,
      Color wallColor, Color roofColor) {
    // Wall
    canvas.drawRect(Rect.fromLTWH(x, y, w, h), Paint()..color = wallColor);
    // Wall outline
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Roof
    final roofPath = Path()
      ..moveTo(x - 15, y)
      ..lineTo(x + w / 2, y - 50)
      ..lineTo(x + w + 15, y)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = roofColor);
    canvas.drawPath(
      roofPath,
      Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + w / 2 - 15, y + h - 60, 30, 60),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF654321),
    );
    // Doorknob
    canvas.drawCircle(
      Offset(x + w / 2 + 8, y + h - 30),
      3,
      Paint()..color = const Color(0xFFDAA520),
    );

    // Windows
    _drawWindow(canvas, x + 20, y + 30, 35, 30);
    _drawWindow(canvas, x + w - 55, y + 30, 35, 30);
    // Lower windows
    if (h > 200) {
      _drawWindow(canvas, x + 20, y + 90, 35, 30);
      _drawWindow(canvas, x + w - 55, y + 90, 35, 30);
    }
  }

  void _drawWindow(Canvas canvas, double x, double y, double w, double h) {
    // Glass
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFFADE1F5),
    );
    // Frame
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Cross bar
    canvas.drawLine(
      Offset(x + w / 2, y),
      Offset(x + w / 2, y + h),
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(x, y + h / 2),
      Offset(x + w, y + h / 2),
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..strokeWidth = 1.5,
    );
  }

  void _drawFence(Canvas canvas, double x, double y, double w, double h) {
    final paint = Paint()..color = const Color(0xFFF5F5DC);
    final darkPaint = Paint()..color = const Color(0xFFD2C9A5);
    // Posts
    for (var fx = x; fx <= x + w; fx += 12) {
      canvas.drawRect(Rect.fromLTWH(fx, y - h, 4, h), paint);
      // Pointed top
      final path = Path()
        ..moveTo(fx, y - h)
        ..lineTo(fx + 2, y - h - 6)
        ..lineTo(fx + 4, y - h)
        ..close();
      canvas.drawPath(path, paint);
    }
    // Rails
    canvas.drawRect(Rect.fromLTWH(x, y - h * 0.7, w, 3), darkPaint);
    canvas.drawRect(Rect.fromLTWH(x, y - h * 0.3, w, 3), darkPaint);
  }

  void _drawBush(Canvas canvas, double x, double y, double r) {
    final p = Paint()..color = const Color(0xFF4A8B2C);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: r * 2, height: r * 1.2),
        p);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x - r * 0.5, y + 2),
            width: r * 1.2,
            height: r * 0.9),
        Paint()..color = const Color(0xFF3D7A24));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x + r * 0.5, y + 2),
            width: r * 1.2,
            height: r * 0.9),
        Paint()..color = const Color(0xFF55993A));
  }

  void _drawMailbox(Canvas canvas, double x, double y) {
    // Post
    canvas.drawRect(
      Rect.fromLTWH(x + 4, y, 4, 20),
      Paint()..color = const Color(0xFF666666),
    );
    // Box
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 2, y - 8, 16, 10),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF333399),
    );
  }
}
