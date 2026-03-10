import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// HUD overlay showing score, timer, quota, and round number.
/// Rendered in viewport space (always on screen).
class HudComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, NeighborhoodWatchGame.gameHeight);
    priority = 200;
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
      ui.Rect.fromLTWH(0, 0, size.x, 40),
      ui.Paint()..color = const ui.Color(0xAA000000),
    );

    // Round indicator
    _drawText(canvas, 'SHIFT ${game.currentRound + 1}/5',
        const ui.Offset(16, 10), 18, const ui.Color(0xFFFFD700));

    // Timer
    final minutes = (game.roundTimeRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (game.roundTimeRemaining.toInt() % 60).toString().padLeft(2, '0');
    _drawText(
      canvas,
      '$minutes:$seconds',
      ui.Offset(size.x / 2 - 30, 10),
      20,
      game.roundTimeRemaining <= 15
          ? const ui.Color(0xFFFF4444)
          : const ui.Color(0xFFFFFFFF),
    );

    // Score
    _drawText(canvas, 'Score: ${game.score}',
        ui.Offset(size.x - 380, 10), 18, const ui.Color(0xFFFFFFFF));

    // Quota
    final quotaMet = game.reportsFiledThisRound >= config.quota;
    _drawText(
      canvas,
      'Reports: ${game.reportsFiledThisRound}/${config.quota}',
      ui.Offset(size.x - 200, 10),
      18,
      quotaMet ? const ui.Color(0xFF4CAF50) : const ui.Color(0xFFFFFFFF),
    );
  }

  void _drawText(ui.Canvas canvas, String text, ui.Offset offset, double fontSize, ui.Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }
}
