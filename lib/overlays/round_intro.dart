import 'package:flutter/material.dart';

import '../data/story.dart';
import '../game.dart';

/// Shift briefing styled as a dispatch memo document.
class RoundIntroOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundIntroOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final config = game.currentConfig;
    final story = shiftStories[game.currentRound];
    final shiftLabel =
        game.currentRound == 0 ? 'PROLOGUE' : 'SHIFT ${game.currentRound}';

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
                'DISPATCH MEMO',
                style: TextStyle(
                  color: Color(0xFF2A1A0A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 3,
                ),
              ),
            ),
            const Divider(color: Color(0xFFC4A882), thickness: 1),
            const SizedBox(height: 4),
            Center(
              child: Text(
                story.actTitle,
                style: const TextStyle(
                  color: Color(0xFF8B7355),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                shiftLabel,
                style: const TextStyle(
                  color: Color(0xFF2A1A0A),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'DURATION: ${config.roundDurationSeconds.toInt()} seconds',
              style: const TextStyle(
                color: Color(0xFF5A4A3A),
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              story.briefing,
              style: const TextStyle(
                color: Color(0xFF8B7355),
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => game.beginPlaying(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A1A0A),
                  foregroundColor: const Color(0xFFF5E6C8),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                  ),
                ),
                child: const Text('START WATCHING'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
