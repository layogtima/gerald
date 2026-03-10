import 'dart:ui';

import 'package:flame/components.dart';

import '../game.dart';

/// Draws a simple suburban street background with colored rectangles.
/// Amit will replace this with proper art.
class BackgroundComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, NeighborhoodWatchGame.gameHeight);
    position = Vector2.zero();
    priority = -10;
  }

  @override
  void render(Canvas canvas) {
    // Sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y * 0.45),
      Paint()..color = const Color(0xFF87CEEB),
    );

    // Grass
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.65, size.x, size.y * 0.35),
      Paint()..color = const Color(0xFF7EC850),
    );

    // Street
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.55, size.x, size.y * 0.12),
      Paint()..color = const Color(0xFF808080),
    );

    // House 1 (left)
    _drawHouse(canvas, 60, 120, 200, 220, const Color(0xFFF5DEB3));

    // House 2 (center)
    _drawHouse(canvas, 320, 100, 200, 240, const Color(0xFFDEB887));

    // House 3 (right)
    _drawHouse(canvas, 640, 130, 220, 210, const Color(0xFFE8D5B7));
  }

  void _drawHouse(Canvas canvas, double x, double y, double w, double h, Color color) {
    // Wall
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = color,
    );

    // Roof
    final roofPath = Path()
      ..moveTo(x - 15, y)
      ..lineTo(x + w / 2, y - 50)
      ..lineTo(x + w + 15, y)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = const Color(0xFF8B4513));

    // Door
    canvas.drawRect(
      Rect.fromLTWH(x + w / 2 - 15, y + h - 60, 30, 60),
      Paint()..color = const Color(0xFF654321),
    );

    // Windows
    final windowPaint = Paint()..color = const Color(0xFF87CEEB);
    canvas.drawRect(Rect.fromLTWH(x + 20, y + 30, 35, 30), windowPaint);
    canvas.drawRect(Rect.fromLTWH(x + w - 55, y + 30, 35, 30), windowPaint);
  }
}
