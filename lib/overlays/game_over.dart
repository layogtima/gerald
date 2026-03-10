import 'package:flutter/material.dart';

import '../game.dart';

class GameOverWinOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const GameOverWinOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return _GameOverBase(
      game: game,
      title: 'CAPTAIN OF THE YEAR',
      subtitle: 'All 5 shifts completed. The neighborhood is... "safe."',
      titleColor: const Color(0xFFFFD700),
      score: game.score,
    );
  }
}

class GameOverLoseOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const GameOverLoseOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return _GameOverBase(
      game: game,
      title: 'PARKING SPOT REVOKED',
      subtitle:
          'Your parking spot has been reassigned to Brenda.\nYou failed at Shift ${game.currentRound + 1}.',
      titleColor: const Color(0xFFF44336),
      score: game.score,
    );
  }
}

class _GameOverBase extends StatelessWidget {
  final NeighborhoodWatchGame game;
  final String title;
  final String subtitle;
  final Color titleColor;
  final int score;

  const _GameOverBase({
    required this.game,
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xEE1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: titleColor, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xAAFFFFFF),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Final Score: $score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => game.returnToMenu(),
              style: ElevatedButton.styleFrom(
                backgroundColor: titleColor,
                foregroundColor: const Color(0xFF1A1A2E),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
