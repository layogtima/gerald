import 'package:flutter/material.dart';

import '../game.dart';

/// Minimal between-shift overlay — just a button to start watching.
class RoundIntroOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundIntroOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xCC000000),
      child: Center(
        child: GestureDetector(
          onTap: () => game.beginPlaying(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(color: const Color(0xFFFFAA00), width: 2),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66FFAA00),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text(
              'START WATCHING',
              style: TextStyle(
                color: Color(0xFFFFCC44),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
