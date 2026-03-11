import 'package:flutter/material.dart';

import '../game.dart';

class ReportUiOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const ReportUiOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final npc = game.observedNpc;
    if (npc == null) return const SizedBox.shrink();

    final activity = npc.activityData;

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: 600,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xF00a0a0a),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF00ff41), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3300ff41),
                  blurRadius: 12,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.assignment,
                          color: Color(0xFF00ff41), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'INCIDENT: ${activity.displayName.toUpperCase()}',
                          style: const TextStyle(
                            color: Color(0xFF00ff41),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => game.onReportDismissed(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.close,
                              color: Color(0x8800ff41), size: 22),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0x4400ff41)),
                  // Three report options
                  for (final report in activity.reports) ...[
                    _ReportButton(
                      level: report.level,
                      text: report.text,
                      points: report.points,
                      onTap: () => game.onReportFiled(report),
                    ),
                    if (report.level < 3) const SizedBox(height: 6),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  final int level;
  final String text;
  final int points;
  final VoidCallback onTap;

  const _ReportButton({
    required this.level,
    required this.text,
    required this.points,
    required this.onTap,
  });

  Color get _accentColor {
    return switch (level) {
      1 => const Color(0xFF00ff41),  // green — mild
      2 => const Color(0xFFffaa00),  // amber — suspicious
      3 => const Color(0xFFff4444),  // red — unhinged
      _ => const Color(0xFF888888),
    };
  }

  String get _levelLabel {
    return switch (level) {
      1 => 'MILD',
      2 => 'SUSPICIOUS',
      3 => 'UNHINGED',
      _ => '???',
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _accentColor.withAlpha(0x11),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: _accentColor.withAlpha(0x66), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                _levelLabel,
                style: const TextStyle(
                  color: Color(0xFF0a0a0a),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _accentColor.withAlpha(0xCC),
                  fontSize: 12,
                  height: 1.3,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+$points',
              style: TextStyle(
                color: _accentColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
