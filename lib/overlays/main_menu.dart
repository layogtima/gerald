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
          color: const Color(0xEE0a0a0a),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFFFAA00), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33FFAA00),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GERALD IS\nWATCHING',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFAA00),
                fontSize: 42,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 4,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The neighborhood isn\'t going\nto watch itself.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0x88FFAA00),
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 32),
            _buildButton('BEGIN SHIFT', () => game.startGame()),
            const SizedBox(height: 16),
            const Text(
              'Drag to scan  /  Tap to report  /  Meet quota',
              style: TextStyle(
                color: Color(0x66FFAA00),
                fontSize: 11,
                fontFamily: 'monospace',
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
        backgroundColor: const Color(0xFFFFAA00),
        foregroundColor: const Color(0xFF0a0a0a),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          letterSpacing: 3,
        ),
      ),
      child: Text(text),
    );
  }
}
