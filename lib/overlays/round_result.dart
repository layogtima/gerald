import 'package:flutter/material.dart';

import '../game.dart';

class RoundResultOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundResultOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final config = game.currentConfig;
    final passed = game.reportsFiledThisRound >= config.quota;

    final accentColor = passed
        ? const Color(0xFFFFAA00)
        : const Color(0xFFFF4444);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xEE0a0a0a),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: accentColor, width: 1),
          boxShadow: [
            BoxShadow(color: accentColor.withAlpha(0x33), blurRadius: 16),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              passed ? 'SHIFT COMPLETE' : 'SHIFT FAILED',
              style: TextStyle(
                color: accentColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Reports Filed: ${game.reportsFiledThisRound}/${config.quota}',
              style: const TextStyle(
                color: Color(0xCCFFAA00),
                fontSize: 18,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              passed
                  ? 'Gerald approves. The neighborhood is "safer."'
                  : 'Insufficient vigilance detected.',
              style: TextStyle(
                color: accentColor.withAlpha(0x99),
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => game.onRoundResultDismissed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: const Color(0xFF0a0a0a),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
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
