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
          color: const Color(0xEE0a0a0a),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF00ff41), width: 1),
          boxShadow: const [
            BoxShadow(color: Color(0x2200ff41), blurRadius: 16),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SHIFT ${game.currentRound + 1}',
              style: const TextStyle(
                color: Color(0xFF00ff41),
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quota: ${config.quota} reports',
              style: const TextStyle(
                color: Color(0xCC00ff41),
                fontSize: 18,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Time: ${config.roundDurationSeconds.toInt()}s',
              style: const TextStyle(
                color: Color(0x8800ff41),
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => game.beginPlaying(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ff41),
                foregroundColor: const Color(0xFF0a0a0a),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
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
