import 'package:flutter/material.dart';

import '../game.dart';

class RoundResultOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundResultOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final config = game.currentConfig;
    final passed = game.reportsFiledThisRound >= config.quota;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xEE1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: passed ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              passed ? 'SHIFT COMPLETE' : 'SHIFT FAILED',
              style: TextStyle(
                color: passed
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFF44336),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Reports Filed: ${game.reportsFiledThisRound}/${config.quota}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              passed
                  ? 'Gerald approves. The neighborhood is "safer."'
                  : 'Insufficient vigilance detected.',
              style: const TextStyle(
                color: Color(0xAAFFFFFF),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => game.onRoundResultDismissed(),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    passed ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(passed ? 'NEXT SHIFT' : 'FACE THE CONSEQUENCES'),
            ),
          ],
        ),
      ),
    );
  }
}
