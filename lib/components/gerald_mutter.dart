import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Atmospheric Gerald mutter text at the bottom of screen.
/// Blends story mutters with tension-reactive mutters.
class GeraldMutterComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  final Random _random = Random();
  double _timer = 0;
  double _nextMutterDelay = 3.0;
  String _currentMutter = '';
  double _mutterOpacity = 0;
  double _mutterLife = 0;

  static const _boredMutters = [
    '...',
    'Slow night.',
    'Maybe I should get a hobby.',
    'The most exciting thing is a cloud.',
    'Nothing to report. Literally nothing.',
    "I'm watching grass grow. Literally.",
  ];

  static const _panicMutters = [
    'They know.',
    'THEY ALL KNOW.',
    'I need more binoculars.',
    'Is that a camera pointed at me?!',
    'The walls have eyes. MY walls.',
    "Trust no one. Especially the twins.",
    'Every shadow is a suspect.',
  ];

  @override
  Future<void> onLoad() async {
    // Positioned in viewport space (bottom center)
    position = Vector2(
      NeighborhoodWatchGame.gameWidth / 2,
      game.gameHeight - 60,
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
      _currentMutter = _pickMutter();
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

  String _pickMutter() {
    final storyMutters = game.currentStory.mutters;
    final tension = game.tension;

    // 70% story mutters, 30% tension-reactive
    if (_random.nextDouble() < 0.3) {
      if (tension < 20) {
        return _boredMutters[_random.nextInt(_boredMutters.length)];
      } else if (tension > 60) {
        return _panicMutters[_random.nextInt(_panicMutters.length)];
      }
    }
    return storyMutters[_random.nextInt(storyMutters.length)];
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
