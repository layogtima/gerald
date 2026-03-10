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

  Npc({
    required this.activityData,
    required this.visibilitySeconds,
    required this.parentZone,
  }) : super(size: Vector2(80, 100));

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
    final color = (_activityColors[activityData.activity] ?? const ui.Color(0xFF9E9E9E))
        .withAlpha(alpha);

    // Body (placeholder rectangle)
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(size.toRect(), const ui.Radius.circular(8)),
      ui.Paint()..color = color,
    );

    // Head (circle on top)
    canvas.drawCircle(
      ui.Offset(size.x / 2, -5),
      18,
      ui.Paint()..color = const ui.Color(0xFFFFE0BD).withAlpha(alpha),
    );

    // Timer bar at bottom
    if (!_frozen) {
      final fraction = 1.0 - (_timer / visibilitySeconds).clamp(0.0, 1.0);
      canvas.drawRect(
        ui.Rect.fromLTWH(0, size.y + 4, size.x, 4),
        ui.Paint()..color = const ui.Color(0x44000000),
      );
      canvas.drawRect(
        ui.Rect.fromLTWH(0, size.y + 4, size.x * fraction, 4),
        ui.Paint()
          ..color = fraction > 0.3
              ? const ui.Color(0xFF4CAF50)
              : const ui.Color(0xFFF44336),
      );
    }

    // Activity icon indicator
    final textPainter = TextPainter(
      text: TextSpan(
        text: '!',
        style: TextStyle(
          color: ui.Color.fromARGB(alpha, 255, 255, 255),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, ui.Offset(size.x / 2 - 5, size.y / 2 - 14));
  }
}
