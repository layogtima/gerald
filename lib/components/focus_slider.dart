import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Focus slider — a draggable vertical slider visible when zoomed in.
/// Different focus levels reveal different "details" on NPCs.
/// Rendered in viewport space.
class FocusSliderComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  /// Current focus level: 0.0 = blurry, 0.5 = normal, 1.0 = enhanced
  double focusLevel = 0.5;

  /// Whether the slider is visible (only when zoomed in).
  bool visible = false;

  static const double _sliderHeight = 200;
  static const double _sliderWidth = 6;
  static const double _knobRadius = 10;

  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, game.gameHeight);
    priority = 175; // Above CRT, below HUD
  }

  @override
  void render(ui.Canvas canvas) {
    if (!visible) return;

    final x = size.x - 40; // Right side of screen
    final topY = (size.y - _sliderHeight) / 2;

    // Track background
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(x - _sliderWidth / 2, topY, _sliderWidth, _sliderHeight),
        const ui.Radius.circular(3),
      ),
      ui.Paint()..color = const ui.Color(0x44FFFFFF),
    );

    // Focus zones (three color bands)
    final zoneHeight = _sliderHeight / 3;

    // Bottom zone — blurry (red)
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(x - _sliderWidth / 2, topY + zoneHeight * 2, _sliderWidth, zoneHeight),
        const ui.Radius.circular(3),
      ),
      ui.Paint()..color = const ui.Color(0x22FF4444),
    );

    // Middle zone — normal (green)
    canvas.drawRect(
      ui.Rect.fromLTWH(x - _sliderWidth / 2, topY + zoneHeight, _sliderWidth, zoneHeight),
      ui.Paint()..color = const ui.Color(0x2244FF44),
    );

    // Top zone — enhanced (blue)
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(x - _sliderWidth / 2, topY, _sliderWidth, zoneHeight),
        const ui.Radius.circular(3),
      ),
      ui.Paint()..color = const ui.Color(0x224488FF),
    );

    // Labels
    _drawLabel(canvas, x + 16, topY + 8, 'ENHANCE', const ui.Color(0x884488FF));
    _drawLabel(canvas, x + 16, topY + zoneHeight + 8, 'NORMAL', const ui.Color(0x8844FF44));
    _drawLabel(canvas, x + 16, topY + zoneHeight * 2 + 8, 'BLURRY', const ui.Color(0x88FF4444));

    // Knob position (inverted: 1.0 = top, 0.0 = bottom)
    final knobY = topY + _sliderHeight * (1.0 - focusLevel);

    // Knob glow
    canvas.drawCircle(
      ui.Offset(x, knobY),
      _knobRadius + 4,
      ui.Paint()
        ..color = const ui.Color(0x33FFAA00)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6),
    );

    // Knob
    canvas.drawCircle(
      ui.Offset(x, knobY),
      _knobRadius,
      ui.Paint()..color = const ui.Color(0xDDFFAA00),
    );
    canvas.drawCircle(
      ui.Offset(x, knobY),
      _knobRadius,
      ui.Paint()
        ..color = const ui.Color(0xFF884400)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Knob inner indicator
    canvas.drawCircle(
      ui.Offset(x, knobY),
      3,
      ui.Paint()..color = const ui.Color(0xFF884400),
    );
  }

  void _drawLabel(ui.Canvas canvas, double x, double y, String text, ui.Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 7,
          fontFamily: 'monospace',
          letterSpacing: 1,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(canvas, ui.Offset(x, y));
  }

  /// Handle drag to adjust focus (called from game.dart pan handler).
  void onDrag(double deltaY) {
    if (!visible) return;
    focusLevel = (focusLevel + deltaY * 0.005).clamp(0.0, 1.0);
  }
}
