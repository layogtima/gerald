import 'dart:math';

import 'package:flutter/material.dart';

import '../game.dart';

/// Between-shift intro: Gerald's internal monologue before starting a shift.
/// Escalates with shift count and tension. Sets the mood.
class RoundIntroOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundIntroOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final shift = game.currentRound;
    final tension = game.tension;
    final monologue = _getMonologue(shift, tension);
    final shiftLabel = shift == 0 ? 'FIRST SHIFT' : 'SHIFT ${shift + 1}';

    return Container(
      color: const Color(0xEE000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Shift label
            Text(
              shiftLabel,
              style: TextStyle(
                color: Color.lerp(
                  const Color(0xFFFFAA00),
                  const Color(0xFFFF4444),
                  (tension / 120).clamp(0.0, 1.0),
                )!,
                fontSize: 11,
                fontFamily: 'monospace',
                letterSpacing: 6,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Gerald's monologue
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                monologue,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.lerp(
                    const Color(0xBBFFFFFF),
                    const Color(0xBBFFCCCC),
                    (tension / 100).clamp(0.0, 1.0),
                  )!,
                  fontSize: 13,
                  fontFamily: 'monospace',
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Start button
            GestureDetector(
              onTap: () => game.beginPlaying(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(
                    color: Color.lerp(
                      const Color(0xFFFFAA00),
                      const Color(0xFFFF4444),
                      (tension / 120).clamp(0.0, 1.0),
                    )!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(
                        const Color(0x66FFAA00),
                        const Color(0x66FF4444),
                        (tension / 120).clamp(0.0, 1.0),
                      )!,
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  _getButtonText(shift, tension),
                  style: TextStyle(
                    color: Color.lerp(
                      const Color(0xFFFFCC44),
                      const Color(0xFFFF8888),
                      (tension / 120).clamp(0.0, 1.0),
                    )!,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText(int shift, int tension) {
    if (shift == 0) return 'START WATCHING';
    if (tension < 30) return 'RESUME WATCH';
    if (tension < 60) return 'KEEP WATCHING';
    if (tension < 90) return 'WATCH HARDER';
    return 'CANNOT STOP';
  }

  String _getMonologue(int shift, int tension) {
    if (shift == 0) {
      return _pick([
        'The binoculars are clean. The notebook is open.\nThe street doesn\'t know it\'s being watched yet.',
        'They gave me one job.\nWatch the street. Report what I see.\nI intend to do it thoroughly.',
        'Everyone\'s out there living their lives.\nThey have no idea someone is paying attention.\nThat changes tonight.',
      ]);
    }

    if (shift == 1 && tension < 15) {
      return _pick([
        'First shift went well. Professional.\nBut something about the way that neighbor looked at the sky...\nNever mind. Focus.',
        'Back at the window. The street looks the same.\nBut I\'ve been thinking about what I saw.\nSome of it doesn\'t add up.',
      ]);
    }

    if (shift <= 2 && tension < 30) {
      return _pick([
        'The Council trusts me to be thorough.\nI will not let them down.',
        'Another shift. Another chance to notice\nwhat everyone else misses.',
        'I keep my notes organized.\nDate. Time. Activity. Assessment.\nThe Council expects nothing less.',
      ]);
    }

    if (shift <= 4 && tension < 50) {
      return _pick([
        'The patterns are there if you look hard enough.\nI\'m looking hard enough.',
        'I\'ve started keeping a second notebook.\nThe first one is full.',
        'The neighbors smile at each other\nlike people who share a secret.\nI will find out what it is.',
        'My coffee is cold. I don\'t remember making it.\nDoesn\'t matter. The street needs me.',
      ]);
    }

    if (tension < 70) {
      return _pick([
        'I haven\'t left this window in... how long?\nDoesn\'t matter. Something is happening out there\nand I\'m the only one who sees it.',
        'I moved the chair closer to the window.\nThen I moved it closer again.\nNow it\'s touching the glass.',
        'The Council hasn\'t written back.\nMaybe the mail is being intercepted.\nI should watch the mailman more carefully.',
        'I dreamed about the street last night.\nExcept in the dream, the street was watching me.\nI woke up and checked. It wasn\'t.',
      ]);
    }

    if (tension < 100) {
      return _pick([
        'They changed something about the street.\nI can\'t tell what, but it\'s different.\nI can feel it.',
        'I taped the binoculars to my face\nso I can\'t look away.\nThis is what commitment looks like.',
        'The streetlights blinked.\nAll of them. At the same time.\nThat\'s not how streetlights work.',
        'I found one of my own reports\nunder the door this morning.\nI don\'t remember sliding it there.',
      ]);
    }

    return _pick([
      'The street knows I\'m here.\nThe street has always known.\nWe watch each other now.',
      'I can\'t remember what the street looked like\nbefore I started watching.\nMaybe it didn\'t exist before I started watching.',
      'If I stop looking, does the street disappear?\nI\'m not going to find out.\nI\'m never going to find out.',
      'Gerald watches the street.\nThe street watches Gerald.\nSomewhere, someone watches them both.',
      'I am the last watcher.\nOr the first.\nI can no longer tell the difference.',
    ]);
  }

  String _pick(List<String> options) {
    return options[Random().nextInt(options.length)];
  }
}
