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
  // Prologue (tutorial) — few NPCs, long visibility
  RoundConfig(round: 0, totalNpcs: 4, npcVisibilitySeconds: 10.0, maxSimultaneousNpcs: 1, roundDurationSeconds: 90.0),
  // Act 1
  RoundConfig(round: 1, totalNpcs: 6, npcVisibilitySeconds: 8.0, maxSimultaneousNpcs: 2),
  RoundConfig(round: 2, totalNpcs: 8, npcVisibilitySeconds: 7.0, maxSimultaneousNpcs: 2),
  // Act 2
  RoundConfig(round: 3, totalNpcs: 8, npcVisibilitySeconds: 6.0, maxSimultaneousNpcs: 3),
  RoundConfig(round: 4, totalNpcs: 10, npcVisibilitySeconds: 5.0, maxSimultaneousNpcs: 3),
  // Act 3
  RoundConfig(round: 5, totalNpcs: 10, npcVisibilitySeconds: 4.0, maxSimultaneousNpcs: 3),
];
