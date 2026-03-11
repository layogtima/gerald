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
RoundConfig configForShift(int shift) {
  final totalNpcs = (5 + shift * 1.5).round().clamp(5, 14);
  final visibility = (10.0 - shift * 0.7).clamp(3.0, 10.0);
  final maxSimultaneous = shift <= 1 ? 1 : (shift <= 3 ? 2 : 3);
  final duration = (90.0 - shift * 5).clamp(50.0, 90.0);
  return RoundConfig(
    round: shift,
    totalNpcs: totalNpcs,
    npcVisibilitySeconds: visibility,
    maxSimultaneousNpcs: maxSimultaneous,
    roundDurationSeconds: duration,
  );
}
