import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// CRT-styled HUD with REC indicator, VCR timestamp, and game stats.
/// Rendered in viewport space.
class HudComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  double _elapsed = 0;

  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, NeighborhoodWatchGame.gameHeight);
    priority = 200;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
  }

  @override
  void render(ui.Canvas canvas) {
    if (game.gameState != GameState.playing &&
        game.gameState != GameState.reportOpen) {
      return;
    }

    final config = game.currentConfig;

    // Semi-transparent bar at top
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, size.x, 36),
      ui.Paint()..color = const ui.Color(0x88000000),
    );

    // Semi-transparent bar at bottom
    canvas.drawRect(
      ui.Rect.fromLTWH(0, size.y - 30, size.x, 30),
      ui.Paint()..color = const ui.Color(0x88000000),
    );

    // --- Top bar ---

    // REC indicator (pulsing red dot)
    final recVisible = (sin(_elapsed * 2.5) > -0.3);
    if (recVisible) {
      canvas.drawCircle(
        const ui.Offset(20, 18),
        5,
        ui.Paint()..color = const ui.Color(0xFFFF0000),
      );
      _drawText(canvas, 'REC', const ui.Offset(30, 9), 16,
          const ui.Color(0xFFFF0000));
    }

    // Shift indicator
    _drawText(canvas, 'SHIFT ${game.currentRound + 1}/5',
        const ui.Offset(80, 9), 16, const ui.Color(0xFFFFAA00));

    // Timer (center)
    final minutes = (game.roundTimeRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (game.roundTimeRemaining.toInt() % 60).toString().padLeft(2, '0');
    final timerColor = game.roundTimeRemaining <= 15
        ? const ui.Color(0xFFFF4444)
        : const ui.Color(0xFFFFAA00);
    _drawText(
        canvas, '$minutes:$seconds', ui.Offset(size.x / 2 - 25, 9), 18, timerColor);

    // Score
    _drawText(canvas, 'SCORE: ${game.score}',
        ui.Offset(size.x - 340, 9), 16, const ui.Color(0xFFFFAA00));

    // Quota
    final quotaMet = game.reportsFiledThisRound >= config.quota;
    _drawText(
      canvas,
      'REPORTS: ${game.reportsFiledThisRound}/${config.quota}',
      ui.Offset(size.x - 190, 9),
      16,
      quotaMet ? const ui.Color(0xFFFFCC44) : const ui.Color(0xFFFFAA00),
    );

    // --- Bottom bar ---

    // VCR timestamp
    final now = DateTime.now();
    final timestamp =
        '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}'
        '  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _drawText(canvas, timestamp, ui.Offset(size.x - 210, size.y - 24), 14,
        const ui.Color(0x88FFFFFF));

    // Camera label
    _drawText(canvas, 'CAM 01 - GERALD', ui.Offset(10, size.y - 24), 14,
        const ui.Color(0x88FFFFFF));
  }

  void _drawText(ui.Canvas canvas, String text, ui.Offset offset,
      double fontSize, ui.Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          letterSpacing: 1.5,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }
}
