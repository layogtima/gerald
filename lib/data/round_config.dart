class RoundConfig {
  final int round;
  final int totalNpcs; // total NPCs to spawn this shift
  final double npcVisibilitySeconds;
  final int maxSimultaneousNpcs;
  final double roundDurationSeconds; // safety cap

  const RoundConfig({
    required this.round,
    required this.totalNpcs,
    required this.npcVisibilitySeconds,
    required this.maxSimultaneousNpcs,
    this.roundDurationSeconds = 75.0,
  });
}

const List<RoundConfig> roundConfigs = [
  // Prologue — few NPCs, long visibility, gentle start
  RoundConfig(round: 0, totalNpcs: 5, npcVisibilitySeconds: 10.0, maxSimultaneousNpcs: 1, roundDurationSeconds: 90.0),
  // Shift 1 — weirdness begins
  RoundConfig(round: 1, totalNpcs: 7, npcVisibilitySeconds: 8.0, maxSimultaneousNpcs: 2),
  // Shift 2 — building
  RoundConfig(round: 2, totalNpcs: 9, npcVisibilitySeconds: 7.0, maxSimultaneousNpcs: 2),
  // Shift 3 — escalating
  RoundConfig(round: 3, totalNpcs: 10, npcVisibilitySeconds: 6.0, maxSimultaneousNpcs: 3),
  // Shift 4 — the watchers appear
  RoundConfig(round: 4, totalNpcs: 11, npcVisibilitySeconds: 5.0, maxSimultaneousNpcs: 3),
  // Shift 5 — finale
  RoundConfig(round: 5, totalNpcs: 12, npcVisibilitySeconds: 4.0, maxSimultaneousNpcs: 3),
];
