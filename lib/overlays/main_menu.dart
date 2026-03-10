import 'package:flutter/material.dart';

import '../game.dart';

class MainMenuOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const MainMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xEE1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD700), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'NEIGHBORHOOD\nWATCH',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The neighborhood isn\'t going\nto watch itself.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xAAFFFFFF),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 32),
            _buildButton('BEGIN SHIFT', () => game.startGame()),
            const SizedBox(height: 16),
            const Text(
              'Click suspicious neighbors → File reports → Meet quota',
              style: TextStyle(
                color: Color(0x88FFFFFF),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: const Color(0xFF1A1A2E),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      child: Text(text),
    );
  }
}
