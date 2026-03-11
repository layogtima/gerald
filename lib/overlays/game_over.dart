import 'package:flutter/material.dart';

import '../data/story.dart';
import '../game.dart';

class GameOverWinOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const GameOverWinOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final story = shiftStories[5]; // Act 3 final shift
    return _GameOverBase(
      game: game,
      title: 'THE WATCHER BECOMES THE WATCHED',
      subtitle: story.debriefPass,
      stampText: 'CASE CLOSED',
      stampColor: const Color(0xFF2E6B35),
      score: game.score,
    );
  }
}

class GameOverLoseOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const GameOverLoseOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final act = actForShift(game.currentRound);
    final subtitle = act >= 3
        ? 'The neighbors have won. Gerald\'s surveillance career is over.\nYou failed at Shift ${game.currentRound}.'
        : 'Your parking spot has been reassigned to Brenda.\nYou failed at Shift ${game.currentRound}.';
    return _GameOverBase(
      game: game,
      title: 'PARKING SPOT REVOKED',
      subtitle: subtitle,
      stampText: 'TERMINATED',
      stampColor: const Color(0xFF8B1A1A),
      score: game.score,
    );
  }
}

class _GameOverBase extends StatelessWidget {
  final NeighborhoodWatchGame game;
  final String title;
  final String subtitle;
  final String stampText;
  final Color stampColor;
  final int score;

  const _GameOverBase({
    required this.game,
    required this.title,
    required this.subtitle,
    required this.stampText,
    required this.stampColor,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6C8),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFF8B7355), width: 1.5),
          boxShadow: const [
            BoxShadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'OFFICIAL NOTICE',
              style: TextStyle(
                color: Color(0xFF2A1A0A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 3,
              ),
            ),
            const Divider(color: Color(0xFFC4A882), thickness: 1),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF2A1A0A),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5A4A3A),
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Final Score: $score',
              style: const TextStyle(
                color: Color(0xFF2A1A0A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            // Stamp
            Transform.rotate(
              angle: -0.06,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: stampColor, width: 3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  stampText,
                  style: TextStyle(
                    color: stampColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => game.returnToMenu(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A1A0A),
                foregroundColor: const Color(0xFFF5E6C8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              child: const Text('BACK TO MENU'),
            ),
          ],
        ),
      ),
    );
  }
}
