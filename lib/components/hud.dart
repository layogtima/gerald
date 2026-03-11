import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../game.dart';

/// Minimal HUD — completely stripped. Just binoculars (separate overlay).
class HudComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, game.gameHeight);
    priority = 200;
  }

  @override
  void render(ui.Canvas canvas) {
    // Intentionally empty — just binoculars and CRT overlay handle the look
  }
}
