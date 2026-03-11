class RoundConfig {
  final int round;
  final int totalNpcs;
  final double npcVisibilitySeconds;
  final int maxSimultaneousNpcs;
  final double roundDurationSeconds;

  const RoundConfig({
    required this.round,
    required this.totalNpcs,
    required this.npcVisibilitySeconds,
    required this.maxSimultaneousNpcs,
    this.roundDurationSeconds = 75.0,
  });
}

/// Dynamic config for any shift number (endless mode).
///
/// Tuned escalation curve:
/// - Early shifts (0-2): Gentle. Few NPCs, long visibility, generous time.
/// - Mid shifts (3-5): Building pressure. More NPCs, shorter windows.
/// - Late shifts (6-9): Challenging. Crowded street, brief appearances.
/// - Deep shifts (10+): Chaotic. Maximum NPCs, minimum visibility.
RoundConfig configForShift(int shift) {
  // NPCs: 4 → 6 → 8 → 10 → 12 → 14 → 16 (soft cap at 16)
  final totalNpcs = (4 + shift * 1.8).round().clamp(4, 16);

  // Visibility: 12s → 10s → 8s → 6s → 4s → 3s (floor at 2.5s)
  final visibility = (12.0 - shift * 1.0).clamp(2.5, 12.0);

  // Simultaneous: 1 → 1 → 2 → 2 → 3 → 3 → 4 (cap at 4)
  final maxSimultaneous = shift <= 1 ? 1 : (shift <= 3 ? 2 : (shift <= 5 ? 3 : 4));

  // Duration: 100s → 90s → 80s → 70s → 60s → 55s (floor at 45s)
  final duration = (100.0 - shift * 6).clamp(45.0, 100.0);

  return RoundConfig(
    round: shift,
    totalNpcs: totalNpcs,
    npcVisibilitySeconds: visibility,
    maxSimultaneousNpcs: maxSimultaneous,
    roundDurationSeconds: duration,
  );
}
