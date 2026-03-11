import 'package:flame/components.dart';

import '../game.dart';

/// Gerald mutter — disabled. No subtext; let the plot play out.
class GeraldMutterComponent extends PositionComponent
    with HasGameReference<NeighborhoodWatchGame> {
  /// No-op: mutters are disabled.
  void triggerReaction(int tension) {}
}
