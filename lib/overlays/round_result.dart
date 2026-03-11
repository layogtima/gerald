import 'package:flutter/material.dart';

import '../data/story.dart';
import '../game.dart';

/// Shift result styled as a performance review document.
class RoundResultOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundResultOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final config = game.currentConfig;
    final passed = game.reportsFiledThisRound >= config.quota;
    final story = shiftStories[game.currentRound];

    final stampColor =
        passed ? const Color(0xFF2E6B35) : const Color(0xFF8B1A1A);
    final stampText = passed ? 'APPROVED' : 'REJECTED';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 400),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'PERFORMANCE REVIEW',
                style: TextStyle(
                  color: Color(0xFF2A1A0A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
            const Divider(color: Color(0xFFC4A882), thickness: 1),
            const SizedBox(height: 12),
            Text(
              'Reports Filed: ${game.reportsFiledThisRound}/${config.quota}',
              style: const TextStyle(
                color: Color(0xFF2A1A0A),
                fontSize: 16,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              passed ? story.debriefPass : story.debriefFail,
              style: const TextStyle(
                color: Color(0xFF8B7355),
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            // Stamp
            Center(
              child: Transform.rotate(
                angle: -0.05,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: stampColor, width: 3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    stampText,
                    style: TextStyle(
                      color: stampColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => game.onRoundResultDismissed(),
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
                child: Text(passed ? 'NEXT SHIFT' : 'FACE THE CONSEQUENCES'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
