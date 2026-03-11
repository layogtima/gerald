import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

import '../data/reports.dart';
import '../data/zone_type.dart';
import '../game.dart';
import 'observation_zone.dart';

/// An NPC that appears in a zone doing an activity.
/// Placeholder: colored rectangle with activity label.
class Npc extends PositionComponent
    with TapCallbacks, HasPaint, HasGameReference<NeighborhoodWatchGame> {
  final ActivityData activityData;
  final double visibilitySeconds;
  final ObservationZone parentZone;

  double _timer = 0;
  bool _frozen = false;
  bool _expired = false;

  bool get _isWindow => parentZone.zoneType == ZoneType.window;

  Npc({
    required this.activityData,
    required this.visibilitySeconds,
    required this.parentZone,
  }) : super();

  @override
  Future<void> onLoad() async {
    // Window NPCs are smaller (head + upper body)
    size = _isWindow ? Vector2(60, 65) : Vector2(100, 110);

    // Center in zone
    position = Vector2(
      (parentZone.size.x - size.x) / 2,
      (parentZone.size.y - size.y) / 2,
    );

    // Fade in using paint opacity
    paint.color = const ui.Color(0x00FFFFFF);
    add(OpacityEffect.to(
      1.0,
      EffectController(duration: 0.3),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_frozen || _expired) return;

    _timer += dt;
    if (_timer >= visibilitySeconds) {
      _expire();
    }
  }

  void freezeTimer() {
    _frozen = true;
  }

  void unfreezeTimer() {
    _frozen = false;
  }

  void _expire() {
    _expired = true;
    game.onNpcExpired(this);

    // Fade out then remove
    add(OpacityEffect.to(
      0.0,
      EffectController(duration: 0.3),
      onComplete: () {
        parentZone.onNpcRemoved();
        removeFromParent();
      },
    ));
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_expired) return;
    game.onNpcTapped(this);
  }

  @override
  void render(ui.Canvas canvas) {
    final alpha = (paint.color.a * 255).round().clamp(0, 255);
    final color = activityData.color.withAlpha(alpha);

    // Frozen indicator glow (blue)
    if (_frozen) {
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(
          ui.Rect.fromLTWH(-4, -9, size.x + 8, size.y + 14),
          const ui.Radius.circular(14),
        ),
        ui.Paint()
          ..color = const ui.Color(0xFF42A5F5).withAlpha(alpha ~/ 2)
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8),
      );
    }

    // Body (placeholder rectangle)
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(size.toRect(), const ui.Radius.circular(8)),
      ui.Paint()..color = color,
    );

    // Body outline
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(size.toRect(), const ui.Radius.circular(8)),
      ui.Paint()
        ..color = ui.Color.fromARGB(alpha, 0, 0, 0)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = _isWindow ? 1.5 : 2,
    );

    // Head (circle on top)
    final headRadius = _isWindow ? 12.0 : 18.0;
    canvas.drawCircle(
      ui.Offset(size.x / 2, -headRadius * 0.28),
      headRadius,
      ui.Paint()..color = const ui.Color(0xFFFFE0BD).withAlpha(alpha),
    );
    canvas.drawCircle(
      ui.Offset(size.x / 2, -headRadius * 0.28),
      headRadius,
      ui.Paint()
        ..color = ui.Color.fromARGB(alpha, 0, 0, 0)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Activity emoji indicator
    final emojiFontSize = _isWindow ? 18.0 : 28.0;
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: activityData.emoji,
        style: TextStyle(
          fontSize: emojiFontSize,
          color: ui.Color.fromARGB(alpha, 255, 255, 255),
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    emojiPainter.paint(
      canvas,
      ui.Offset(size.x / 2 - emojiPainter.width / 2, size.y * 0.15),
    );

    // Activity name label below
    final labelFontSize = _isWindow ? 7.0 : 9.0;
    final labelPainter = TextPainter(
      text: TextSpan(
        text: activityData.displayName,
        style: TextStyle(
          color: ui.Color.fromARGB(alpha, 255, 255, 255),
          fontSize: labelFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      textAlign: ui.TextAlign.center,
    )..layout(maxWidth: size.x);
    labelPainter.paint(
      canvas,
      ui.Offset(size.x / 2 - labelPainter.width / 2, size.y * 0.6),
    );

  }
}
