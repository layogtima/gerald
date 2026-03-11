import 'package:flutter/material.dart';

import '../game.dart';

/// Single game over overlay with 3 tension-based endings.
class GameOverOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final tension = game.tension;

    final String title;
    final String subtitle;
    final String stampText;
    final Color stampColor;

    if (tension <= 30) {
      // Low tension — boring ending
      title = 'SLEEPY SUBURB';
      subtitle =
          'Gerald hangs up his binoculars. The neighborhood was boring after all.\n\n'
          'Nobody was suspicious. Nobody was interesting. Gerald retires.';
      stampText = 'RETIRED';
      stampColor = const Color(0xFF607D8B);
    } else if (tension <= 70) {
      // Medium tension — normal ending
      title = 'NEIGHBORHOOD CAPTAIN';
      subtitle =
          'Gerald receives his quarterly "Neighborhood Captain" certificate.\n\n'
          "The HOA is satisfied. The parking spot is secure. Maple Drive is 'safe.'";
      stampText = 'COMMENDED';
      stampColor = const Color(0xFF2E6B35);
    } else {
      // High tension — paranoid twist
      title = 'THE WATCHER BECOMES\nTHE WATCHED';
      subtitle =
          "Gerald checks his mailbox. There's an incident report.\n\n"
          "It's about him. Signed by every neighbor on the street.\n\n"
          "'Subject observed engaging in prolonged surveillance of residential area. "
          "Recommend immediate intervention.'";
      stampText = 'CASE CLOSED';
      stampColor = const Color(0xFF8B1A1A);
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6C8),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFF8B7355), width: 1.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x66000000),
                blurRadius: 16,
                offset: Offset(0, 4)),
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
                fontSize: 22,
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
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.4,
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
