import 'package:flutter/material.dart';

import '../game.dart';

class RoundIntroOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundIntroOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final config = game.currentConfig;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xEE1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD700), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SHIFT ${game.currentRound + 1}',
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quota: ${config.quota} reports',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Time: ${config.roundDurationSeconds.toInt()}s',
              style: const TextStyle(
                color: Color(0xAAFFFFFF),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => game.beginPlaying(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF1A1A2E),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('START WATCHING'),
            ),
          ],
        ),
      ),
    );
  }
}
