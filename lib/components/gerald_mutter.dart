import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../game.dart';

/// Gerald mutters brief reactions in viewport space.
/// Triggered by report filing, NPC expiry, and ambient paranoia.
class GeraldMutterComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  final Random _random = Random();
  double _ambientTimer = 0;
  double _nextAmbientDelay = 15.0;
  String? _currentText;
  double _textOpacity = 0;
  double _textTimer = 0;
  static const double _displayDuration = 3.0;
  static const double _fadeInDuration = 0.3;
  static const double _fadeOutDuration = 0.8;

  @override
  Future<void> onLoad() async {
    size = Vector2(NeighborhoodWatchGame.gameWidth, game.gameHeight);
    priority = 180; // Above CRT, below HUD
  }

  /// Called after filing a report.
  void triggerReaction(int tension) {
    if (tension < 10) {
      _show(_pick(_lowTensionReactions));
    } else if (tension < 40) {
      _show(_pick(_midTensionReactions));
    } else if (tension < 75) {
      _show(_pick(_highTensionReactions));
    } else {
      _show(_pick(_extremeTensionReactions));
    }
  }

  /// Called when an NPC expires unobserved.
  void triggerMissed() {
    _show(_pick(_missedReactions));
  }

  /// Called on dismissing without filing.
  void triggerDismiss() {
    _show(_pick(_dismissReactions));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState != GameState.playing) return;

    // Animate current text
    if (_currentText != null) {
      _textTimer += dt;
      if (_textTimer < _fadeInDuration) {
        _textOpacity = (_textTimer / _fadeInDuration).clamp(0.0, 1.0);
      } else if (_textTimer < _displayDuration - _fadeOutDuration) {
        _textOpacity = 1.0;
      } else if (_textTimer < _displayDuration) {
        _textOpacity = ((_displayDuration - _textTimer) / _fadeOutDuration)
            .clamp(0.0, 1.0);
      } else {
        _currentText = null;
        _textOpacity = 0;
      }
    }

    // Ambient muttering (less frequent at low tension, more at high)
    _ambientTimer += dt;
    if (_ambientTimer >= _nextAmbientDelay && _currentText == null) {
      _ambientTimer = 0;
      final tension = game.tension;
      // Higher tension = more frequent muttering
      _nextAmbientDelay = tension < 30
          ? 20.0 + _random.nextDouble() * 15.0
          : tension < 60
              ? 12.0 + _random.nextDouble() * 10.0
              : 6.0 + _random.nextDouble() * 6.0;

      if (tension < 20) {
        _show(_pick(_ambientCalm));
      } else if (tension < 50) {
        _show(_pick(_ambientUneasy));
      } else if (tension < 80) {
        _show(_pick(_ambientParanoid));
      } else {
        _show(_pick(_ambientUnhinged));
      }
    }
  }

  void _show(String text) {
    _currentText = text;
    _textTimer = 0;
    _textOpacity = 0;
  }

  @override
  void render(ui.Canvas canvas) {
    if (_currentText == null || _textOpacity <= 0) return;

    final alpha = (_textOpacity * 200).round().clamp(0, 255);

    final tp = TextPainter(
      text: TextSpan(
        text: _currentText,
        style: TextStyle(
          color: ui.Color.fromARGB(alpha, 255, 220, 160),
          fontSize: 11,
          fontFamily: 'monospace',
          fontStyle: FontStyle.italic,
          shadows: [
            Shadow(
              color: ui.Color.fromARGB(alpha ~/ 2, 0, 0, 0),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      textAlign: ui.TextAlign.center,
    )..layout(maxWidth: size.x * 0.7);

    // Position at bottom-center, above the report UI area
    final x = (size.x - tp.width) / 2;
    final y = size.y * 0.78;
    tp.paint(canvas, ui.Offset(x, y));
  }

  String _pick(List<String> options) {
    return options[_random.nextInt(options.length)];
  }

  // --- Reaction pools ---

  static const _lowTensionReactions = [
    'Noted.',
    'Into the file it goes.',
    'The Council will want to know.',
    'Perfectly routine.',
    'Standard procedure.',
    'One more for the records.',
  ];

  static const _midTensionReactions = [
    'Interesting. Very interesting.',
    'That\'s going in the special notebook.',
    'I knew something was off.',
    'The pattern is forming.',
    'They\'re not even trying to hide it.',
    'This confirms my suspicions.',
    'The Council needs to hear about this.',
  ];

  static const _highTensionReactions = [
    'This is bigger than I thought.',
    'They know I can see them.',
    'I need to document everything.',
    'Nobody believes me, but the evidence speaks.',
    'The connections are everywhere.',
    'I was right. I was always right.',
    'How long has this been going on?',
  ];

  static const _extremeTensionReactions = [
    'Oh no. Oh no no no.',
    'It\'s all connected.',
    'They\'re watching me watch them.',
    'The reports... are they even being read?',
    'I can\'t stop now. I\'m too close.',
    'Gerald, focus. FOCUS.',
    'This is the one. This proves everything.',
  ];

  static const _missedReactions = [
    'Blast. They got away.',
    'Gone before I could report it.',
    'I need to be faster.',
    'What were they hiding?',
    'That one slipped through.',
    'They\'re getting more careful.',
  ];

  static const _dismissReactions = [
    'Nothing there. For now.',
    'Maybe next time.',
    'I\'ll let this one slide.',
    'Suspicious, but... no.',
    'Not enough evidence. Yet.',
  ];

  static const _ambientCalm = [
    'Quiet street tonight.',
    'The binoculars are steady.',
    'All normal so far.',
    'Just need to stay alert.',
    'Watch and wait. Watch and wait.',
  ];

  static const _ambientUneasy = [
    'Something feels different tonight.',
    'Did that shadow move?',
    'I should check the locks.',
    'The street is too quiet.',
    'Why isn\'t the Council writing back?',
    'My hands are shaking. Coffee.',
  ];

  static const _ambientParanoid = [
    'They\'re coordinating. I can feel it.',
    'The lights are blinking in a pattern.',
    'When did that house get a second chimney?',
    'I haven\'t slept in... what day is it?',
    'The mailbox. Something about the mailbox.',
    'Focus, Gerald. You\'re the last line.',
  ];

  static const _ambientUnhinged = [
    'The street is breathing.',
    'Am I the watcher or the watched?',
    'Gerald. Gerald. Gerald. That\'s my name, right?',
    'If I close my eyes, does it still exist?',
    'The binoculars are getting heavier.',
    'I see myself in every window.',
    'The reports are writing themselves now.',
  ];
}
