import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Gerald mutter — only shows during/after choices, vague and atmospheric.
class GeraldMutterComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  final Random _random = Random();
  String _currentMutter = '';
  double _mutterOpacity = 0;
  double _mutterLife = 0;
  bool _wasReportOpen = false;

  // Shown when clipboard opens (atmospheric)
  static const _observingMutters = [
    'Gerald steadies the binoculars...',
    'Gerald leans forward...',
    'Gerald squints...',
    'The lens fogs slightly...',
    'Gerald adjusts the focus...',
    'Gerald holds his breath...',
    'A long pause...',
  ];

  // Shown after a choice (vague reactions)
  static const _afterChoiceMild = [
    'Hmm.',
    '...noted.',
    'Moving on.',
    '...',
  ];

  static const _afterChoiceHigh = [
    'I knew it.',
    'This changes things.',
    'They have no idea.',
    'The file grows thicker.',
    'Interesting.',
  ];

  @override
  Future<void> onLoad() async {
    position = Vector2(
      NeighborhoodWatchGame.gameWidth / 2,
      game.gameHeight - 60,
    );
    priority = 180;
  }

  /// Called by game after a report is filed
  void triggerReaction(int tension) {
    if (tension <= 2) {
      _currentMutter = _afterChoiceMild[_random.nextInt(_afterChoiceMild.length)];
    } else {
      _currentMutter = _afterChoiceHigh[_random.nextInt(_afterChoiceHigh.length)];
    }
    _mutterOpacity = 1.0;
    _mutterLife = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Trigger observing mutter when clipboard first opens
    final isReportOpen = game.gameState == GameState.reportOpen;
    if (isReportOpen && !_wasReportOpen) {
      _currentMutter = _observingMutters[_random.nextInt(_observingMutters.length)];
      _mutterOpacity = 1.0;
      _mutterLife = 0;
    }
    _wasReportOpen = isReportOpen;

    // Fade out after 2.5s
    if (_mutterOpacity > 0) {
      _mutterLife += dt;
      if (_mutterLife > 2.5) {
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
        text: _currentMutter,
        style: TextStyle(
          color: ui.Color.fromRGBO(255, 170, 0, _mutterOpacity * 0.5),
          fontSize: 13,
          fontStyle: FontStyle.italic,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    painter.paint(canvas, ui.Offset(-painter.width / 2, 0));
  }
}
