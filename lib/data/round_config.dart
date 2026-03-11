class RoundConfig {
  final int round;
  final int quota;
  final double npcVisibilitySeconds;
  final int maxSimultaneousNpcs;
  final double roundDurationSeconds;

  const RoundConfig({
    required this.round,
    required this.quota,
    required this.npcVisibilitySeconds,
    required this.maxSimultaneousNpcs,
    this.roundDurationSeconds = 90.0,
  });
}

const List<RoundConfig> roundConfigs = [
  // Prologue (tutorial) — easy, long timer
  RoundConfig(round: 0, quota: 3, npcVisibilitySeconds: 8.0, maxSimultaneousNpcs: 1, roundDurationSeconds: 120.0),
  // Act 1
  RoundConfig(round: 1, quota: 5, npcVisibilitySeconds: 8.0, maxSimultaneousNpcs: 1),
  RoundConfig(round: 2, quota: 7, npcVisibilitySeconds: 6.0, maxSimultaneousNpcs: 2),
  // Act 2
  RoundConfig(round: 3, quota: 9, npcVisibilitySeconds: 5.0, maxSimultaneousNpcs: 3),
  RoundConfig(round: 4, quota: 11, npcVisibilitySeconds: 4.0, maxSimultaneousNpcs: 3),
  // Act 3
  RoundConfig(round: 5, quota: 13, npcVisibilitySeconds: 3.0, maxSimultaneousNpcs: 3),
];
