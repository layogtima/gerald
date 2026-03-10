import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

import '../data/reports.dart';
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
  double _pulsePhase = 0;

  // Colors for different activities (placeholder art)
  static const _activityColors = <Activity, ui.Color>{
    Activity.wateringPlants: ui.Color(0xFF4CAF50),
    Activity.carryingGroceries: ui.Color(0xFFFF9800),
    Activity.doingYoga: ui.Color(0xFF9C27B0),
    Activity.walkingDog: ui.Color(0xFF795548),
    Activity.readingOnPorch: ui.Color(0xFF2196F3),
    Activity.receivingPackage: ui.Color(0xFFFFEB3B),
    Activity.leavingHouseEarly: ui.Color(0xFF607D8B),
    Activity.barbecuing: ui.Color(0xFFF44336),
    Activity.washingCar: ui.Color(0xFF00BCD4),
    Activity.talkingOnPhone: ui.Color(0xFFE91E63),
  };

  // Activity emoji indicators
  static const _activityEmojis = <Activity, String>{
    Activity.wateringPlants: '🌱',
    Activity.carryingGroceries: '🛒',
    Activity.doingYoga: '🧘',
    Activity.walkingDog: '🐕',
    Activity.readingOnPorch: '📖',
    Activity.receivingPackage: '📦',
    Activity.leavingHouseEarly: '🌅',
    Activity.barbecuing: '🔥',
    Activity.washingCar: '🚗',
    Activity.talkingOnPhone: '📱',
  };

  Npc({
    required this.activityData,
    required this.visibilitySeconds,
    required this.parentZone,
  }) : super(size: Vector2(100, 110));

  @override
  Future<void> onLoad() async {
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

    // Always animate pulse
    _pulsePhase += dt * 3.5;

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
    final color = (_activityColors[activityData.activity] ??
            const ui.Color(0xFF9E9E9E))
        .withAlpha(alpha);

    // Pulsing glow ring behind NPC
    if (!_expired && !_frozen) {
      final pulse = (sin(_pulsePhase) + 1) / 2; // 0..1
      final glowAlpha = (pulse * 80 + 40).round().clamp(0, 255);
      final glowRadius = 4 + pulse * 4;
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(
          ui.Rect.fromLTWH(
            -glowRadius,
            -glowRadius - 5,
            size.x + glowRadius * 2,
            size.y + glowRadius * 2 + 10,
          ),
          ui.Radius.circular(12 + glowRadius),
        ),
        ui.Paint()
          ..color = color.withAlpha(glowAlpha)
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6),
      );
    }

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
        ..strokeWidth = 2,
    );

    // Head (circle on top)
    canvas.drawCircle(
      ui.Offset(size.x / 2, -5),
      18,
      ui.Paint()..color = const ui.Color(0xFFFFE0BD).withAlpha(alpha),
    );
    // Head outline
    canvas.drawCircle(
      ui.Offset(size.x / 2, -5),
      18,
      ui.Paint()
        ..color = ui.Color.fromARGB(alpha, 0, 0, 0)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Timer bar at bottom
    final fraction = 1.0 - (_timer / visibilitySeconds).clamp(0.0, 1.0);
    canvas.drawRect(
      ui.Rect.fromLTWH(0, size.y + 6, size.x, 5),
      ui.Paint()..color = ui.Color.fromARGB((alpha * 0.3).round(), 0, 0, 0),
    );
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(0, size.y + 6, size.x * fraction, 5),
        const ui.Radius.circular(2),
      ),
      ui.Paint()
        ..color = (fraction > 0.3
                ? const ui.Color(0xFF4CAF50)
                : const ui.Color(0xFFF44336))
            .withAlpha(alpha),
    );

    // Activity emoji indicator
    final emoji = _activityEmojis[activityData.activity] ?? '!';
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(
          fontSize: 28,
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
    final labelPainter = TextPainter(
      text: TextSpan(
        text: activityData.displayName,
        style: TextStyle(
          color: ui.Color.fromARGB(alpha, 255, 255, 255),
          fontSize: 9,
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

    // "TAP!" hint text
    if (!_frozen && !_expired) {
      final tapAlpha = ((sin(_pulsePhase * 1.5) + 1) / 2 * 180 + 50)
          .round()
          .clamp(0, 255);
      final tapPainter = TextPainter(
        text: TextSpan(
          text: 'TAP!',
          style: TextStyle(
            color: ui.Color.fromARGB(tapAlpha, 255, 255, 255),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tapPainter.paint(
        canvas,
        ui.Offset(size.x / 2 - tapPainter.width / 2, size.y * 0.82),
      );
    }
  }
}
