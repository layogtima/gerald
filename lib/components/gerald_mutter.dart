import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Atmospheric Gerald mutter text at the bottom of screen.
class GeraldMutterComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  static const _mutters = [
    'Hmm...',
    'Suspicious...',
    'I knew it.',
    'Classic.',
    'Very interesting...',
    'Nobody fools Gerald.',
    "That's going in the report.",
    'Noted.',
    'Highly irregular.',
    'Trust no one.',
  ];

  final Random _random = Random();
  double _timer = 0;
  double _nextMutterDelay = 3.0;
  String _currentMutter = '';
  double _mutterOpacity = 0;
  double _mutterLife = 0;

  @override
  Future<void> onLoad() async {
    // Positioned in viewport space (bottom center)
    position = Vector2(
      NeighborhoodWatchGame.gameWidth / 2,
      NeighborhoodWatchGame.gameHeight - 60,
    );
    priority = 180;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState != GameState.playing) return;

    _timer += dt;
    if (_timer >= _nextMutterDelay && _mutterOpacity <= 0) {
      _timer = 0;
      _nextMutterDelay = 4.0 + _random.nextDouble() * 4.0;
      _currentMutter = _mutters[_random.nextInt(_mutters.length)];
      _mutterOpacity = 1.0;
      _mutterLife = 0;
    }

    if (_mutterOpacity > 0) {
      _mutterLife += dt;
      if (_mutterLife > 2.0) {
        _mutterOpacity -= dt * 2;
        if (_mutterOpacity < 0) _mutterOpacity = 0;
      }
    }
  }

  @override
  void render(ui.Canvas canvas) {
    if (_mutterOpacity <= 0 || _currentMutter.isEmpty) return;

    final painter = TextPainter(
      text: TextSpan(
        text: '\u2014 "$_currentMutter"',
        style: TextStyle(
          color: ui.Color.fromRGBO(255, 170, 0, _mutterOpacity * 0.6),
          fontSize: 14,
          fontStyle: FontStyle.italic,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    painter.paint(canvas, ui.Offset(-painter.width / 2, 0));
  }
}
