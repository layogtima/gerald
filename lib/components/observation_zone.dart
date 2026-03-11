import 'package:flame/components.dart';

import '../data/reports.dart';
import '../game.dart';
import 'npc.dart';

/// A fixed position where NPCs can appear.
class ObservationZone extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  final String label;
  Npc? _currentNpc;

  ObservationZone({required Vector2 position, required this.label})
      : super(position: position, size: Vector2(130, 130));

  bool get hasNpc => _currentNpc != null;

  void spawnNpc(ActivityData activityData, double visibilitySeconds) {
    if (_currentNpc != null) return;

    _currentNpc = Npc(
      activityData: activityData,
      visibilitySeconds: visibilitySeconds,
      parentZone: this,
    );
    add(_currentNpc!);
  }

  void clearNpc() {
    if (_currentNpc != null) {
      _currentNpc!.removeFromParent();
      _currentNpc = null;
    }
  }

  void onNpcRemoved() {
    _currentNpc = null;
  }
}
