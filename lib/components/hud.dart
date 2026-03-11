import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// HUD with vision mode toggle + evidence board button.
/// Rendered in viewport space at highest priority.
class HudComponent extends PositionComponent
    with TapCallbacks, HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, game.gameHeight);
    priority = 200;
  }

  // Button hit areas
  ui.Rect get _visionButtonRect =>
      ui.Rect.fromLTWH(16, size.y - 56, 40, 40);
  ui.Rect get _evidenceButtonRect =>
      ui.Rect.fromLTWH(66, size.y - 56, 40, 40);

  @override
  void onTapUp(TapUpEvent event) {
    if (game.gameState != GameState.playing) return;

    final pos = event.localPosition;
    if (_visionButtonRect.contains(ui.Offset(pos.x, pos.y))) {
      game.cycleVisionMode();
    } else if (_evidenceButtonRect.contains(ui.Offset(pos.x, pos.y))) {
      game.openEvidenceBoard();
    }
  }

  @override
  void render(ui.Canvas canvas) {
    if (game.gameState != GameState.playing &&
        game.gameState != GameState.reportOpen) {
      return;
    }

    // Vision mode button (bottom-left)
    _drawButton(
      canvas,
      _visionButtonRect,
      _visionIcon,
      _visionColor,
    );

    // Evidence board button (next to vision)
    final evidenceCount = game.evidencePhotos.length;
    _drawButton(
      canvas,
      _evidenceButtonRect,
      '\ud83d\udcf7',
      const ui.Color(0xAAFFAA00),
      badge: evidenceCount > 0 ? '$evidenceCount' : null,
    );

    // Shift timer (top-center)
    if (game.gameState == GameState.playing) {
      final secs = game.roundTimeRemaining.ceil();
      final timerColor = secs <= 10
          ? const ui.Color(0xCCFF4444)
          : secs <= 30
              ? const ui.Color(0xCCFFAA00)
              : const ui.Color(0x88FFFFFF);
      final tp = TextPainter(
        text: TextSpan(
          text: '${secs}s',
          style: TextStyle(
            color: timerColor,
            fontSize: 14,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, ui.Offset((size.x - tp.width) / 2, 12));

      // Shift label
      final shiftTp = TextPainter(
        text: TextSpan(
          text: 'SHIFT ${game.currentRound + 1}',
          style: const TextStyle(
            color: ui.Color(0x55FFFFFF),
            fontSize: 8,
            fontFamily: 'monospace',
            letterSpacing: 2,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      shiftTp.paint(canvas, ui.Offset((size.x - shiftTp.width) / 2, 28));
    }
  }

  String get _visionIcon {
    switch (game.visionMode) {
      case VisionMode.normal:
        return '\ud83d\udc41\ufe0f';
      case VisionMode.nightVision:
        return '\ud83d\udfe2';
      case VisionMode.thermal:
        return '\ud83d\udd34';
    }
  }

  ui.Color get _visionColor {
    switch (game.visionMode) {
      case VisionMode.normal:
        return const ui.Color(0xAAFFFFFF);
      case VisionMode.nightVision:
        return const ui.Color(0xAA00FF00);
      case VisionMode.thermal:
        return const ui.Color(0xAAFF4444);
    }
  }

  void _drawButton(
    ui.Canvas canvas,
    ui.Rect rect,
    String icon,
    ui.Color tint, {
    String? badge,
  }) {
    // Background
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(rect, const ui.Radius.circular(6)),
      ui.Paint()..color = const ui.Color(0x44000000),
    );
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(rect, const ui.Radius.circular(6)),
      ui.Paint()
        ..color = tint.withAlpha(60)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Icon
    final tp = TextPainter(
      text: TextSpan(
        text: icon,
        style: const TextStyle(fontSize: 20),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      ui.Offset(
        rect.left + (rect.width - tp.width) / 2,
        rect.top + (rect.height - tp.height) / 2,
      ),
    );

    // Badge (count indicator)
    if (badge != null) {
      final badgeTp = TextPainter(
        text: TextSpan(
          text: badge,
          style: const TextStyle(
            color: ui.Color(0xFFFFFFFF),
            fontSize: 8,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      final badgeRect = ui.Rect.fromCenter(
        center: ui.Offset(rect.right - 2, rect.top + 2),
        width: badgeTp.width + 6,
        height: 12,
      );
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(badgeRect, const ui.Radius.circular(6)),
        ui.Paint()..color = const ui.Color(0xDDFF4444),
      );
      badgeTp.paint(
        canvas,
        ui.Offset(badgeRect.left + 3, badgeRect.top + 1),
      );
    }
  }
}
